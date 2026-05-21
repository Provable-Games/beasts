/**
 * Beast SDK Validation Helpers
 *
 * Mirrors on-chain validation and genesis defaults.
 */

import type { BeastInput, ValidationResult } from "./types";

export const GENESIS_DEFAULTS = {
  prefix: 0,
  suffix: 0,
  level: 1,
  health: 100,
  shiny: 1,
  animated: 1,
} as const;

/** Validate a beast ID is within valid range (1-75). */
export function validateBeastId(beastId: number): ValidationResult {
  if (beastId >= 1 && beastId <= 75) {
    return { ok: true };
  }
  return { ok: false, error: "Invalid beast ID" };
}

/** Validate beast attributes against on-chain constraints. */
export function validateBeastAttributes(
  prefix: number,
  suffix: number,
  shiny: number,
  animated: number
): ValidationResult {
  if (prefix < 0 || prefix > 69) {
    return { ok: false, error: "Invalid prefix" };
  }
  if (suffix < 0 || suffix > 18) {
    return { ok: false, error: "Invalid suffix" };
  }
  if (shiny < 0 || shiny > 1) {
    return { ok: false, error: "Invalid shiny value" };
  }
  if (animated < 0 || animated > 1) {
    return { ok: false, error: "Invalid animated value" };
  }
  return { ok: true };
}

/** Validate a full beast input payload. */
export function validateBeastInput(beast: BeastInput): ValidationResult {
  const idCheck = validateBeastId(beast.beastId);
  if (!idCheck.ok) {
    return idCheck;
  }
  return validateBeastAttributes(
    beast.prefix,
    beast.suffix,
    beast.shiny,
    beast.animated
  );
}

/** Create a genesis beast input with on-chain default attributes. */
export function createGenesisBeast(beastId: number): BeastInput {
  return {
    beastId,
    prefix: GENESIS_DEFAULTS.prefix,
    suffix: GENESIS_DEFAULTS.suffix,
    level: GENESIS_DEFAULTS.level,
    health: GENESIS_DEFAULTS.health,
    shiny: GENESIS_DEFAULTS.shiny,
    animated: GENESIS_DEFAULTS.animated,
  };
}
