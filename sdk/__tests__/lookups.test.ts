import { describe, it, expect } from 'vitest';
import {
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
} from '../lookups';

describe('Beast lookup tables', () => {
  describe('BEAST_NAMES', () => {
    it('has 75 beast names', () => {
      expect(Object.keys(BEAST_NAMES).length).toBe(75);
    });

    it('has correct names for T1 Magic beasts', () => {
      expect(BEAST_NAMES[1]).toBe('Warlock');
      expect(BEAST_NAMES[2]).toBe('Typhon');
      expect(BEAST_NAMES[3]).toBe('Jiangshi');
      expect(BEAST_NAMES[4]).toBe('Anansi');
      expect(BEAST_NAMES[5]).toBe('Basilisk');
    });

    it('has correct names for T1 Hunter beasts', () => {
      expect(BEAST_NAMES[26]).toBe('Griffin');
      expect(BEAST_NAMES[27]).toBe('Manticore');
      expect(BEAST_NAMES[28]).toBe('Phoenix');
      expect(BEAST_NAMES[29]).toBe('Dragon');
      expect(BEAST_NAMES[30]).toBe('Minotaur');
    });

    it('has correct names for T1 Brute beasts', () => {
      expect(BEAST_NAMES[51]).toBe('Kraken');
      expect(BEAST_NAMES[52]).toBe('Colossus');
      expect(BEAST_NAMES[53]).toBe('Balrog');
      expect(BEAST_NAMES[54]).toBe('Leviathan');
      expect(BEAST_NAMES[55]).toBe('Tarrasque');
    });
  });

  describe('BEAST_TIERS', () => {
    it('has 75 tier entries', () => {
      expect(Object.keys(BEAST_TIERS).length).toBe(75);
    });

    it('returns tier 1 for T1 beasts (IDs 1-5, 26-30, 51-55)', () => {
      // Magic T1
      expect(BEAST_TIERS[1]).toBe(1);
      expect(BEAST_TIERS[5]).toBe(1);
      // Hunter T1
      expect(BEAST_TIERS[26]).toBe(1);
      expect(BEAST_TIERS[30]).toBe(1);
      // Brute T1
      expect(BEAST_TIERS[51]).toBe(1);
      expect(BEAST_TIERS[55]).toBe(1);
    });

    it('returns tier 5 for T5 beasts (IDs 21-25, 46-50, 71-75)', () => {
      // Magic T5
      expect(BEAST_TIERS[21]).toBe(5);
      expect(BEAST_TIERS[25]).toBe(5);
      // Hunter T5
      expect(BEAST_TIERS[46]).toBe(5);
      expect(BEAST_TIERS[50]).toBe(5);
      // Brute T5
      expect(BEAST_TIERS[71]).toBe(5);
      expect(BEAST_TIERS[75]).toBe(5);
    });
  });

  describe('BEAST_TYPES', () => {
    it('has 75 type entries', () => {
      expect(Object.keys(BEAST_TYPES).length).toBe(75);
    });

    it('returns Magic for IDs 1-25', () => {
      expect(BEAST_TYPES[1]).toBe('Magic');
      expect(BEAST_TYPES[13]).toBe('Magic');
      expect(BEAST_TYPES[25]).toBe('Magic');
    });

    it('returns Hunter for IDs 26-50', () => {
      expect(BEAST_TYPES[26]).toBe('Hunter');
      expect(BEAST_TYPES[38]).toBe('Hunter');
      expect(BEAST_TYPES[50]).toBe('Hunter');
    });

    it('returns Brute for IDs 51-75', () => {
      expect(BEAST_TYPES[51]).toBe('Brute');
      expect(BEAST_TYPES[63]).toBe('Brute');
      expect(BEAST_TYPES[75]).toBe('Brute');
    });
  });

  describe('ITEM_NAME_PREFIXES', () => {
    it('has 69 prefix names', () => {
      expect(Object.keys(ITEM_NAME_PREFIXES).length).toBe(69);
    });

    it('has correct prefix values', () => {
      expect(ITEM_NAME_PREFIXES[1]).toBe('Agony');
      expect(ITEM_NAME_PREFIXES[2]).toBe('Apocalypse');
      expect(ITEM_NAME_PREFIXES[69]).toBe('Shimmering');
    });
  });

  describe('ITEM_NAME_SUFFIXES', () => {
    it('has 18 suffix names', () => {
      expect(Object.keys(ITEM_NAME_SUFFIXES).length).toBe(18);
    });

    it('has correct suffix values', () => {
      expect(ITEM_NAME_SUFFIXES[1]).toBe('Bane');
      expect(ITEM_NAME_SUFFIXES[2]).toBe('Root');
      expect(ITEM_NAME_SUFFIXES[18]).toBe('Moon');
    });
  });
});

describe('Lookup functions', () => {
  describe('getBeastName', () => {
    it('returns beast name for valid ID', () => {
      expect(getBeastName(1)).toBe('Warlock');
      expect(getBeastName(29)).toBe('Dragon');
      expect(getBeastName(51)).toBe('Kraken');
    });

    it('returns "Unknown" for invalid ID', () => {
      expect(getBeastName(0)).toBe('Unknown');
      expect(getBeastName(76)).toBe('Unknown');
      expect(getBeastName(-1)).toBe('Unknown');
    });
  });

  describe('getBeastTier', () => {
    it('returns tier for valid ID', () => {
      expect(getBeastTier(1)).toBe(1);
      expect(getBeastTier(21)).toBe(5);
    });

    it('returns 5 (default) for invalid ID', () => {
      expect(getBeastTier(0)).toBe(5);
      expect(getBeastTier(100)).toBe(5);
    });
  });

  describe('getBeastType', () => {
    it('returns type for valid ID', () => {
      expect(getBeastType(1)).toBe('Magic');
      expect(getBeastType(26)).toBe('Hunter');
      expect(getBeastType(51)).toBe('Brute');
    });

    it('returns "Unknown" for invalid ID', () => {
      expect(getBeastType(0)).toBe('Unknown');
      expect(getBeastType(100)).toBe('Unknown');
    });
  });

  describe('getPrefix', () => {
    it('returns prefix for valid ID', () => {
      expect(getPrefix(1)).toBe('Agony');
      expect(getPrefix(2)).toBe('Apocalypse');
    });

    it('returns empty string for invalid ID', () => {
      expect(getPrefix(0)).toBe('');
      expect(getPrefix(100)).toBe('');
    });
  });

  describe('getSuffix', () => {
    it('returns suffix for valid ID', () => {
      expect(getSuffix(1)).toBe('Bane');
      expect(getSuffix(2)).toBe('Root');
    });

    it('returns empty string for invalid ID', () => {
      expect(getSuffix(0)).toBe('');
      expect(getSuffix(100)).toBe('');
    });
  });
});
