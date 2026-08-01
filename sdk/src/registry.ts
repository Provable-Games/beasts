import type { AccountInterface, Call, ProviderInterface } from 'starknet';
import { CallData, byteArray, hash, shortString } from 'starknet';
import { decodeTokenId, encodeTokenId, genesisBeast } from './tokenId.js';
import { BeastType, type ArtSet, type Beast, type BeastDefinition } from './types.js';

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
  /**
   * Block to start event scans from.
   *
   * Not just an optimisation. Public RPC nodes routinely cap how far back
   * `starknet_getEvents` will look, and at least one returns an **empty
   * result rather than an error** for a range it will not serve — so a scan
   * from genesis reports "this wallet owns nothing" instead of failing.
   * Anchoring to deployment keeps every query inside a range nodes will
   * actually answer.
   */
  fromBlock: number;
}

/**
 * Deployed stacks, from `docs/sepolia-v3-deployment.md`.
 *
 * `fromBlock` is the block of `set_nft_address`. That is a provably safe
 * floor rather than an estimate: the registry rejects every registration
 * until the NFT is wired, so no `BeastRegistered` event can predate it.
 */
export const SEPOLIA_ADDRESSES: BeastsAddresses = {
  nft: '0x01dac77837c6751777d917051a6e405967c5c75f46df5ab7c635e52819634bfd',
  registry: '0x06d46c98087a1246182c6cd8ef144ee0a67da6e6cc9e44e39aef08cf92d30045',
  fromBlock: 12_757_974,
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
    const definition = await this.getDefinition(beast.id);
    const raw = (await this.provider.callContract({
      contractAddress: definition.artProvider,
      entrypoint: 'get_data_uri',
      calldata: CallData.compile([
        beast.id.toString(),
        beast.prefix,
        beast.suffix,
        beast.level,
        beast.health,
        beast.shiny,
        beast.animated,
        beast.tier,
        beast.beastType,
      ]),
    })) as string[];
    return byteArray.stringFromByteArray(decodeByteArray(raw));
  }

  // ------------------------------------------------- artist enumeration

  /**
   * Species IDs an address is currently the artist for.
   *
   * Derived from events rather than by scanning IDs: the registry has no
   * artist index, and `species_count` grows without bound, so a scan would
   * cost one call per species forever. Two event streams are enough —
   * `BeastRegistered` establishes the original artist and
   * `ArtistTransferred` moves it — and applying them in block order
   * reproduces the current holder exactly.
   */
  async getSpeciesByArtist(artist: string): Promise<bigint[]> {
    const target = BigInt(artist);
    const current = new Map<string, bigint>();

    // Registration: keys [selector, beast_id], data [name, artist, ...].
    for (const event of await this.collectEvents('BeastRegistered')) {
      current.set(BigInt(event.keys[1]).toString(), BigInt(event.data[1]));
    }

    // Transfer: keys [selector, beast_id], data [previous, new]. Events
    // arrive in block order, so later transfers overwrite earlier ones.
    for (const event of await this.collectEvents('ArtistTransferred')) {
      current.set(BigInt(event.keys[1]).toString(), BigInt(event.data[1]));
    }

    return [...current.entries()]
      .filter(([, holder]) => holder === target)
      .map(([beastId]) => BigInt(beastId))
      .sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));
  }

  /**
   * Full detail for everything an address controls, ready to render. Each
   * definition is re-read from storage rather than taken from the
   * registration event, so art swaps, minter changes and locks are current.
   */
  async getOwnedSpecies(artist: string): Promise<OwnedSpecies[]> {
    const ids = await this.getSpeciesByArtist(artist);
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

  /** Pages through every event of one kind emitted by the registry. */
  private async collectEvents(
    eventName: string,
  ): Promise<Array<{ keys: string[]; data: string[] }>> {
    const selector = hash.getSelectorFromName(eventName);
    const events: Array<{ keys: string[]; data: string[] }> = [];
    let continuationToken: string | undefined;

    do {
      const page = await this.provider.getEvents({
        address: this.addresses.registry,
        from_block: { block_number: this.addresses.fromBlock },
        to_block: 'latest',
        keys: [[selector]],
        chunk_size: 100,
        continuation_token: continuationToken,
      });
      events.push(...page.events.map((e) => ({ keys: e.keys, data: e.data })));
      continuationToken = page.continuation_token;
    } while (continuationToken);

    return events;
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

  transferArtistRoleCall(beastId: bigint, newArtist: string): Call {
    return this.registryCall('transfer_artist_role', [beastId.toString(), newArtist]);
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
