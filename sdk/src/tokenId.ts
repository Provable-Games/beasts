import { BeastType, type Beast } from './types.js';

/**
 * The 116-bit token ID layout, mirroring `pack_to_u256` in `src/pack.cairo`.
 *
 * ```
 *  bits  0- 63  id        (u64)
 *  bits 64- 70  prefix    (7)
 *  bits 71- 75  suffix    (5)
 *  bits 76- 91  level     (16)
 *  bits 92-107  health    (16)
 *  bit     108  shiny     (1)
 *  bit     109  animated  (1)
 *  bits 110-112 tier      (3)
 *  bits 113-115 type      (3)
 * ```
 *
 * Token IDs are deterministic, not sequential: the ID *is* the Beast. Every
 * static trait is recoverable offline, so a client needs chain reads only for
 * the species name and art of community species.
 */
const SHIFT = {
  id: 0n,
  prefix: 64n,
  suffix: 71n,
  level: 76n,
  health: 92n,
  shiny: 108n,
  animated: 109n,
  tier: 110n,
  beastType: 113n,
} as const;

const WIDTH = {
  id: 64n,
  prefix: 7n,
  suffix: 5n,
  level: 16n,
  health: 16n,
  shiny: 1n,
  animated: 1n,
  tier: 3n,
  beastType: 3n,
} as const;

const mask = (bits: bigint) => (1n << bits) - 1n;

/** Total width of the layout. Anything above this bit must be zero. */
export const TOKEN_ID_BITS = 116n;

/** Highest species ID backed by the baked-in genesis tables. */
export const GENESIS_SPECIES_MAX = 75n;

/** First species ID the registry will assign. */
export const FIRST_COMMUNITY_ID = 76n;

/** Max mintable Beasts per species: 69 x 18 named variants + 1 Genesis. */
export const MAX_SUPPLY_PER_SPECIES = 69 * 18 + 1;

export class TokenIdError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'TokenIdError';
  }
}

/**
 * Encodes a Beast into its canonical token ID.
 *
 * Validates the same ranges the contract does, so an ID produced here can
 * never decode into a different Beast than the one passed in.
 */
export function encodeTokenId(beast: Beast): bigint {
  assertEncodable(beast);

  return (
    (beast.id << SHIFT.id) |
    (BigInt(beast.prefix) << SHIFT.prefix) |
    (BigInt(beast.suffix) << SHIFT.suffix) |
    (BigInt(beast.level) << SHIFT.level) |
    (BigInt(beast.health) << SHIFT.health) |
    (BigInt(beast.shiny) << SHIFT.shiny) |
    (BigInt(beast.animated) << SHIFT.animated) |
    (BigInt(beast.tier) << SHIFT.tier) |
    (BigInt(beast.beastType) << SHIFT.beastType)
  );
}

/**
 * Decodes a token ID into its Beast.
 *
 * Applies the contract's `decode_token_id` checks: no residual high bits, a
 * non-zero species, in-range tier/type/affixes, and the affix-pair rule that
 * `(prefix === 0) === (suffix === 0)` — the `(id, 0, 0)` slot is reserved for
 * the species' Genesis Beast and no other combination may be half-set.
 */
export function decodeTokenId(tokenId: bigint | string | number): Beast {
  const packed = BigInt(tokenId);

  if (packed < 0n) throw new TokenIdError('token ID must be non-negative');
  if (packed >> TOKEN_ID_BITS) throw new TokenIdError('token ID has residual high bits');

  const field = (key: keyof typeof SHIFT) => (packed >> SHIFT[key]) & mask(WIDTH[key]);

  const id = field('id');
  if (id === 0n) throw new TokenIdError('species ID must not be zero');

  const prefix = Number(field('prefix'));
  const suffix = Number(field('suffix'));
  const tier = Number(field('tier'));
  const beastType = Number(field('beastType'));

  if (tier < 1 || tier > 5) throw new TokenIdError(`tier out of range: ${tier}`);
  if (beastType > 2) throw new TokenIdError(`beast type out of range: ${beastType}`);
  if (prefix > 69) throw new TokenIdError(`prefix out of range: ${prefix}`);
  if (suffix > 18) throw new TokenIdError(`suffix out of range: ${suffix}`);
  if ((prefix === 0) !== (suffix === 0)) {
    throw new TokenIdError('invalid affix combo: prefix and suffix must both be zero, or neither');
  }

  return {
    id,
    prefix,
    suffix,
    level: Number(field('level')),
    health: Number(field('health')),
    shiny: Number(field('shiny')) as 0 | 1,
    animated: Number(field('animated')) as 0 | 1,
    tier,
    beastType: beastType as BeastType,
  };
}

/**
 * A Genesis Beast is derived, never stored: it is the one Beast per species
 * holding the reserved `(id, 0, 0)` affix slot. It is the artist's provenance
 * token for community species, and belongs to the collection owner for the
 * original 75.
 */
export function isGenesis(beast: Beast): boolean {
  return beast.prefix === 0 && beast.suffix === 0;
}

/** True for the 75 species baked into the contract's tables. */
export function isGenesisSpecies(id: bigint): boolean {
  return id >= 1n && id <= GENESIS_SPECIES_MAX;
}

/** Combat power, exactly as the contract computes it: `level * (6 - tier)`. */
export function beastPower(beast: Beast): number {
  const power = beast.level * (6 - beast.tier);
  return power > 65535 ? 65535 : power;
}

/** Builds the Genesis Beast of a species from its static traits. */
export function genesisBeast(id: bigint, tier: number, beastType: BeastType): Beast {
  return { id, prefix: 0, suffix: 0, level: 1, health: 100, shiny: 1, animated: 1, tier, beastType };
}

function assertEncodable(beast: Beast): void {
  const inRange = (name: string, value: number | bigint, max: bigint) => {
    const v = BigInt(value);
    if (v < 0n || v > max) throw new TokenIdError(`${name} out of range: ${value}`);
  };

  if (beast.id <= 0n) throw new TokenIdError('species ID must be positive');
  inRange('id', beast.id, mask(WIDTH.id));
  inRange('level', beast.level, mask(WIDTH.level));
  inRange('health', beast.health, mask(WIDTH.health));

  if (beast.prefix > 69) throw new TokenIdError(`prefix out of range: ${beast.prefix}`);
  if (beast.suffix > 18) throw new TokenIdError(`suffix out of range: ${beast.suffix}`);
  if (beast.prefix < 0 || beast.suffix < 0) throw new TokenIdError('affixes must be non-negative');
  if ((beast.prefix === 0) !== (beast.suffix === 0)) {
    throw new TokenIdError('invalid affix combo: prefix and suffix must both be zero, or neither');
  }
  if (beast.tier < 1 || beast.tier > 5) throw new TokenIdError(`tier out of range: ${beast.tier}`);
  if (beast.beastType < 0 || beast.beastType > 2) {
    throw new TokenIdError(`beast type out of range: ${beast.beastType}`);
  }
  if (beast.shiny !== 0 && beast.shiny !== 1) throw new TokenIdError('shiny must be 0 or 1');
  if (beast.animated !== 0 && beast.animated !== 1) {
    throw new TokenIdError('animated must be 0 or 1');
  }
}
