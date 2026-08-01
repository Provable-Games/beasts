export {
  FIRST_COMMUNITY_ID,
  GENESIS_SPECIES_MAX,
  MAX_SUPPLY_PER_SPECIES,
  TOKEN_ID_BITS,
  TokenIdError,
  beastPower,
  decodeTokenId,
  encodeTokenId,
  genesisBeast,
  isGenesis,
  isGenesisSpecies,
} from './tokenId.js';

export {
  fullBeastName,
  genesisSpecies,
  genesisSpeciesName,
  genesisTier,
  genesisType,
  prefixName,
  suffixName,
} from './species.js';

export {
  ALLOWED_ART_PREFIXES,
  MAX_NAME_BYTES,
  type ValidationResult,
  validateArtSet,
  validateFactoryArt,
  validateRenderableArt,
  validateSpeciesName,
  validateTier,
} from './validation.js';

export {
  BeastsClient,
  SEPOLIA_ADDRESSES,
  type BeastsAddresses,
  type RegisterParams,
  type RegisterWithArtParams,
} from './registry.js';

export { GENESIS_SPECIES_NAMES, PREFIX_NAMES, SUFFIX_NAMES } from './tables.js';

export {
  BEAST_TYPE_NAMES,
  BeastType,
  type ArtSet,
  type Beast,
  type BeastDefinition,
} from './types.js';
