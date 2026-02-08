/**
 * Beast SDK Type Definitions
 *
 * Types for Beast NFT data and API responses.
 */

/**
 * Beast API response format (from Summit API)
 * Uses snake_case as returned from the server
 */
export interface BeastApiResponse {
  token_id: number;
  id: number; // beast_id (1-75)
  name: string; // Beast species name (e.g., "Dragon")
  prefix: string; // Prefix name (resolved, e.g., "Apocalypse")
  suffix: string; // Suffix name (resolved, e.g., "Bane")
  tier: number; // 1-5 (1 = highest)
  type: string; // "Magic", "Hunter", "Brute"
  power: number;
  level: number;
  health: number;
  shiny: number; // 0 or 1
  animated: number; // 0 or 1
  adventurers_killed: number;
  last_killed_by: number;
  last_dm_death_timestamp: number;
}

/**
 * Core beast input attributes (matches on-chain PackableBeast fields).
 */
export interface BeastInput {
  beastId: number;
  prefix: number;
  suffix: number;
  level: number;
  health: number;
  shiny: number;
  animated: number;
}

/**
 * Validation result for beast inputs.
 */
export interface ValidationResult {
  ok: boolean;
  error?: string;
}

/**
 * Token URI metadata attribute.
 */
export interface BeastMetadataAttribute {
  trait_type: string;
  value: string;
}

/**
 * Token URI metadata JSON shape.
 */
export interface BeastMetadataJson {
  name: string;
  description: string;
  image: string;
  attributes: BeastMetadataAttribute[];
  [key: string]: unknown;
}

/**
 * Parsed metadata attributes with typed fields.
 */
export interface BeastMetadataAttributesParsed {
  tokenId: number | null;
  beastId: number | null;
  beast: string | null;
  type: string | null;
  tier: number | null;
  prefix: string | null;
  suffix: string | null;
  level: number | null;
  health: number | null;
  power: number | null;
  rank: number | null;
  adventurersKilled: number | null;
  lastKilledBy: number | null;
  lastDeathTimestamp: number | null;
  shiny: number | null;
  animated: number | null;
  genesis: number | null;
}

/**
 * Metadata validation issue.
 */
export interface MetadataValidationIssue {
  path: string;
  message: string;
}

/**
 * Metadata validation result.
 */
export interface MetadataValidationResult {
  ok: boolean;
  issues: MetadataValidationIssue[];
}

/**
 * Parsed token URI with convenience projections.
 */
export interface ParsedTokenUri {
  metadata: BeastMetadataJson;
  attributeMap: Record<string, string>;
  attributes: BeastMetadataAttributesParsed;
  imageSvg?: string;
}

/**
 * Safe token URI parse result.
 */
export interface TokenUriParseResult {
  ok: boolean;
  value?: ParsedTokenUri;
  error?: string;
  issues?: MetadataValidationIssue[];
}

/**
 * Combat type categories for beasts
 */
export type BeastCombatType = "Magic" | "Hunter" | "Brute";

/**
 * Tier levels (1 = strongest, 5 = weakest)
 */
export type BeastTier = 1 | 2 | 3 | 4 | 5;

/**
 * Beast ID range (1-75)
 */
export type BeastId = number;
