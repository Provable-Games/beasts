import { describe, expect, it } from 'vitest';
import {
  validateArtSet,
  validateFactoryArt,
  validateRenderableArt,
  validateSpeciesName,
  validateTier,
} from '../src/index.js';

describe('species names', () => {
  it('accepts the charset the contract allows', () => {
    for (const name of ["Warlock", "Fire Drake", "K9", "Ol' One-Eye", 'x', 'A name that is 31 bytes long ok']) {
      expect(validateSpeciesName(name).valid).toBe(true);
    }
  });

  it('rejects the injection characters the contract guards against', () => {
    // components_to_json and the SVG builder embed names unescaped, so these
    // would break every token's metadata for that species.
    for (const name of ['bad"name', 'bad\\name', '<svg>', 'a,b', 'ab']) {
      expect(validateSpeciesName(name).valid).toBe(false);
    }
  });

  it('rejects empty and edge-space names', () => {
    expect(validateSpeciesName('').valid).toBe(false);
    expect(validateSpeciesName(' Warlock').valid).toBe(false);
    expect(validateSpeciesName('Warlock ').valid).toBe(false);
  });

  it('rejects names past the felt252 limit', () => {
    expect(validateSpeciesName('a'.repeat(31)).valid).toBe(true);
    expect(validateSpeciesName('a'.repeat(32)).valid).toBe(false);
  });

  it('counts bytes, not code points', () => {
    // Multi-byte characters are outside the charset anyway, but the length
    // check must not be fooled into thinking they fit.
    expect(validateSpeciesName('é'.repeat(20)).valid).toBe(false);
  });
});

describe('renderable art', () => {
  it('accepts every allowed media type', () => {
    for (const uri of [
      'data:image/png;base64,iVBORw0KGgo=',
      'data:image/gif;base64,R0lGODlhAQAB',
      'data:image/webp;base64,UklGRhIAAABX',
      'data:image/svg+xml;base64,PHN2Zy8+',
    ]) {
      expect(validateRenderableArt(uri).valid).toBe(true);
    }
  });

  it('rejects non-image media types', () => {
    expect(validateRenderableArt('data:text/html;base64,PHNjcmlwdD4=').valid).toBe(false);
  });

  it('rejects URL-encoded SVG, which carries raw markup', () => {
    expect(validateRenderableArt('data:image/svg+xml,<svg/>').valid).toBe(false);
  });

  it('rejects an attribute escape', () => {
    // The art is embedded inside a single-quoted src='...' attribute.
    expect(validateRenderableArt("data:image/png;base64,AAAA'AAA").valid).toBe(false);
  });

  it('rejects payloads that are not 4-aligned', () => {
    expect(validateRenderableArt('data:image/png;base64,AAAAA').valid).toBe(false);
  });

  it('rejects an empty payload', () => {
    expect(validateRenderableArt('data:image/png;base64,').valid).toBe(false);
  });

  it('rejects interior padding', () => {
    expect(validateRenderableArt('data:image/png;base64,AA=ABBBB').valid).toBe(false);
  });
});

describe('factory art', () => {
  it('accepts real PNG and both GIF versions', () => {
    expect(validateFactoryArt('data:image/png;base64,iVBORw0KGgoAAAA1', 'png').valid).toBe(true);
    expect(validateFactoryArt('data:image/gif;base64,R0lGODdhAAA1', 'gif').valid).toBe(true);
    expect(validateFactoryArt('data:image/gif;base64,R0lGODlhAAA1', 'gif').valid).toBe(true);
  });

  it('rejects a payload without PNG magic bytes', () => {
    expect(validateFactoryArt('data:image/png;base64,AAAAAAAAAAAA', 'png').valid).toBe(false);
  });

  it('rejects a truncated GIF signature', () => {
    // "R0lGODAAAAAA" decodes to the invalid header GIF80; the version
    // characters have to be checked, not just the "R0lGOD" stem.
    expect(validateFactoryArt('data:image/gif;base64,R0lGODAAAAAA', 'gif').valid).toBe(false);
  });

  it('rejects a GIF submitted as a PNG', () => {
    expect(validateFactoryArt('data:image/gif;base64,R0lGODdhAAA1', 'png').valid).toBe(false);
  });

  it('validates a whole set and names the offending variant', () => {
    const good = {
      pngRegular: 'data:image/png;base64,iVBORw0KGgoAAAA1',
      pngShiny: 'data:image/png;base64,iVBORw0KGgoAAAA2',
      gifRegular: 'data:image/gif;base64,R0lGODdhAAA1',
      gifShiny: 'data:image/gif;base64,R0lGODdhAAA2',
    };
    expect(validateArtSet(good).valid).toBe(true);

    const bad = validateArtSet({ ...good, gifShiny: 'data:image/gif;base64,AAAAAAAA' });
    expect(bad.valid).toBe(false);
    expect(bad.error).toMatch(/^Shiny GIF:/);
  });
});

describe('tier', () => {
  it('accepts 1 through 5 only', () => {
    for (const tier of [1, 2, 3, 4, 5]) expect(validateTier(tier).valid).toBe(true);
    for (const tier of [0, 6, -1, 1.5]) expect(validateTier(tier).valid).toBe(false);
  });
});
