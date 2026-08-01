import { describe, expect, it } from 'vitest';
import {
  BeastType,
  GENESIS_SPECIES_NAMES,
  PREFIX_NAMES,
  SUFFIX_NAMES,
  decodeTokenId,
  fullBeastName,
  genesisSpeciesName,
  genesisTier,
  genesisType,
  prefixName,
  suffixName,
} from '../src/index.js';

describe('generated tables', () => {
  it('has the exact table sizes the contract does', () => {
    expect(GENESIS_SPECIES_NAMES).toHaveLength(75);
    expect(PREFIX_NAMES).toHaveLength(69);
    expect(SUFFIX_NAMES).toHaveLength(18);
  });

  it('contains no empty entries', () => {
    for (const table of [GENESIS_SPECIES_NAMES, PREFIX_NAMES, SUFFIX_NAMES]) {
      expect(table.every((n) => n.length > 0)).toBe(true);
    }
  });

  it('keeps every name inside a felt252', () => {
    const encoder = new TextEncoder();
    for (const table of [GENESIS_SPECIES_NAMES, PREFIX_NAMES, SUFFIX_NAMES]) {
      for (const name of table) expect(encoder.encode(name).length).toBeLessThanOrEqual(31);
    }
  });
});

describe('genesis species traits', () => {
  // Anchors taken from the contract's own unit tests in beast_manager.cairo.
  it.each([
    [1n, 'Warlock', 1, BeastType.Magic],
    [3n, 'Jiangshi', 1, BeastType.Magic],
    [25n, 'Gnome', 5, BeastType.Magic],
    [42n, 'Fenrir', 4, BeastType.Hunter],
    [75n, undefined, 5, BeastType.Brute],
  ])('resolves species %s', (id, name, tier, type) => {
    if (name) expect(genesisSpeciesName(id as bigint)).toBe(name);
    expect(genesisTier(id as bigint)).toBe(tier);
    expect(genesisType(id as bigint)).toBe(type);
  });

  it('lays tiers out in five-wide groups within each type block', () => {
    for (let id = 1; id <= 75; id++) {
      const expected = Math.floor(((id - 1) % 25) / 5) + 1;
      expect(genesisTier(BigInt(id))).toBe(expected);
    }
  });

  it('splits types into three blocks of 25', () => {
    expect(genesisType(25n)).toBe(BeastType.Magic);
    expect(genesisType(26n)).toBe(BeastType.Hunter);
    expect(genesisType(50n)).toBe(BeastType.Hunter);
    expect(genesisType(51n)).toBe(BeastType.Brute);
  });

  it('refuses community species, which resolve through the registry', () => {
    expect(() => genesisSpeciesName(76n)).toThrow(/not a genesis species/);
    expect(() => genesisTier(76n)).toThrow(/not a genesis species/);
  });
});

describe('affixes', () => {
  it('matches the contract anchors', () => {
    expect(prefixName(1)).toBe('Agony');
    expect(suffixName(1)).toBe('Bane');
    expect(suffixName(2)).toBe('Root');
  });

  it('returns null for the Genesis Beast’s absent affixes', () => {
    expect(prefixName(0)).toBeNull();
    expect(suffixName(0)).toBeNull();
  });

  it('rejects out-of-range affixes', () => {
    expect(() => prefixName(70)).toThrow(RangeError);
    expect(() => suffixName(19)).toThrow(RangeError);
  });
});

describe('full names', () => {
  it('renders a genesis beast as the bare species name', () => {
    expect(fullBeastName(decodeTokenId(0x7006400010000000000000000001n))).toBe('Warlock');
  });

  it('reproduces the name the Sepolia contract rendered', () => {
    // The deployed contract returned: "Agony Bane" Gloomfang
    const beast = decodeTokenId(0x2e0064000a081000000000000004cn);
    expect(fullBeastName(beast, 'Gloomfang')).toBe('"Agony Bane" Gloomfang');
  });

  it('requires a species name for community species', () => {
    const beast = decodeTokenId(0x2e0064000a081000000000000004cn);
    expect(() => fullBeastName(beast)).toThrow(/not a genesis species/);
  });
});
