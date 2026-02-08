import { describe, it, expect } from 'vitest';
import { generateBeastSvg } from '../svg';

describe('SVG generation', () => {
  it('uses PNG data URI by default', () => {
    const svg = generateBeastSvg({
      beastId: 1,
      prefix: null,
      suffix: null,
      tier: 1,
      level: 1,
      health: 1,
      power: 1,
      shiny: false,
      rank: null,
    });

    expect(svg.includes('data:image/png;base64,')).toBe(true);
  });

  it('uses GIF data URI when animated is true', () => {
    const svg = generateBeastSvg({
      beastId: 1,
      prefix: null,
      suffix: null,
      tier: 1,
      level: 1,
      health: 1,
      power: 1,
      shiny: false,
      rank: null,
      animated: true,
    });

    expect(svg.includes('data:image/gif;base64,')).toBe(true);
  });
});
