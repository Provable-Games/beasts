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
