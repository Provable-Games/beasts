import type { AccountInterface, Call, ProviderInterface } from 'starknet';
import { CallData, byteArray, shortString } from 'starknet';
import { genesisSpecies, genesisSpeciesName } from './species.js';
import {
  FIRST_COMMUNITY_ID,
  decodeTokenId,
  encodeTokenId,
  genesisBeast,
  isGenesis,
  isGenesisSpecies,
} from './tokenId.js';
import { BeastType, type ArtSet, type Beast, type BeastDefinition } from './types.js';

/** Name, traits and mint count for any species, genesis or community. */
export interface SpeciesSummary {
  beastId: bigint;
  name: string;
  tier: number;
  beastType: BeastType;
  /** Non-genesis mints. The Genesis Beast is not counted. */
  minted: number;
  /** False for the original 75, which have no registry entry. */
  community: boolean;
}

/** A species the connected wallet controls, with its provenance token. */
export interface OwnedSpecies {
  beastId: bigint;
  definition: BeastDefinition;
  /** Token ID of the species' Genesis Beast — the artist's provenance token. */
  genesisTokenId: bigint;
}

/** Addresses of a deployed Beasts stack. */
export interface BeastsAddresses {
  nft: string;
  registry: string;
}

/** Deployed stacks, from `docs/sepolia-v3-deployment.md`. */
export const SEPOLIA_ADDRESSES: BeastsAddresses = {
  nft: '0x017e2cb5d7c4a86ff2bdee182ce53386a7cc57c63b943878de21b681e336a89a',
  registry: '0x0797a19c0b267e91ea17f886f155310e38196261ec5683e3a12a35772718d723',
};

export interface RegisterWithArtParams {
  name: string;
  beastType: BeastType;
  tier: number;
  /** Dungeon allowed to mint. Pass `'0x0'` to register in a paused state. */
  minter: string;
  art: ArtSet;
}

export interface RegisterParams {
  name: string;
  beastType: BeastType;
  tier: number;
  minter: string;
  /** An `IBeastArtProvider` the artist controls. */
  artProvider: string;
}

/**
 * Reads and call-builders for the Beasts stack.
 *
 * Write methods return `Call` objects rather than executing them, so the
 * caller decides how to sign — a wallet popup, a Cartridge session, or a
 * multicall batching several changes into one transaction. Only
 * `execute` actually sends, and only if an account was supplied.
 */
export class BeastsClient {
  private legacyProviders?: {
    pngRegular: string;
    pngShiny: string;
    gifRegular: string;
    gifShiny: string;
  };

  constructor(
    private readonly provider: ProviderInterface,
    private readonly addresses: BeastsAddresses = SEPOLIA_ADDRESSES,
    private readonly account?: AccountInterface,
  ) {}

  get nftAddress(): string {
    return this.addresses.nft;
  }

  get registryAddress(): string {
    return this.addresses.registry;
  }

  // ------------------------------------------------------------- reads

  /** Full definition of a registered community species. Reverts for 1-75. */
  async getDefinition(beastId: bigint): Promise<BeastDefinition> {
    const raw = (await this.provider.callContract({
      contractAddress: this.addresses.registry,
      entrypoint: 'get_definition',
      calldata: CallData.compile([beastId.toString()]),
    })) as string[];

    // BeastDefinition: name, type, tier, minter, artist, art_provider,
    // stats_source, factory, art_locked, minter_locked
    return {
      name: shortString.decodeShortString(raw[0]),
      beastType: Number(BigInt(raw[1])) as BeastType,
      tier: Number(BigInt(raw[2])),
      minter: toHex(raw[3]),
      artist: toHex(raw[4]),
      artProvider: toHex(raw[5]),
      statsSource: toHex(raw[6]),
      factoryProvider: BigInt(raw[7]) === 1n,
      artLocked: BigInt(raw[8]) === 1n,
      minterLocked: BigInt(raw[9]) === 1n,
    };
  }

  /** Total species, genesis included. `next_id - 1`. */
  async speciesCount(): Promise<bigint> {
    const [raw] = (await this.provider.callContract({
      contractAddress: this.addresses.registry,
      entrypoint: 'species_count',
      calldata: [],
    })) as string[];
    return BigInt(raw);
  }

  async isRegistered(beastId: bigint): Promise<boolean> {
    const [raw] = (await this.provider.callContract({
      contractAddress: this.addresses.registry,
      entrypoint: 'is_registered',
      calldata: CallData.compile([beastId.toString()]),
    })) as string[];
    return BigInt(raw) === 1n;
  }

  /** Minted NFT count. Not the highest token ID — IDs are not sequential. */
  async totalSupply(): Promise<bigint> {
    const raw = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint: 'total_supply',
      calldata: [],
    })) as string[];
    return u256FromParts(raw[0], raw[1]);
  }

  /** Decodes a token's Beast. Local decode; no chain read is needed. */
  decodeBeast(tokenId: bigint | string): Beast {
    return decodeTokenId(tokenId);
  }

  async ownerOf(tokenId: bigint): Promise<string> {
    const [raw] = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint: 'owner_of',
      calldata: CallData.compile(u256ToParts(tokenId)),
    })) as string[];
    return toHex(raw);
  }

  /** Rank within the species, by power then health. Genesis Beasts are 0. */
  async getBeastRank(tokenId: bigint): Promise<number> {
    const [raw] = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint: 'get_beast_rank',
      calldata: CallData.compile(u256ToParts(tokenId)),
    })) as string[];
    return Number(BigInt(raw));
  }

  /** The contract's own metadata for a token: a base64 JSON data URI. */
  async tokenUri(tokenId: bigint): Promise<string> {
    const raw = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint: 'token_uri',
      calldata: CallData.compile(u256ToParts(tokenId)),
    })) as string[];
    return byteArray.stringFromByteArray(decodeByteArray(raw));
  }

  /** Art for a Beast, straight from its species' provider. */
  async getArt(beast: Beast): Promise<string> {
    // Mirrors the contract's own routing in `resolve_art`: genesis species
    // read from the four art data contracts wired at construction, community
    // species from their registered provider.
    if (isGenesisSpecies(beast.id)) {
      const providers = await this.getLegacyArtProviders();
      const address = beast.animated
        ? beast.shiny
          ? providers.gifShiny
          : providers.gifRegular
        : beast.shiny
          ? providers.pngShiny
          : providers.pngRegular;
      // The legacy interface is keyed by the u8 species ID, not the beast.
      return this.callForByteArray(address, 'get_data_uri', [beast.id.toString()]);
    }

    const definition = await this.getDefinition(beast.id);
    return this.callForByteArray(definition.artProvider, 'get_data_uri', [
      beast.id.toString(),
      beast.prefix,
      beast.suffix,
      beast.level,
      beast.health,
      beast.shiny,
      beast.animated,
      beast.tier,
      beast.beastType,
    ]);
  }

  /**
   * Addresses of the four genesis art data contracts, read once and cached.
   * They are set at construction and immutable, so a single read is safe for
   * the lifetime of the client.
   */
  async getLegacyArtProviders(): Promise<{
    pngRegular: string;
    pngShiny: string;
    gifRegular: string;
    gifShiny: string;
  }> {
    if (!this.legacyProviders) {
      const [pngRegular, pngShiny, gifRegular, gifShiny] = await Promise.all([
        this.callForAddress('get_regular_png_provider'),
        this.callForAddress('get_shiny_png_provider'),
        this.callForAddress('get_regular_gif_provider'),
        this.callForAddress('get_shiny_gif_provider'),
      ]);
      this.legacyProviders = { pngRegular, pngShiny, gifRegular, gifShiny };
    }
    return this.legacyProviders;
  }

  /** Display name of any species: baked-in tables below 76, registry above. */
  async getSpeciesName(beastId: bigint): Promise<string> {
    if (isGenesisSpecies(beastId)) return genesisSpeciesName(beastId);
    return (await this.getDefinition(beastId)).name;
  }

  /**
   * Name, traits and mint count for any species, genesis or community.
   *
   * Genesis species resolve entirely offline except the count, which is the
   * one thing only the chain knows.
   */
  async getSpeciesSummary(beastId: bigint): Promise<SpeciesSummary> {
    const minted = await this.getSpeciesMintCount(beastId);

    if (isGenesisSpecies(beastId)) {
      const { name, tier, beastType } = genesisSpecies(beastId);
      return { beastId, name, tier, beastType, minted, community: false };
    }

    const definition = await this.getDefinition(beastId);
    return {
      beastId,
      name: definition.name,
      tier: definition.tier,
      beastType: definition.beastType,
      minted,
      community: true,
    };
  }

  /** Non-genesis mints of a species. Excludes the rank-0 Genesis Beast. */
  async getSpeciesMintCount(beastId: bigint): Promise<number> {
    const [raw] = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint: 'get_species_count',
      calldata: CallData.compile([beastId.toString()]),
    })) as string[];
    return Number(BigInt(raw));
  }

  /**
   * Every token of a species, best rank first, with the Genesis Beast last.
   *
   * Uses the contract's own per-species rank list rather than scanning: the
   * NFT already keeps `rank -> token_id` for each species to drive metadata
   * refreshes.
   */
  async getSpeciesTokens(beastId: bigint, concurrency = 4): Promise<bigint[]> {
    const count = await this.getSpeciesMintCount(beastId);
    const tokens: bigint[] = [];

    for (let start = 1; start <= count; start += concurrency) {
      const batch = await Promise.all(
        Array.from({ length: Math.min(concurrency, count - start + 1) }, (_, offset) =>
          this.getTokenIdAtRank(beastId, start + offset),
        ),
      );
      tokens.push(...batch.filter((id) => id !== 0n));
    }

    // The Genesis Beast holds rank 0 and lives outside that list.
    const genesis = await this.getGenesisTokenIdIfMinted(beastId);
    if (genesis !== null) tokens.push(genesis);

    return tokens;
  }

  async getTokenIdAtRank(beastId: bigint, rank: number): Promise<bigint> {
    const raw = (await withRateLimitRetry(
      () =>
        this.provider.callContract({
          contractAddress: this.addresses.nft,
          entrypoint: 'get_token_id_at_rank',
          calldata: CallData.compile([beastId.toString(), rank]),
        }) as Promise<string[]>,
    ));
    return u256FromParts(raw[0], raw[1]);
  }

  /** Every token an address holds, decoded. */
  async getTokensOfOwner(owner: string, concurrency = 4): Promise<Beast[]> {
    const balance = Number(await this.balanceOf(owner));
    const beasts: Beast[] = [];

    for (let start = 0; start < balance; start += concurrency) {
      const batch = await Promise.all(
        Array.from({ length: Math.min(concurrency, balance - start) }, (_, offset) =>
          this.tokenOfOwnerByIndex(owner, BigInt(start + offset)),
        ),
      );
      beasts.push(...batch.map((id) => decodeTokenId(id)));
    }

    return beasts;
  }

  private async getGenesisTokenIdIfMinted(beastId: bigint): Promise<bigint | null> {
    const tokenId = isGenesisSpecies(beastId)
      ? encodeTokenId(
          genesisBeast(beastId, genesisSpecies(beastId).tier, genesisSpecies(beastId).beastType),
        )
      : await this.getGenesisTokenId(beastId);
    try {
      await this.ownerOf(tokenId);
      return tokenId;
    } catch {
      return null;
    }
  }

  private async callForAddress(entrypoint: string): Promise<string> {
    const [raw] = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint,
      calldata: [],
    })) as string[];
    return toHex(raw);
  }

  private async callForByteArray(
    contractAddress: string,
    entrypoint: string,
    calldata: unknown[],
  ): Promise<string> {
    const raw = (await withRateLimitRetry(
      () =>
        this.provider.callContract({
          contractAddress,
          entrypoint,
          calldata: CallData.compile(calldata as never),
        }) as Promise<string[]>,
    ));
    return byteArray.stringFromByteArray(decodeByteArray(raw));
  }

  // ------------------------------------------------- artist enumeration

  /**
   * Species IDs an address controls.
   *
   * The artist role is not stored anywhere — it *is* ownership of the
   * species' Genesis Beast. So this walks the wallet's tokens through
   * `token_of_owner_by_index`, decodes each one locally, and keeps the ones
   * with no affixes. A token ID carries its own species, so no registry read
   * and no event scan is involved.
   */
  async getSpeciesByArtist(artist: string, concurrency = 4): Promise<bigint[]> {
    const balance = Number(await this.balanceOf(artist));
    const ids: bigint[] = [];

    // Enumeration is one call per token, and the collection owner alone holds
    // all 75 genesis Beasts — issuing those serially takes tens of seconds and
    // trips public-node rate limits. Fetch in bounded batches instead:
    // fast enough for a real wallet, still polite to the node.
    for (let start = 0; start < balance; start += concurrency) {
      const batch = await Promise.all(
        Array.from({ length: Math.min(concurrency, balance - start) }, (_, offset) =>
          this.tokenOfOwnerByIndex(artist, BigInt(start + offset)),
        ),
      );
      for (const tokenId of batch) {
        const beast = decodeTokenId(tokenId);
        // The (id, 0, 0) slot is the species' Genesis Beast, and holding it is
        // what the registry checks. Every other token is an ordinary Beast.
        if (isGenesis(beast)) ids.push(beast.id);
      }
    }

    return ids.sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));
  }

  /**
   * Full detail for everything an address controls, ready to render.
   *
   * Genesis species (1-75) are skipped: their Genesis Beasts belong to the
   * collection owner and have no registry entry, so `get_definition` would
   * revert on them.
   */
  async getOwnedSpecies(artist: string): Promise<OwnedSpecies[]> {
    const ids = (await this.getSpeciesByArtist(artist)).filter(
      (id) => id >= FIRST_COMMUNITY_ID,
    );
    return Promise.all(
      ids.map(async (beastId) => {
        const definition = await this.getDefinition(beastId);
        return {
          beastId,
          definition,
          genesisTokenId: encodeTokenId(
            genesisBeast(beastId, definition.tier, definition.beastType),
          ),
        };
      }),
    );
  }

  /**
   * Token ID of the species' Genesis Beast, read from the registry.
   *
   * Derivable offline via `encodeTokenId(genesisBeast(...))`, but reading it
   * back is what proves the client and the contract agree on which token
   * carries the artist role.
   */
  async getGenesisTokenId(beastId: bigint): Promise<bigint> {
    const raw = (await this.provider.callContract({
      contractAddress: this.addresses.registry,
      entrypoint: 'get_genesis_token_id',
      calldata: CallData.compile([beastId.toString()]),
    })) as string[];
    return u256FromParts(raw[0], raw[1]);
  }

  async balanceOf(owner: string): Promise<bigint> {
    const raw = (await this.provider.callContract({
      contractAddress: this.addresses.nft,
      entrypoint: 'balance_of',
      calldata: CallData.compile([owner]),
    })) as string[];
    return u256FromParts(raw[0], raw[1]);
  }

  /** Owner enumeration. Order is not stable across transfers. */
  async tokenOfOwnerByIndex(owner: string, index: bigint): Promise<bigint> {
    const raw = (await withRateLimitRetry(
      () =>
        this.provider.callContract({
          contractAddress: this.addresses.nft,
          entrypoint: 'token_of_owner_by_index',
          calldata: CallData.compile([owner, ...u256ToParts(index)]),
        }) as Promise<string[]>,
    ));
    return u256FromParts(raw[0], raw[1]);
  }

  // ------------------------------------------------------ call builders

  /**
   * The simple path: the registry deploys a canonical `StoredArtProvider`
   * holding the four variants. One transaction, no contract knowledge needed,
   * and the artist's Genesis Beast lands in the same transaction.
   */
  registerWithArtCall(params: RegisterWithArtParams): Call {
    return {
      contractAddress: this.addresses.registry,
      entrypoint: 'register_beast_with_art',
      calldata: CallData.compile([
        shortString.encodeShortString(params.name),
        params.beastType,
        params.tier,
        params.minter,
        byteArray.byteArrayFromString(params.art.pngRegular),
        byteArray.byteArrayFromString(params.art.pngShiny),
        byteArray.byteArrayFromString(params.art.gifRegular),
        byteArray.byteArrayFromString(params.art.gifShiny),
      ]),
    };
  }

  /** The advanced path: the artist supplies their own `IBeastArtProvider`. */
  registerCall(params: RegisterParams): Call {
    return {
      contractAddress: this.addresses.registry,
      entrypoint: 'register_beast',
      calldata: CallData.compile([
        shortString.encodeShortString(params.name),
        params.beastType,
        params.tier,
        params.minter,
        params.artProvider,
      ]),
    };
  }

  updateArtCall(beastId: bigint, art: ArtSet): Call {
    return {
      contractAddress: this.addresses.registry,
      entrypoint: 'update_art',
      calldata: CallData.compile([
        beastId.toString(),
        byteArray.byteArrayFromString(art.pngRegular),
        byteArray.byteArrayFromString(art.pngShiny),
        byteArray.byteArrayFromString(art.gifRegular),
        byteArray.byteArrayFromString(art.gifShiny),
      ]),
    };
  }

  /** Zero pauses the species — mints revert until a minter is set again. */
  setMinterCall(beastId: bigint, minter: string): Call {
    return this.registryCall('set_minter', [beastId.toString(), minter]);
  }

  /** One-way. After this the minter can never change. */
  lockMinterCall(beastId: bigint): Call {
    return this.registryCall('lock_minter', [beastId.toString()]);
  }

  /**
   * One-way. Freezes the art *pointer*. For a factory provider that is a true
   * freeze, since its only mutator is registry-gated. For a custom provider it
   * freezes only the address — the provider may still change what it returns,
   * which is why `notify_art_updated` stays open for those.
   */
  lockArtCall(beastId: bigint): Call {
    return this.registryCall('lock_art', [beastId.toString()]);
  }

  setArtProviderCall(beastId: bigint, provider: string): Call {
    return this.registryCall('set_art_provider', [beastId.toString(), provider]);
  }

  /** Re-announces art to marketplaces after a custom provider changed. */
  notifyArtUpdatedCall(beastId: bigint): Call {
    return this.registryCall('notify_art_updated', [beastId.toString()]);
  }

  /** Zero clears the source, turning kill stats off for the species. */
  setStatsSourceCall(beastId: bigint, source: string): Call {
    return this.registryCall('set_stats_source', [beastId.toString(), source]);
  }

  /**
   * Transfers a species by transferring its Genesis Beast.
   *
   * There is no `transfer_artist_role`: the creator token *is* the role, so
   * this is an ordinary ERC721 transfer and a marketplace sale does exactly
   * the same thing.
   */
  transferGenesisBeastCall(from: string, to: string, genesisTokenId: bigint): Call {
    return {
      contractAddress: this.addresses.nft,
      entrypoint: 'transfer_from',
      calldata: CallData.compile([from, to, ...u256ToParts(genesisTokenId)]),
    };
  }

  /** Permissionless: pulls a community token's stats into the render cache. */
  refreshStatsCall(tokenId: bigint): Call {
    return {
      contractAddress: this.addresses.nft,
      entrypoint: 'refresh_stats',
      calldata: CallData.compile(u256ToParts(tokenId)),
    };
  }

  // ----------------------------------------------------------- execute

  /** Sends one or more calls. Requires an account. */
  async execute(calls: Call | Call[]): Promise<string> {
    if (!this.account) {
      throw new Error('BeastsClient was constructed without an account; cannot execute');
    }
    const { transaction_hash } = await this.account.execute(calls);
    return transaction_hash;
  }

  private registryCall(entrypoint: string, args: unknown[]): Call {
    return {
      contractAddress: this.addresses.registry,
      entrypoint,
      calldata: CallData.compile(args as never),
    };
  }
}

// ------------------------------------------------------------- helpers

/**
 * Retries a call that a public node refused for rate limiting.
 *
 * Enumeration is one request per token, so any wallet with a real collection
 * will out-run a free endpoint's per-second budget. That is a transient
 * refusal, not an answer — retrying with backoff is the difference between
 * "this wallet holds nothing" and the truth.
 */
async function withRateLimitRetry<T>(fn: () => Promise<T>, attempts = 7): Promise<T> {
  let delayMs = 250;
  for (let attempt = 0; ; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt >= attempts - 1 || !isRateLimited(error)) throw error;
      await new Promise((resolve) => setTimeout(resolve, delayMs));
      delayMs *= 2;
    }
  }
}

function isRateLimited(error: unknown): boolean {
  const message = (error instanceof Error ? error.message : String(error)).toLowerCase();
  return (
    message.includes('-32011') ||
    message.includes('cu limit') ||
    message.includes('too many requests') ||
    message.includes('rate limit') ||
    message.includes('429')
  );
}

function toHex(value: string): string {
  return `0x${BigInt(value).toString(16).padStart(64, '0')}`;
}

function u256ToParts(value: bigint): [string, string] {
  const MASK = (1n << 128n) - 1n;
  return [(value & MASK).toString(), (value >> 128n).toString()];
}

function u256FromParts(low: string, high: string): bigint {
  return BigInt(low) + (BigInt(high) << 128n);
}

/**
 * A ByteArray on the wire is `[num_full_words, ...words, pending_word,
 * pending_len]`. starknet.js wants that shape as an object.
 */
function decodeByteArray(raw: string[]): {
  data: string[];
  pending_word: string;
  pending_word_len: number;
} {
  const wordCount = Number(BigInt(raw[0]));
  return {
    data: raw.slice(1, 1 + wordCount),
    pending_word: raw[1 + wordCount],
    pending_word_len: Number(BigInt(raw[2 + wordCount])),
  };
}
