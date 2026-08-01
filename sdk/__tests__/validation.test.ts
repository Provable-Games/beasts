import { describe, it, expect } from "vitest";
import {
  validateBeastId,
  validateBeastAttributes,
  validateBeastInput,
  createGenesisBeast,
  GENESIS_DEFAULTS,
} from "../validation";

describe("validation helpers", () => {
  it("validates beast IDs", () => {
    expect(validateBeastId(1).ok).toBe(true);
    expect(validateBeastId(75).ok).toBe(true);
    expect(validateBeastId(0).ok).toBe(false);
    expect(validateBeastId(76).ok).toBe(false);
  });

  it("validates beast attributes", () => {
    expect(validateBeastAttributes(0, 0, 0, 0).ok).toBe(true);
    expect(validateBeastAttributes(69, 18, 1, 1).ok).toBe(true);
    expect(validateBeastAttributes(70, 0, 0, 0).ok).toBe(false);
    expect(validateBeastAttributes(0, 19, 0, 0).ok).toBe(false);
    expect(validateBeastAttributes(0, 0, 2, 0).ok).toBe(false);
    expect(validateBeastAttributes(0, 0, 0, 2).ok).toBe(false);
    expect(validateBeastAttributes(-1, 0, 0, 0).ok).toBe(false);
  });

  it("validates full beast input", () => {
    const result = validateBeastInput({
      beastId: 10,
      prefix: 1,
      suffix: 2,
      level: 10,
      health: 100,
      shiny: 1,
      animated: 0,
    });
    expect(result.ok).toBe(true);
  });

  it("creates genesis beast defaults", () => {
    const genesis = createGenesisBeast(5);
    expect(genesis.beastId).toBe(5);
    expect(genesis.prefix).toBe(GENESIS_DEFAULTS.prefix);
    expect(genesis.suffix).toBe(GENESIS_DEFAULTS.suffix);
    expect(genesis.level).toBe(GENESIS_DEFAULTS.level);
    expect(genesis.health).toBe(GENESIS_DEFAULTS.health);
    expect(genesis.shiny).toBe(GENESIS_DEFAULTS.shiny);
    expect(genesis.animated).toBe(GENESIS_DEFAULTS.animated);
  });
});
