#!/usr/bin/env node
/**
 * Compare on-chain token_uri SVGs with our SDK-generated SVGs.
 *
 * Calls the beast contract for 11 token IDs via sncast, decodes the
 * on-chain SVG, generates the SDK SVG, and diffs them.
 *
 * Usage: node scripts/compare-onchain-svg.mjs
 */

import { execSync } from "child_process";

const CONTRACT = "0x046da8955829adf2bda310099a0063451923f02e648cf25a1203aac6335cf0e4";
const TOKEN_IDS = [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110];

// Dynamically import the SDK (it's TypeScript, need tsx or compile)
// We'll use a simpler approach: just call sncast and decode the on-chain SVG,
// then generate SDK SVG via a small inline function.

/**
 * Call sncast and return the raw response string.
 */
function callTokenUri(tokenId) {
  const cmd = `sncast call -d ${CONTRACT} -f token_uri -c ${tokenId} 0 --network mainnet 2>&1`;
  const output = execSync(cmd, { encoding: "utf-8", timeout: 30000 });

  // Extract the base64 JSON from the response line
  const match = output.match(/Response:\s+"(data:application\/json;base64,[^"]+)"/);
  if (!match) {
    // Try alternate: the response might just be the raw string
    const altMatch = output.match(/"(data:[^"]+)"/);
    if (!altMatch) {
      throw new Error(`Could not parse sncast output for token ${tokenId}:\n${output.slice(0, 500)}`);
    }
    return altMatch[1];
  }
  return match[1];
}

/**
 * Decode a data:application/json;base64,... URI to get the JSON metadata,
 * then extract the SVG from the "image" field.
 */
function extractOnchainSvg(dataUri) {
  // Strip prefix
  const base64Json = dataUri.replace("data:application/json;base64,", "");
  // On-chain JSON has literal newlines/tabs in the description string — sanitize for JSON.parse
  const raw = Buffer.from(base64Json, "base64").toString("utf-8");
  const sanitized = raw.replace(/[\x00-\x1f\x7f]/g, (c) => {
    if (c === "\n") return "\\n";
    if (c === "\r") return "\\r";
    if (c === "\t") return "\\t";
    return "";
  });
  const json = JSON.parse(sanitized);

  // The image field is data:image/svg+xml;base64,...
  const svgDataUri = json.image;
  if (!svgDataUri) {
    throw new Error("No 'image' field in token metadata");
  }

  const base64Svg = svgDataUri.replace("data:image/svg+xml;base64,", "");
  return Buffer.from(base64Svg, "base64").toString("utf-8");
}

/**
 * Extract beast metadata from the on-chain JSON.
 */
function extractMetadata(dataUri) {
  const base64Json = dataUri.replace("data:application/json;base64,", "");
  // On-chain JSON has literal newlines/tabs in the description string — sanitize for JSON.parse
  const raw = Buffer.from(base64Json, "base64").toString("utf-8");
  const sanitized = raw.replace(/[\x00-\x1f\x7f]/g, (c) => {
    if (c === "\n") return "\\n";
    if (c === "\r") return "\\r";
    if (c === "\t") return "\\t";
    return "";
  });
  const json = JSON.parse(sanitized);
  return json;
}

/**
 * Normalize an SVG for comparison.
 * The SDK now uses foreignObject matching on-chain output, so no
 * transformation is needed. This function is kept as a no-op hook
 * for any future normalization needs.
 */
function normalizeOnchainSvg(svg) {
  return svg;
}

async function main() {
  // Dynamically load the SDK via tsx
  // First, let's build the SDK SVG generator
  const { generateBeastSvg } = await import("tsx/esm/api").then(tsx => {
    return tsx.register();
  }).then(() => {
    return import("../svg.ts");
  }).catch(() => {
    return import("../svg.ts");
  });

  const { getBeastImageDataUri } = await import("../image-data.ts").catch(() => {
    return import("../image-data.ts");
  });

  console.log("Comparing on-chain SVGs with SDK output for token IDs:", TOKEN_IDS.join(", "));
  console.log("=".repeat(70));

  let passed = 0;
  let failed = 0;

  for (const tokenId of TOKEN_IDS) {
    process.stdout.write(`\nToken #${tokenId}: `);

    try {
      // Fetch on-chain data
      const dataUri = callTokenUri(tokenId);
      const metadata = extractMetadata(dataUri);
      const onchainSvg = extractOnchainSvg(dataUri);

      // Extract beast attributes from on-chain metadata
      const attrs = {};
      for (const attr of metadata.attributes || []) {
        attrs[attr.trait_type] = attr.value;
      }

      // Build SDK input from on-chain metadata
      const beastId = parseInt(attrs["Species ID"] || attrs["Beast ID"] || "1");
      const tier = parseInt(attrs["Tier"]?.replace("T", "") || "1");
      const level = parseInt(attrs["Level"] || "1");
      const health = parseInt(attrs["Health"] || "0");
      const power = parseInt(attrs["Power"] || "0");
      const shiny = attrs["Shiny"] === "Yes" || attrs["Shiny"] === "true" || attrs["Shiny"] === true || attrs["Shiny"] === "1";
      const animated = attrs["Animated"] === "1" || attrs["Animated"] === "Yes" || attrs["Animated"] === true;
      const prefix = attrs["Prefix"] && attrs["Prefix"] !== "None" ? attrs["Prefix"] : null;
      const suffix = attrs["Suffix"] && attrs["Suffix"] !== "None" ? attrs["Suffix"] : null;

      // Rank: look for rank attribute
      let rank = null;
      if (attrs["Rank"]) {
        rank = parseInt(attrs["Rank"]);
        if (isNaN(rank)) rank = null;
      }

      // Use animated GIF image when beast is animated (matches on-chain behavior)
      const imageUrl = getBeastImageDataUri(beastId, shiny, animated);

      const sdkSvg = generateBeastSvg({
        beastId,
        prefix,
        suffix,
        tier,
        level,
        health,
        power,
        shiny,
        rank,
        imageUrl,
      });

      // Normalize the on-chain SVG (convert foreignObject to <image>)
      const normalizedOnchain = normalizeOnchainSvg(onchainSvg);

      if (normalizedOnchain === sdkSvg) {
        console.log(`PASS (${metadata.name})`);
        passed++;
      } else {
        console.log(`DIFF (${metadata.name})`);
        failed++;

        // Find first difference
        const minLen = Math.min(normalizedOnchain.length, sdkSvg.length);
        let diffPos = -1;
        for (let i = 0; i < minLen; i++) {
          if (normalizedOnchain[i] !== sdkSvg[i]) {
            diffPos = i;
            break;
          }
        }
        if (diffPos === -1 && normalizedOnchain.length !== sdkSvg.length) {
          diffPos = minLen;
        }

        if (diffPos >= 0) {
          const ctx = 60;
          const start = Math.max(0, diffPos - ctx);
          const end = Math.min(Math.max(normalizedOnchain.length, sdkSvg.length), diffPos + ctx);
          console.log(`  First diff at position ${diffPos} (lengths: on-chain=${normalizedOnchain.length}, sdk=${sdkSvg.length}):`);
          console.log(`  On-chain: ...${normalizedOnchain.slice(start, end)}...`);
          console.log(`  SDK:      ...${sdkSvg.slice(start, end)}...`);

          // Strip font base64 from both and compare the rest
          const fontMarker = "data:application/font-woff2";
          const stripFont = (s) => {
            const start = s.indexOf(fontMarker);
            if (start === -1) return s;
            const end = s.indexOf(")", start);
            return s.slice(0, start) + "FONT_STRIPPED" + s.slice(end);
          };
          const onchainNoFont = stripFont(normalizedOnchain);
          const sdkNoFont = stripFont(sdkSvg);
          const match2 = onchainNoFont === sdkNoFont;
          console.log(`  Match excluding font: ${match2 ? "YES" : "NO"}`);
          if (!match2) {
            // Find first non-font diff
            for (let i = 0; i < Math.min(onchainNoFont.length, sdkNoFont.length); i++) {
              if (onchainNoFont[i] !== sdkNoFont[i]) {
                const s = Math.max(0, i - 40);
                const e = Math.min(Math.max(onchainNoFont.length, sdkNoFont.length), i + 40);
                console.log(`  Non-font diff at pos ${i}:`);
                console.log(`    On-chain: ...${onchainNoFont.slice(s, e)}...`);
                console.log(`    SDK:      ...${sdkNoFont.slice(s, e)}...`);
                break;
              }
            }
            if (onchainNoFont.length !== sdkNoFont.length) {
              console.log(`  Length diff (no font): on-chain=${onchainNoFont.length}, sdk=${sdkNoFont.length}`);
            }
          }
        }
      }
    } catch (err) {
      console.log(`ERROR: ${err.message}`);
      failed++;
    }
  }

  console.log("\n" + "=".repeat(70));
  console.log(`Results: ${passed} passed, ${failed} failed out of ${TOKEN_IDS.length}`);
  process.exit(failed > 0 ? 1 : 0);
}

main();
