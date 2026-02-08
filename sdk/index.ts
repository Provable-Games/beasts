/**
 * Beast SDK
 *
 * TypeScript SDK for Beast NFT data lookups and local image rendering.
 * Provides static lookup tables and utility functions for working with
 * Loot Survivor Beast NFTs.
 */

// Re-export types
export type { BeastApiResponse, BeastCombatType, BeastTier, BeastId } from "./types";

// Re-export lookup tables and functions
export {
  BEAST_NAMES,
  BEAST_TIERS,
  BEAST_TYPES,
  ITEM_NAME_PREFIXES,
  ITEM_NAME_SUFFIXES,
  getBeastName,
  getBeastTier,
  getBeastType,
  getPrefix,
  getSuffix,
} from "./lookups";

// Re-export image functions
export {
  getBeastImageUrl,
  getBeastImageUrls,
  getBeastStaticImageUrl,
  isLocalBeastImage,
} from "./images";

// Re-export on-chain image data URIs
export { getBeastImageDataUri } from "./image-data";

// Re-export SVG functions
export { generateBeastSvg, generateBeastSvgFromNFT } from "./svg";
export type { BeastSvgInput } from "./svg";

// Import for local use
import { getBeastName, getBeastTier, getBeastType } from "./lookups";

/**
 * Compose the full display name for a beast
 * Format: "Prefix Suffix" BeastName (e.g., "Apocalypse Bane" Dragon)
 *
 * @param beastId - Beast type ID (1-75)
 * @param prefix - Prefix name (already resolved, e.g., "Apocalypse")
 * @param suffix - Suffix name (already resolved, e.g., "Bane")
 * @returns Full display name
 */
export function getFullBeastName(
  beastId: number,
  prefix: string | null,
  suffix: string | null
): string {
  const beastName = getBeastName(beastId);

  if (prefix && suffix) {
    return `"${prefix} ${suffix}" ${beastName}`;
  }
  if (prefix) {
    return `"${prefix}" ${beastName}`;
  }
  if (suffix) {
    return `"${suffix}" ${beastName}`;
  }

  return beastName;
}

/**
 * Check if a token is a genesis beast (first 75 minted)
 * Genesis beasts have token IDs 1-75
 */
export function isGenesisBeast(tokenId: number | string): boolean {
  const id = typeof tokenId === "string" ? parseInt(tokenId, 10) : tokenId;
  return id >= 1 && id <= 75;
}

/**
 * Get the display color for a beast tier
 * T1 = Orange (rarest), T5 = White (common)
 */
export function getTierColor(tier: number): string {
  const colors: Record<number, string> = {
    1: "#ff8800", // Orange - T1 (strongest)
    2: "#8c00bf", // Purple - T2
    3: "#0066ff", // Blue - T3
    4: "#00cc00", // Green - T4
    5: "#cccccc", // Gray - T5 (weakest)
  };
  return colors[tier] ?? "#cccccc";
}

/**
 * Calculate a beast's power based on tier and level
 * Power = (6 - tier) * level
 */
export function calculatePower(tier: number, level: number): number {
  return (6 - tier) * level;
}

/**
 * Get complete beast info from a beast ID
 * Useful for enriching minimal beast data
 */
export function getBeastInfo(beastId: number): {
  name: string;
  tier: number;
  type: string;
  tierColor: string;
} {
  const tier = getBeastTier(beastId);
  return {
    name: getBeastName(beastId),
    tier,
    type: getBeastType(beastId),
    tierColor: getTierColor(tier),
  };
}
