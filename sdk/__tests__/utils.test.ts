import { describe, it, expect } from "vitest";
import { calculatePowerClamped, isHigherRank } from "../utils";

describe("utility helpers", () => {
  it("clamps power to u16 max", () => {
    // Tier 1 => multiplier 5, max level before clamp = floor(65535 / 5) = 13107
    expect(calculatePowerClamped(1, 13107)).toBe(65535);
    expect(calculatePowerClamped(1, 13108)).toBe(65535);
  });

  it("calculates unclamped power correctly", () => {
    expect(calculatePowerClamped(2, 10)).toBe(40); // (6-2)*10
    expect(calculatePowerClamped(5, 10)).toBe(10); // (6-5)*10
  });

  it("compares rank by power then health", () => {
    expect(isHigherRank(50, 10, 40, 999)).toBe(true);
    expect(isHigherRank(50, 10, 50, 9)).toBe(true);
    expect(isHigherRank(50, 10, 50, 10)).toBe(false);
    expect(isHigherRank(40, 100, 50, 1)).toBe(false);
  });
});
