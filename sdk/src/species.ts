import { GENESIS_SPECIES_NAMES, PREFIX_NAMES, SUFFIX_NAMES } from './tables.js';
import { GENESIS_SPECIES_MAX, isGenesisSpecies } from './tokenId.js';
import { BeastType, type Beast } from './types.js';

/**
 * Tier of a genesis species.
 *
 * The contract expresses this as ranges, but they are a formula: species are
 * laid out in three blocks of 25 (one per type), and each block runs T1..T5 in
 * groups of five.
 */
export function genesisTier(id: bigint): number {
  assertGenesisSpecies(id);
  return Math.floor((Number(id - 1n) % 25) / 5) + 1;
}

/** Type of a genesis species: 1-25 Magic, 26-50 Hunter, 51-75 Brute. */
export function genesisType(id: bigint): BeastType {
  assertGenesisSpecies(id);
  return Math.floor(Number(id - 1n) / 25) as BeastType;
}

/** Display name of a genesis species. */
export function genesisSpeciesName(id: bigint): string {
  assertGenesisSpecies(id);
  return GENESIS_SPECIES_NAMES[Number(id) - 1];
}

/** Prefix display name, or `null` for the Genesis Beast's absent affix. */
export function prefixName(prefix: number): string | null {
  if (prefix === 0) return null;
  if (prefix < 0 || prefix > PREFIX_NAMES.length) {
    throw new RangeError(`prefix out of range: ${prefix}`);
  }
  return PREFIX_NAMES[prefix - 1];
}

/** Suffix display name, or `null` for the Genesis Beast's absent affix. */
export function suffixName(suffix: number): string | null {
  if (suffix === 0) return null;
  if (suffix < 0 || suffix > SUFFIX_NAMES.length) {
    throw new RangeError(`suffix out of range: ${suffix}`);
  }
  return SUFFIX_NAMES[suffix - 1];
}

/**
 * Full display name, matching the contract's metadata exactly.
 *
 * A Genesis Beast is just the species name; every other Beast is
 * `"Prefix Suffix" Species`. Community species must supply `speciesName` —
 * only the registry knows it.
 */
export function fullBeastName(beast: Beast, speciesName?: string): string {
  const base = speciesName ?? genesisSpeciesName(beast.id);
  if (beast.prefix === 0) return base;
  return `"${prefixName(beast.prefix)} ${suffixName(beast.suffix)}" ${base}`;
}

/**
 * Static traits of a genesis species, resolved offline. Community species get
 * theirs from the registry — see `BeastRegistryClient.getDefinition`.
 */
export function genesisSpecies(id: bigint): { name: string; tier: number; beastType: BeastType } {
  return { name: genesisSpeciesName(id), tier: genesisTier(id), beastType: genesisType(id) };
}

function assertGenesisSpecies(id: bigint): void {
  if (!isGenesisSpecies(id)) {
    throw new RangeError(
      `species ${id} is not a genesis species (1-${GENESIS_SPECIES_MAX}); ` +
        'community species resolve through the registry',
    );
  }
}
