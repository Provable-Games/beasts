import { describe, it, expect } from 'vitest';
import {
  getBeastImageUrl,
  getBeastImageUrls,
  getBeastStaticImageUrl,
  isLocalBeastImage,
} from '../images';

describe('Image URL generation', () => {
  describe('getBeastImageUrl', () => {
    it('returns correct path for static regular beast', () => {
      expect(getBeastImageUrl(29, false, false)).toBe(
        '/images/beasts/static/regular/dragon.png'
      );
    });

    it('returns correct path for static shiny beast', () => {
      expect(getBeastImageUrl(29, true, false)).toBe(
        '/images/beasts/static/shiny/dragon.png'
      );
    });

    it('returns correct path for animated regular beast', () => {
      expect(getBeastImageUrl(29, false, true)).toBe(
        '/images/beasts/animated/regular/dragon.gif'
      );
    });

    it('returns correct path for animated shiny beast', () => {
      expect(getBeastImageUrl(29, true, true)).toBe(
        '/images/beasts/animated/shiny/dragon.gif'
      );
    });

    it('handles multi-word beast names correctly', () => {
      // Beast ID 66 is "Nemean Lion" -> should become "nemeanlion"
      expect(getBeastImageUrl(66, false, false)).toBe(
        '/images/beasts/static/regular/nemeanlion.png'
      );
    });

    it('handles various beast IDs', () => {
      // Warlock (ID 1)
      expect(getBeastImageUrl(1, false, false)).toBe(
        '/images/beasts/static/regular/warlock.png'
      );

      // Kraken (ID 51)
      expect(getBeastImageUrl(51, true, true)).toBe(
        '/images/beasts/animated/shiny/kraken.gif'
      );

      // Fairy (ID 21)
      expect(getBeastImageUrl(21, false, false)).toBe(
        '/images/beasts/static/regular/fairy.png'
      );
    });

    it('handles unknown beast ID gracefully', () => {
      expect(getBeastImageUrl(0, false, false)).toBe(
        '/images/beasts/static/regular/unknown.png'
      );
      expect(getBeastImageUrl(100, false, false)).toBe(
        '/images/beasts/static/regular/unknown.png'
      );
    });
  });

  describe('getBeastImageUrls', () => {
    it('returns both imageUrl and imageSmallUrl', () => {
      const result = getBeastImageUrls(29, false, false);
      expect(result.imageUrl).toBe('/images/beasts/static/regular/dragon.png');
      expect(result.imageSmallUrl).toBe('/images/beasts/static/regular/dragon.png');
    });

    it('handles shiny and animated flags', () => {
      const result = getBeastImageUrls(51, true, true);
      expect(result.imageUrl).toBe('/images/beasts/animated/shiny/kraken.gif');
      expect(result.imageSmallUrl).toBe('/images/beasts/animated/shiny/kraken.gif');
    });
  });

  describe('getBeastStaticImageUrl', () => {
    it('always returns PNG static image', () => {
      expect(getBeastStaticImageUrl(29, false)).toBe(
        '/images/beasts/static/regular/dragon.png'
      );
      expect(getBeastStaticImageUrl(29, true)).toBe(
        '/images/beasts/static/shiny/dragon.png'
      );
    });
  });

  describe('isLocalBeastImage', () => {
    it('returns true for local beast image URLs', () => {
      expect(isLocalBeastImage('/images/beasts/static/regular/dragon.png')).toBe(true);
      expect(isLocalBeastImage('/images/beasts/animated/shiny/kraken.gif')).toBe(true);
    });

    it('returns false for external URLs', () => {
      expect(isLocalBeastImage('https://example.com/image.png')).toBe(false);
      expect(isLocalBeastImage('/images/other/image.png')).toBe(false);
    });
  });
});
