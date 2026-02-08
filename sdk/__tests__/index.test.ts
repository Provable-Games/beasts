import { describe, it, expect } from 'vitest';
import {
  getFullBeastName,
  isGenesisBeast,
  getTierColor,
  calculatePower,
  getBeastInfo,
} from '../index';

describe('Beast SDK utility functions', () => {
  describe('getFullBeastName', () => {
    it('returns beast name with prefix and suffix', () => {
      expect(getFullBeastName(29, 'Apocalypse', 'Bane')).toBe(
        '"Apocalypse Bane" Dragon'
      );
    });

    it('returns beast name with only prefix', () => {
      expect(getFullBeastName(29, 'Apocalypse', null)).toBe(
        '"Apocalypse" Dragon'
      );
    });

    it('returns beast name with only suffix', () => {
      expect(getFullBeastName(29, null, 'Bane')).toBe('"Bane" Dragon');
    });

    it('returns just beast name when no prefix or suffix', () => {
      expect(getFullBeastName(29, null, null)).toBe('Dragon');
    });

    it('handles unknown beast ID', () => {
      expect(getFullBeastName(0, null, null)).toBe('Unknown');
    });
  });

  describe('isGenesisBeast', () => {
    it('returns true for token IDs 1-75', () => {
      expect(isGenesisBeast(1)).toBe(true);
      expect(isGenesisBeast(75)).toBe(true);
      expect(isGenesisBeast(38)).toBe(true);
    });

    it('returns false for token IDs above 75', () => {
      expect(isGenesisBeast(76)).toBe(false);
      expect(isGenesisBeast(1000)).toBe(false);
      expect(isGenesisBeast(99999)).toBe(false);
    });

    it('returns false for token ID 0', () => {
      expect(isGenesisBeast(0)).toBe(false);
    });

    it('handles string token IDs', () => {
      expect(isGenesisBeast('1')).toBe(true);
      expect(isGenesisBeast('75')).toBe(true);
      expect(isGenesisBeast('76')).toBe(false);
      expect(isGenesisBeast('1001')).toBe(false);
    });
  });

  describe('getTierColor', () => {
    it('returns orange for tier 1', () => {
      expect(getTierColor(1)).toBe('#ff8800');
    });

    it('returns purple for tier 2', () => {
      expect(getTierColor(2)).toBe('#8c00bf');
    });

    it('returns blue for tier 3', () => {
      expect(getTierColor(3)).toBe('#0066ff');
    });

    it('returns green for tier 4', () => {
      expect(getTierColor(4)).toBe('#00cc00');
    });

    it('returns gray for tier 5', () => {
      expect(getTierColor(5)).toBe('#cccccc');
    });

    it('returns gray for invalid tier', () => {
      expect(getTierColor(0)).toBe('#cccccc');
      expect(getTierColor(6)).toBe('#cccccc');
    });
  });

  describe('calculatePower', () => {
    it('calculates power correctly for tier 1', () => {
      // Power = (6 - tier) * level = 5 * level
      expect(calculatePower(1, 10)).toBe(50);
      expect(calculatePower(1, 20)).toBe(100);
    });

    it('calculates power correctly for tier 5', () => {
      // Power = (6 - 5) * level = 1 * level
      expect(calculatePower(5, 10)).toBe(10);
      expect(calculatePower(5, 20)).toBe(20);
    });

    it('calculates power for various tiers', () => {
      expect(calculatePower(2, 10)).toBe(40); // (6-2) * 10 = 40
      expect(calculatePower(3, 10)).toBe(30); // (6-3) * 10 = 30
      expect(calculatePower(4, 10)).toBe(20); // (6-4) * 10 = 20
    });
  });

  describe('getBeastInfo', () => {
    it('returns complete info for valid beast ID', () => {
      const info = getBeastInfo(29);
      expect(info.name).toBe('Dragon');
      expect(info.tier).toBe(1);
      expect(info.type).toBe('Hunter');
      expect(info.tierColor).toBe('#ff8800');
    });

    it('returns info for Magic beast', () => {
      const info = getBeastInfo(1);
      expect(info.name).toBe('Warlock');
      expect(info.tier).toBe(1);
      expect(info.type).toBe('Magic');
    });

    it('returns info for Brute beast', () => {
      const info = getBeastInfo(51);
      expect(info.name).toBe('Kraken');
      expect(info.tier).toBe(1);
      expect(info.type).toBe('Brute');
    });

    it('returns info for T5 beast', () => {
      const info = getBeastInfo(21);
      expect(info.name).toBe('Fairy');
      expect(info.tier).toBe(5);
      expect(info.type).toBe('Magic');
      expect(info.tierColor).toBe('#cccccc');
    });
  });
});
