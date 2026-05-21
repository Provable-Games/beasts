/**
 * Beast SDK Metadata Helpers
 *
 * Utilities for decoding and parsing on-chain token URIs.
 */

import type {
  BeastMetadataJson,
  BeastMetadataAttributesParsed,
  BeastMetadataAttribute,
  MetadataValidationResult,
  MetadataValidationIssue,
  ParsedTokenUri,
  TokenUriParseResult,
} from "./types";

const JSON_DATA_URI_PREFIX = "data:application/json;base64,";
const SVG_DATA_URI_PREFIX = "data:image/svg+xml;base64,";

function decodeBase64(data: string): string {
  const globalAny = globalThis as unknown as {
    Buffer?: {
      from: (input: string, encoding: string) => { toString: (enc: string) => string };
    };
    atob?: (input: string) => string;
    TextDecoder?: new (label?: string) => { decode: (input: Uint8Array) => string };
  };

  if (globalAny.Buffer) {
    return globalAny.Buffer.from(data, "base64").toString("utf8");
  }

  if (globalAny.atob) {
    const binary = globalAny.atob(data);
    if (globalAny.TextDecoder) {
      const bytes = Uint8Array.from(binary, (c) => c.charCodeAt(0));
      return new globalAny.TextDecoder("utf-8").decode(bytes);
    }
    return binary;
  }

  throw new Error("No base64 decoder available in this environment");
}

function encodeBase64(data: string): string {
  const globalAny = globalThis as unknown as {
    Buffer?: {
      from: (input: string, encoding: string) => {
        toString: (enc: string) => string;
      };
    };
    btoa?: (input: string) => string;
    TextEncoder?: new () => { encode: (input: string) => Uint8Array };
  };

  if (globalAny.Buffer) {
    return globalAny.Buffer.from(data, "utf8").toString("base64");
  }

  if (globalAny.btoa) {
    if (globalAny.TextEncoder) {
      const bytes = new globalAny.TextEncoder().encode(data);
      let binary = "";
      for (const byte of bytes) {
        binary += String.fromCharCode(byte);
      }
      return globalAny.btoa(binary);
    }
    return globalAny.btoa(data);
  }

  throw new Error("No base64 encoder available in this environment");
}

function sanitizeJsonString(raw: string): string {
  return raw.replace(/[\x00-\x1f\x7f]/g, (c) => {
    if (c === "\n") return "\\n";
    if (c === "\r") return "\\r";
    if (c === "\t") return "\\t";
    return "";
  });
}

/** Decode a data:application/json;base64 token URI to JSON text. */
export function decodeTokenUriJson(tokenUri: string): string {
  if (tokenUri.startsWith(JSON_DATA_URI_PREFIX)) {
    const base64 = tokenUri.slice(JSON_DATA_URI_PREFIX.length);
    return decodeBase64(base64);
  }

  return tokenUri;
}

/** Build a token URI from a JSON string. */
export function buildTokenUriFromJsonString(json: string): string {
  return `${JSON_DATA_URI_PREFIX}${encodeBase64(json)}`;
}

/** Build a token URI from a JSON object. */
export function buildTokenUri(metadata: BeastMetadataJson): string {
  return buildTokenUriFromJsonString(JSON.stringify(metadata));
}

/** Parse a token URI into its JSON metadata object. */
export function parseTokenUri(tokenUri: string): BeastMetadataJson {
  const raw = decodeTokenUriJson(tokenUri);
  const sanitized = sanitizeJsonString(raw);
  return JSON.parse(sanitized) as BeastMetadataJson;
}

/** Extract the SVG string from a data:image/svg+xml;base64 URI. */
export function decodeSvgDataUri(imageDataUri: string): string {
  if (!imageDataUri.startsWith(SVG_DATA_URI_PREFIX)) {
    return imageDataUri;
  }
  const base64 = imageDataUri.slice(SVG_DATA_URI_PREFIX.length);
  return decodeBase64(base64);
}

/** Build a data:image/svg+xml;base64 URI from SVG markup. */
export function encodeSvgDataUri(svg: string): string {
  return `${SVG_DATA_URI_PREFIX}${encodeBase64(svg)}`;
}

/** Build a trait_type -> value map from metadata attributes. */
export function getAttributeMap(
  attributes: BeastMetadataAttribute[]
): Record<string, string> {
  const map: Record<string, string> = {};
  for (const attr of attributes) {
    map[attr.trait_type] = String(attr.value ?? "");
  }
  return map;
}

/** Validate a metadata JSON object shape. */
export function validateMetadataJson(
  metadata: unknown
): MetadataValidationResult {
  const issues: MetadataValidationIssue[] = [];
  const isObject = (value: unknown): value is Record<string, unknown> =>
    !!value && typeof value === "object";

  if (!isObject(metadata)) {
    return {
      ok: false,
      issues: [{ path: "", message: "Metadata must be an object" }],
    };
  }

  if (typeof metadata.name !== "string") {
    issues.push({ path: "name", message: "name must be a string" });
  }
  if (typeof metadata.description !== "string") {
    issues.push({ path: "description", message: "description must be a string" });
  }
  if (typeof metadata.image !== "string") {
    issues.push({ path: "image", message: "image must be a string" });
  }
  if (!Array.isArray(metadata.attributes)) {
    issues.push({ path: "attributes", message: "attributes must be an array" });
  } else {
    metadata.attributes.forEach((attr: unknown, idx: number) => {
      if (!isObject(attr)) {
        issues.push({
          path: `attributes[${idx}]`,
          message: "attribute must be an object",
        });
        return;
      }
      if (typeof attr.trait_type !== "string") {
        issues.push({
          path: `attributes[${idx}].trait_type`,
          message: "trait_type must be a string",
        });
      }
      if (typeof attr.value !== "string") {
        issues.push({
          path: `attributes[${idx}].value`,
          message: "value must be a string",
        });
      }
    });
  }

  return { ok: issues.length === 0, issues };
}

/** Parse on-chain metadata attributes into a typed structure. */
export function parseMetadataAttributes(
  metadata: BeastMetadataJson
): BeastMetadataAttributesParsed {
  const map = getAttributeMap(metadata.attributes ?? []);
  const num = (key: string): number | null => {
    if (!(key in map)) return null;
    const value = Number(map[key]);
    return Number.isFinite(value) ? value : null;
  };

  return {
    tokenId: num("Token ID"),
    beastId: num("Beast ID"),
    beast: map["Beast"] ?? null,
    type: map["Type"] ?? null,
    tier: num("Tier"),
    prefix: map["Prefix"] ?? null,
    suffix: map["Suffix"] ?? null,
    level: num("Level"),
    health: num("Health"),
    power: num("Power"),
    rank: num("Rank"),
    adventurersKilled: num("Adventurers Killed"),
    lastKilledBy: num("Last Killed By"),
    lastDeathTimestamp: num("Last Death Timestamp"),
    shiny: num("Shiny"),
    animated: num("Animated"),
    genesis: num("Genesis"),
  };
}

/** Parse a token URI and return a richer typed view of the metadata. */
export function parseTokenUriDetailed(
  tokenUri: string,
  options?: { decodeSvg?: boolean }
): ParsedTokenUri {
  const metadata = parseTokenUri(tokenUri);
  const attributeMap = getAttributeMap(metadata.attributes ?? []);
  const attributes = parseMetadataAttributes(metadata);
  const imageSvg = options?.decodeSvg ? decodeSvgDataUri(metadata.image) : undefined;

  return { metadata, attributeMap, attributes, imageSvg };
}

/** Safe parse with optional validation and SVG decode. */
export function parseTokenUriSafe(
  tokenUri: string,
  options?: { decodeSvg?: boolean; validate?: boolean }
): TokenUriParseResult {
  try {
    const metadata = parseTokenUri(tokenUri);

    if (options?.validate) {
      const validation = validateMetadataJson(metadata);
      if (!validation.ok) {
        return {
          ok: false,
          error: "Invalid metadata JSON",
          issues: validation.issues,
        };
      }
    }

    const value = parseTokenUriDetailed(tokenUri, { decodeSvg: options?.decodeSvg });
    return { ok: true, value };
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    return { ok: false, error: message };
  }
}
