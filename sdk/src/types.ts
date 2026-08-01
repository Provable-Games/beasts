/** Beast type codes exactly as encoded in the token ID. */
export enum BeastType {
  Magic = 0,
  Hunter = 1,
  Brute = 2,
}

export const BEAST_TYPE_NAMES: Record<BeastType, string> = {
  [BeastType.Magic]: 'Magic',
  [BeastType.Hunter]: 'Hunter',
  [BeastType.Brute]: 'Brute',
};

/**
 * Everything a token ID encodes. This is the whole static profile of a Beast —
 * no chain read is needed to produce it, which is the point of the 116-bit
 * layout.
 */
export interface Beast {
  /** Species ID. 1-75 are genesis species; 76+ are community species. */
  id: bigint;
  /** 0-69. Zero only on a Genesis Beast. */
  prefix: number;
  /** 0-18. Zero only on a Genesis Beast. */
  suffix: number;
  level: number;
  health: number;
  shiny: 0 | 1;
  animated: 0 | 1;
  /** 1-5. */
  tier: number;
  beastType: BeastType;
}

/** A registered community species, as returned by `get_definition`. */
export interface BeastDefinition {
  name: string;
  beastType: BeastType;
  tier: number;
  /** Dungeon allowed to mint this species. Zero means paused. */
  minter: string;
  /** Registrant; holds the per-species admin role. */
  artist: string;
  artProvider: string;
  /** Zero means kill stats are off for this species. */
  statsSource: string;
  /** True when `artProvider` is the registry's canonical factory deploy. */
  factoryProvider: boolean;
  artLocked: boolean;
  minterLocked: boolean;
}

/** The four art variants a factory-provider species stores. */
export interface ArtSet {
  pngRegular: string;
  pngShiny: string;
  gifRegular: string;
  gifShiny: string;
}
