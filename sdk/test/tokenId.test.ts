import { describe, expect, it } from 'vitest';
import {
  BeastType,
  TokenIdError,
  beastPower,
  decodeTokenId,
  encodeTokenId,
  genesisBeast,
  isGenesis,
  isGenesisSpecies,
  type Beast,
} from '../src/index.js';

/**
 * These two IDs were produced by the deployed contract on Sepolia, not by
 * this SDK — see `docs/sepolia-v3-deployment.md`. They are the anchor that
 * proves the TS layout matches `pack_to_u256`; everything else here is
 * self-consistency.
 */
const ONCHAIN_GENESIS_WARLOCK = 0x7006400010000000000000000001n;
const ONCHAIN_GLOOMFANG = 0x2e0064000a081000000000000004cn;

describe('on-chain parity', () => {
  it('decodes the Sepolia genesis Warlock token', () => {
    const beast = decodeTokenId(ONCHAIN_GENESIS_WARLOCK);
    expect(beast).toEqual({
      id: 1n,
      prefix: 0,
      suffix: 0,
      level: 1,
      health: 100,
      shiny: 1,
      animated: 1,
      tier: 1,
      beastType: BeastType.Magic,
    });
    expect(isGenesis(beast)).toBe(true);
  });

  it('decodes the Sepolia "Agony Bane" Gloomfang token', () => {
    const beast = decodeTokenId(ONCHAIN_GLOOMFANG);
    expect(beast).toEqual({
      id: 76n,
      prefix: 1,
      suffix: 1,
      level: 10,
      health: 100,
      shiny: 0,
      animated: 1,
      tier: 3,
      beastType: BeastType.Hunter,
    });
    expect(isGenesis(beast)).toBe(false);
    // The contract reported Power 30 for this token.
    expect(beastPower(beast)).toBe(30);
  });

  it('re-encodes both on-chain tokens byte for byte', () => {
    for (const tokenId of [ONCHAIN_GENESIS_WARLOCK, ONCHAIN_GLOOMFANG]) {
      expect(encodeTokenId(decodeTokenId(tokenId))).toBe(tokenId);
    }
  });
});

describe('round trips', () => {
  it('survives the maximum value in every field', () => {
    const beast: Beast = {
      id: (1n << 64n) - 1n,
      prefix: 69,
      suffix: 18,
      level: 65535,
      health: 65535,
      shiny: 1,
      animated: 1,
      tier: 5,
      beastType: BeastType.Brute,
    };
    expect(decodeTokenId(encodeTokenId(beast))).toEqual(beast);
  });

  it('stays inside 116 bits at maximum', () => {
    const maxId = encodeTokenId({
      id: (1n << 64n) - 1n,
      prefix: 69,
      suffix: 18,
      level: 65535,
      health: 65535,
      shiny: 1,
      animated: 1,
      tier: 5,
      beastType: BeastType.Brute,
    });
    expect(maxId >> 116n).toBe(0n);
    // Fits a u128, which is what makes these IDs cheap for clients.
    expect(maxId < 1n << 128n).toBe(true);
  });

  it('accepts hex strings and numbers', () => {
    expect(decodeTokenId('0x7006400010000000000000000001').id).toBe(1n);
    expect(decodeTokenId(ONCHAIN_GENESIS_WARLOCK.toString()).id).toBe(1n);
  });
});

describe('validation', () => {
  const valid: Beast = {
    id: 3n,
    prefix: 1,
    suffix: 2,
    level: 10,
    health: 100,
    shiny: 0,
    animated: 0,
    tier: 1,
    beastType: BeastType.Magic,
  };

  it('rejects a zero species ID', () => {
    expect(() => encodeTokenId({ ...valid, id: 0n })).toThrow(TokenIdError);
    expect(() => decodeTokenId(0n)).toThrow(/species ID must not be zero/);
  });

  it('rejects residual high bits', () => {
    expect(() => decodeTokenId(1n << 116n)).toThrow(/residual high bits/);
  });

  it('rejects half-set affixes in both directions', () => {
    // The (id, 0, 0) slot is reserved for the Genesis Beast, so a Beast may
    // have both affixes or neither — never one.
    expect(() => encodeTokenId({ ...valid, prefix: 0 })).toThrow(/invalid affix combo/);
    expect(() => encodeTokenId({ ...valid, suffix: 0 })).toThrow(/invalid affix combo/);
  });

  it('accepts a genesis beast with neither affix', () => {
    expect(() => encodeTokenId({ ...valid, prefix: 0, suffix: 0 })).not.toThrow();
  });

  it('rejects out-of-range traits', () => {
    expect(() => encodeTokenId({ ...valid, tier: 0 })).toThrow(/tier out of range/);
    expect(() => encodeTokenId({ ...valid, tier: 6 })).toThrow(/tier out of range/);
    expect(() => encodeTokenId({ ...valid, prefix: 70 })).toThrow(/prefix out of range/);
    expect(() => encodeTokenId({ ...valid, suffix: 19 })).toThrow(/suffix out of range/);
    expect(() => encodeTokenId({ ...valid, beastType: 3 as BeastType })).toThrow(
      /beast type out of range/,
    );
  });

  it('rejects a decoded tier of zero', () => {
    // Tier 0 is unreachable through encode, so build the ID by hand.
    const raw = 1n | (1n << 64n) | (1n << 71n);
    expect(() => decodeTokenId(raw)).toThrow(/tier out of range/);
  });
});

describe('derived helpers', () => {
  it('caps power at u16', () => {
    expect(beastPower({ ...genesisBeast(1n, 1, BeastType.Magic), level: 65535 })).toBe(65535);
  });

  it('computes power as level * (6 - tier)', () => {
    for (let tier = 1; tier <= 5; tier++) {
      const beast = { ...genesisBeast(1n, tier, BeastType.Magic), level: 10 };
      expect(beastPower(beast)).toBe(10 * (6 - tier));
    }
  });

  it('classifies genesis vs community species', () => {
    expect(isGenesisSpecies(1n)).toBe(true);
    expect(isGenesisSpecies(75n)).toBe(true);
    expect(isGenesisSpecies(76n)).toBe(false);
    expect(isGenesisSpecies(0n)).toBe(false);
  });
});
