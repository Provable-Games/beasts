/**
 * Beast SVG Renderer
 *
 * TypeScript port of the Cairo beast_svg.cairo on-chain SVG renderer.
 * Generates identical SVG card images for Beast NFTs locally.
 */

import { getBeastName, getBeastTier, getBeastType } from "./lookups";
import { getBeastImageDataUri } from "./image-data";
import { calculatePower } from "./utils";
import {
  getSvgTierColor,
  VT323_FONT_BASE64,
  SVG_GOLD_GRADIENT,
  SVG_PANEL_GRADIENT,
  SVG_SHINY_RIM_GRADIENT,
  SVG_SPARKLE_GRADIENT,
  SVG_LOGO_RAINBOW_GRADIENT,
  SVG_HEART_ICON,
  SVG_BOLT_ICON,
  SVG_CROWN_ICON,
  SVG_TROPHY_ICON,
  SVG_PIN_PATTERN,
  SVG_LOGO_PATH,
} from "./svg-constants";

/**
 * Input for generating a Beast SVG card.
 */
export interface BeastSvgInput {
  beastId: number; // 1-75
  prefix: string | null; // Resolved prefix name, null for genesis
  suffix: string | null; // Resolved suffix name, null for genesis
  tier: number; // 1-5
  level: number;
  health: number;
  power: number;
  shiny: boolean;
  rank: number | null; // 1=crown, >1=trophy, 0/null=none
  imageUrl?: string; // Optional override, defaults to getBeastImageDataUri(beastId, shiny)
}

/**
 * BeastNFT type matching the one in useUserBeasts.ts.
 * Imported here as a local type alias to avoid circular dependency.
 */
interface BeastNFT {
  tokenId: string;
  beastId: number | null;
  prefix: string | null;
  suffix: string | null;
  tier: number | null;
  level: number | null;
  health: number | null;
  power: number | null;
  rank: number | null;
  shiny: boolean;
  type: string | null;
  imageUrl: string | null;
  [key: string]: unknown;
}

/** Escape special characters for safe SVG text embedding. */
function escapeXml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/'/g, "&apos;")
    .replace(/"/g, "&quot;");
}

/** Build the <defs> block with gradients, icons, patterns, and font style. */
function buildDefs(isShiny: boolean): string {
  // The isShiny param is accepted for future use (e.g., conditional defs).
  // Currently all defs are always included, matching the Cairo contract.
  void isShiny;

  return (
    "<defs>" +
    "<style>@font-face{font-family:'VT323';src:url(data:application/font-woff2;charset=utf-8;base64," +
    VT323_FONT_BASE64 +
    ") format('woff2');font-weight:normal;font-style:normal;}" +
    ".label{fill:#c9c9d1;font-size:14px;letter-spacing:0.5px;font-weight:500}" +
    ".valL{fill:#fff;font-size:18px;font-weight:500}" +
    "text{font-family:'VT323',monospace;}" +
    "</style>" +
    SVG_GOLD_GRADIENT +
    SVG_PANEL_GRADIENT +
    SVG_SHINY_RIM_GRADIENT +
    SVG_SPARKLE_GRADIENT +
    SVG_LOGO_RAINBOW_GRADIENT +
    SVG_HEART_ICON +
    SVG_BOLT_ICON +
    SVG_CROWN_ICON +
    SVG_TROPHY_ICON +
    SVG_PIN_PATTERN +
    "</defs>"
  );
}

/** Build the background rect with pin pattern. */
function buildBackground(): string {
  return "<rect width='250' height='350' rx='12' fill='url(#pin)'/>";
}

/** Build the top-left logo with tier/rainbow fill + pulse animation. */
function buildLogo(tier: number, isShiny: boolean): string {
  const logoFill = isShiny
    ? "url(#logo_pastel_rainbow)"
    : getSvgTierColor(tier);

  return (
    "<g transform='translate(15, 15)'>" +
    "<g id='logoPulse' transform='scale(0.029)'>" +
    `<path fill-rule='evenodd' clip-rule='evenodd' d='${SVG_LOGO_PATH}' fill='${logoFill}'/>` +
    "<animate attributeName='opacity' values='0.6;1;0.6' dur='3s' repeatCount='indefinite'/>" +
    "</g></g>"
  );
}

/** Build rank display: crown for rank 1, trophy for rank >1, or empty. */
function buildRankDisplay(rank: number | null): string {
  if (rank === 1) {
    return (
      "<use href='#crown' x='218' y='9' width='20' height='20'/>" +
      "<text x='227' y='43' text-anchor='middle' style='fill:#e6c56e;font-size:19px;'>1</text>"
    );
  }
  if (rank != null && rank > 1) {
    return (
      "<use href='#trophy' x='218' y='9' width='20' height='20'/>" +
      `<text x='227' y='43' text-anchor='middle' style='fill:#b0b0b6;font-size:19px;'>${rank}</text>`
    );
  }
  return "";
}

/** Build beast name layout: 2-line for standard beasts, 1-line for genesis. */
function buildBeastName(
  beastId: number,
  prefix: string | null,
  suffix: string | null
): string {
  const beastName = escapeXml(getBeastName(beastId));

  if (prefix || suffix) {
    // Standard beast: prefix/suffix on line 1, beast name on line 2
    let quotedName = '"';
    if (prefix) {
      quotedName += escapeXml(prefix);
      if (suffix) {
        quotedName += " ";
      }
    }
    if (suffix) {
      quotedName += escapeXml(suffix);
    }
    quotedName += '"';

    return (
      `<text x='125' y='26' text-anchor='middle' style='fill:#fff;font-size:14px;letter-spacing:1px'>${quotedName}</text>` +
      `<text x='125' y='50' text-anchor='middle' style='fill:#fff;font-size:30px;letter-spacing:1px'>${beastName}</text>`
    );
  }

  // Genesis beast: single large line
  return `<text x='125' y='47' text-anchor='middle' style='fill:#fff;font-size:34px;letter-spacing:1px'>${beastName}</text>`;
}

/** Build the beast image with clip path and foreignObject for crisp iOS Safari scaling. */
function buildBeastImage(imageUrl: string): string {
  return (
    "<clipPath id='artClip'>" +
    "<rect width='144' height='144' rx='8'/>" +
    "</clipPath>" +
    "<rect x='15' y='58' width='220' height='144' rx='8' fill='#000'/>" +
    "<g transform='translate(61, 65)' clip-path='url(#artClip)'>" +
    `<foreignObject x='1' y='1' width='128' height='128'>` +
    `<xhtml:img xmlns:xhtml='http://www.w3.org/1999/xhtml' src='${escapeXml(imageUrl)}' style='width:100%;height:100%;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;'/>` +
    `</foreignObject>` +
    "</g>" +
    "<rect x='15' y='58' width='220' height='144' rx='8' fill='none' stroke='#fff' stroke-opacity='.08' stroke-width='2'/>"
  );
}

/** Build the TIER/LEVEL/TYPE stats panels. */
function buildStatsPanel(
  tier: number,
  level: number,
  beastType: string
): string {
  return (
    "<g transform='translate(15 210)'>" +
    "<rect width='70' height='50' rx='5' fill='url(#panel)'/>" +
    "<text x='35' y='18' text-anchor='middle' class='label'>TIER</text>" +
    `<text x='35' y='38' text-anchor='middle' class='valL'>${tier}</text>` +
    "<g transform='translate(75)'>" +
    "<rect width='70' height='50' rx='5' fill='url(#panel)'/>" +
    "<text x='35' y='18' text-anchor='middle' class='label'>LEVEL</text>" +
    `<text x='35' y='38' text-anchor='middle' class='valL'>${level}</text>` +
    "</g>" +
    "<g transform='translate(150)'>" +
    "<rect width='70' height='50' rx='5' fill='url(#panel)'/>" +
    "<text x='35' y='18' text-anchor='middle' class='label'>TYPE</text>" +
    `<text x='35' y='37' text-anchor='middle' class='valL'>${escapeXml(beastType)}</text>` +
    "</g>" +
    "</g>"
  );
}

/** Build the POWER and HEALTH panels with icons. */
function buildPowerHealthPanel(power: number, health: number): string {
  return (
    // Power panel
    "<g transform='translate(15 265)'>" +
    "<rect width='107' height='65' rx='5' fill='url(#panel)'/>" +
    "<text x='35' y='22' text-anchor='middle' class='label'>POWER</text>" +
    `<text x='35' y='46' text-anchor='middle' class='valL'>${power}</text>` +
    "<g transform='translate(82,31.15) scale(1)'>" +
    "<use href='#bolt' pointer-events='none'/>" +
    "</g>" +
    "</g>" +
    // Health panel
    "<g transform='translate(128 265)'>" +
    "<rect width='107' height='65' rx='5' fill='url(#panel)'/>" +
    "<text x='35' y='22' text-anchor='middle' class='label'>HEALTH</text>" +
    `<text x='35' y='46' text-anchor='middle' class='valL'>${health}</text>` +
    "<g transform='translate(77.3,32.744) scale(0.75)'>" +
    "<use href='#heart' pointer-events='none'/>" +
    "</g>" +
    "</g>"
  );
}

/** Build the outer frame: rainbow animated for shiny, gold for non-shiny. */
function buildFrame(isShiny: boolean): string {
  const stroke = isShiny ? "url(#shinyRim)" : "url(#gold)";
  return `<rect x='4.5' y='4.5' width='241' height='341' rx='9' fill='none' stroke='${stroke}' stroke-width='4'/>`;
}

/**
 * Generate a complete SVG card for a Beast NFT.
 * Output matches the on-chain Cairo beast_svg.cairo renderer exactly.
 */
export function generateBeastSvg(input: BeastSvgInput): string {
  const {
    beastId,
    prefix,
    suffix,
    tier,
    level,
    health,
    power,
    shiny,
    rank,
  } = input;

  const imageUrl =
    input.imageUrl ?? getBeastImageDataUri(beastId, shiny);
  const beastType = getBeastType(beastId);

  return (
    "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='250' height='350' viewBox='0 0 250 350'>" +
    "<animate attributeName='opacity' dur='2.2s' from='1' to='0.999' repeatCount='indefinite'/>" +
    buildDefs(shiny) +
    buildBackground() +
    buildLogo(tier, shiny) +
    buildRankDisplay(rank) +
    buildBeastName(beastId, prefix, suffix) +
    buildBeastImage(imageUrl) +
    buildStatsPanel(tier, level, beastType) +
    buildPowerHealthPanel(power, health) +
    buildFrame(shiny) +
    "</svg>"
  );
}

/**
 * Convenience wrapper: generate SVG from a BeastNFT object.
 * Handles null fields gracefully with sensible defaults.
 */
export function generateBeastSvgFromNFT(beast: BeastNFT): string {
  const beastId = beast.beastId ?? 1;
  const tier = beast.tier ?? getBeastTier(beastId);
  const level = beast.level ?? 1;
  const health = beast.health ?? 0;
  const power = beast.power ?? calculatePower(tier, level);

  return generateBeastSvg({
    beastId,
    prefix: beast.prefix,
    suffix: beast.suffix,
    tier,
    level,
    health,
    power,
    shiny: beast.shiny,
    rank: beast.rank,
    imageUrl: beast.imageUrl ?? undefined,
  });
}
