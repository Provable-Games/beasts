import { describe, expect, it } from "vitest";
import {
  normalizeStarknetAddress,
  resolveBeastRenderData,
  toBeastSvgInput,
} from "../client";
import type { BeastOnchain } from "../types";

describe("client helpers", () => {
  it("normalizes Starknet addresses", () => {
    const normalized = normalizeStarknetAddress("0xabc");
    expect(normalized).toBe(`0x${"0".repeat(61)}abc`);
  });

  it("resolves render data from on-chain fields", () => {
    const beast: BeastOnchain = {
      tokenId: 77,
      beastId: 29,
      prefix: 2,
      suffix: 1,
      level: 4,
      health: 10,
      shiny: 1,
      animated: 0,
      rank: 2,
    };

    const resolved = resolveBeastRenderData(beast);

    expect(resolved.name).toBe("Dragon");
    expect(resolved.prefixName).toBe("Apocalypse");
    expect(resolved.suffixName).toBe("Bane");
    expect(resolved.fullName).toBe('"Apocalypse Bane" Dragon');
    expect(resolved.tier).toBe(1);
    expect(resolved.type).toBe("Hunter");
    expect(resolved.power).toBe(20);
    expect(resolved.shiny).toBe(true);
    expect(resolved.animated).toBe(false);
    expect(resolved.rank).toBe(2);
  });

  it("builds SVG input from render data", () => {
    const beast: BeastOnchain = {
      tokenId: 1,
      beastId: 1,
      prefix: 0,
      suffix: 0,
      level: 1,
      health: 5,
      shiny: 0,
      animated: 0,
      rank: 0,
    };
    const resolved = resolveBeastRenderData(beast);
    const svgInput = toBeastSvgInput(resolved);
    expect(svgInput.beastId).toBe(1);
    expect(svgInput.rank).toBe(0);
  });
});
