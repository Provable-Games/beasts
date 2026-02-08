/**
 * Beast SDK client
 *
 * Provides data fetching from Summit API, Voyager API, or RPC fallback.
 */

import {
  getBeastName,
  getBeastTier,
  getBeastType,
  getBeastIdByName,
  getPrefix,
  getPrefixIdByName,
  getSuffix,
  getSuffixIdByName,
} from "./lookups";
import { calculatePower } from "./utils";
import type {
  BeastOnchain,
  BeastRenderData,
  BeastFetchResult,
  SummitBeastListResponse,
  SummitBeastRow,
} from "./types";
import type { BeastSvgInput } from "./svg";

const DEFAULT_RPC_URL = "https://api.cartridge.gg/x/starknet/mainnet/rpc/v0_10";
const DEFAULT_DATA_PROVIDER_ADDRESS =
  "0x00a23b848b296094b592b6a1944fa72de64fcd620b33403b22a2414a76b0a964";
const DEFAULT_BEAST_NFT_ADDRESS =
  "0x046da8955829adf2bda310099a0063451923f02e648cf25a1203aac6335cf0e4";

const DEFAULT_VOYAGER_API_URL = "https://api.voyager.online/beta";

const DEFAULT_OWNERSHIP_BATCHES = 8;
const DEFAULT_RPC_TIMEOUT_MS = 300_000;
const DEFAULT_RPC_CONCURRENCY = 8;
const DEFAULT_API_TIMEOUT_MS = 30_000;
const DEFAULT_PAGE_SIZE = 100;

const TOTAL_SUPPLY_SELECTOR =
  "0x01557182e4359a1f0c6301278e8f5b35a776ab58d39892581e357578fb287836";
const GET_BEAST_OWNERS_RANGE_SELECTOR =
  "0x01ce5018d4217224edbb53a2cb09e8aac71c3bf9a108f07e4133207bf2161a45";
const GET_BEAST_SELECTOR =
  "0x0385b69551f247794fe651459651cdabc76b6cdf4abacafb5b28ceb3b1ac2e98";
const GET_BEAST_RANK_SELECTOR =
  "0x021d56a4b44096b9487419b2c0f193d1813e09b7737e8f4a1a0de093224281e4";

export interface BeastSdkConfig {
  /** Base URL for Summit API (e.g. https://api.example.com). */
  apiBaseUrl?: string;
  /** Timeout for Summit API requests (ms). */
  apiRequestTimeoutMs?: number;
  /** Page size for Summit API /beasts/all (max 100). */
  apiPageSize?: number;
  /** Voyager API settings (fallback between API and RPC). */
  voyager?: {
    apiUrl?: string;
    apiKey?: string;
    requestTimeoutMs?: number;
    pageSize?: number;
  };
  /** RPC settings (final fallback). */
  rpc?: {
    url?: string;
    dataProviderAddress?: string;
    beastNftAddress?: string;
    ownershipBatches?: number;
    requestTimeoutMs?: number;
    concurrency?: number;
  };
  /** Custom fetch implementation (defaults to global fetch). */
  fetch?: typeof fetch;
}

export interface BeastSdkClient {
  getAccountBeasts(
    owner: string,
    options?: GetAccountBeastsOptions
  ): Promise<BeastFetchResult>;
  getAccountTokenIds(
    owner: string,
    options?: GetAccountTokenIdsOptions
  ): Promise<number[]>;
  getBeastsByTokenIds(
    tokenIds: number[],
    options?: GetBeastsByTokenIdsOptions
  ): Promise<BeastFetchResult>;
}

export interface GetAccountBeastsOptions {
  includeRank?: boolean;
}

export interface GetAccountTokenIdsOptions {
  /** Prefer Voyager for token IDs if Summit API fails. */
  allowVoyagerFallback?: boolean;
}

export interface GetBeastsByTokenIdsOptions {
  includeRank?: boolean;
}

interface VoyagerAttribute {
  trait_type: string;
  value: string;
}

interface VoyagerNftItem {
  tokenId: string;
  attributes?: VoyagerAttribute[] | null;
}

interface VoyagerResponse {
  items: VoyagerNftItem[];
  pagination?: {
    next?: string | null;
  };
}

export function createBeastSdk(config: BeastSdkConfig = {}): BeastSdkClient {
  const fetcher = config.fetch ?? globalThis.fetch;
  if (!fetcher) {
    throw new Error("fetch is not available; provide BeastSdkConfig.fetch");
  }

  const apiBaseUrl = config.apiBaseUrl?.replace(/\/$/, "");
  const apiTimeoutMs = config.apiRequestTimeoutMs ?? DEFAULT_API_TIMEOUT_MS;
  const apiPageSize = Math.min(
    Math.max(1, config.apiPageSize ?? DEFAULT_PAGE_SIZE),
    DEFAULT_PAGE_SIZE
  );

  const voyagerApiUrl = config.voyager?.apiUrl ?? DEFAULT_VOYAGER_API_URL;
  const voyagerApiKey = config.voyager?.apiKey;
  const voyagerTimeoutMs =
    config.voyager?.requestTimeoutMs ?? DEFAULT_API_TIMEOUT_MS;
  const voyagerPageSize = Math.min(
    Math.max(1, config.voyager?.pageSize ?? DEFAULT_PAGE_SIZE),
    DEFAULT_PAGE_SIZE
  );

  const rpcUrl = config.rpc?.url ?? DEFAULT_RPC_URL;
  const dataProviderAddress =
    config.rpc?.dataProviderAddress ?? DEFAULT_DATA_PROVIDER_ADDRESS;
  const beastNftAddress =
    config.rpc?.beastNftAddress ?? DEFAULT_BEAST_NFT_ADDRESS;
  const ownershipBatches =
    Math.max(1, config.rpc?.ownershipBatches ?? DEFAULT_OWNERSHIP_BATCHES);
  const rpcTimeoutMs = config.rpc?.requestTimeoutMs ?? DEFAULT_RPC_TIMEOUT_MS;
  const rpcConcurrency = Math.max(
    1,
    config.rpc?.concurrency ?? DEFAULT_RPC_CONCURRENCY
  );

  async function getAccountBeasts(
    owner: string,
    options?: GetAccountBeastsOptions
  ): Promise<BeastFetchResult> {
    const includeRank = options?.includeRank ?? true;
    const normalizedOwner = normalizeStarknetAddress(owner);

    if (apiBaseUrl) {
      try {
        const beasts = await fetchSummitBeasts(
          fetcher,
          apiBaseUrl,
          normalizedOwner,
          apiPageSize,
          apiTimeoutMs
        );
        const ranked = includeRank
          ? await fillMissingRanks(fetcher, beasts)
          : beasts;
        return {
          beasts: resolveBeastRenderDataList(ranked),
          source: "summit-api",
        };
      } catch (error) {
        // fall through to Voyager or RPC
        void error;
      }
    }

    if (voyagerApiKey) {
      try {
        const beasts = await fetchVoyagerBeasts(
          fetcher,
          voyagerApiUrl,
          voyagerApiKey,
          beastNftAddress,
          normalizedOwner,
          voyagerPageSize,
          voyagerTimeoutMs
        );
        const ranked = includeRank
          ? await fillMissingRanks(fetcher, beasts)
          : beasts;
        return {
          beasts: resolveBeastRenderDataList(ranked),
          source: "voyager",
        };
      } catch (error) {
        // fall through to RPC
        void error;
      }
    }

    const tokenIds = await getTokenIdsByOwnerViaRpc(
      fetcher,
      rpcUrl,
      beastNftAddress,
      dataProviderAddress,
      normalizedOwner,
      ownershipBatches,
      rpcTimeoutMs
    );
    const beasts = await getBeastsByTokenIdsViaRpc(
      fetcher,
      rpcUrl,
      beastNftAddress,
      tokenIds,
      rpcTimeoutMs,
      rpcConcurrency
    );
    const ranked = includeRank
      ? await fillMissingRanks(fetcher, beasts)
      : beasts;
    return { beasts: resolveBeastRenderDataList(ranked), source: "rpc" };
  }

  async function getAccountTokenIds(
    owner: string,
    options?: GetAccountTokenIdsOptions
  ): Promise<number[]> {
    const normalizedOwner = normalizeStarknetAddress(owner);

    if (apiBaseUrl) {
      try {
        const beasts = await fetchSummitBeasts(
          fetcher,
          apiBaseUrl,
          normalizedOwner,
          apiPageSize,
          apiTimeoutMs
        );
        return beasts.map((beast) => beast.tokenId);
      } catch (error) {
        void error;
      }
    }

    if (options?.allowVoyagerFallback && voyagerApiKey) {
      try {
        const beasts = await fetchVoyagerBeasts(
          fetcher,
          voyagerApiUrl,
          voyagerApiKey,
          beastNftAddress,
          normalizedOwner,
          voyagerPageSize,
          voyagerTimeoutMs
        );
        return beasts.map((beast) => beast.tokenId);
      } catch (error) {
        void error;
      }
    }

    return getTokenIdsByOwnerViaRpc(
      fetcher,
      rpcUrl,
      beastNftAddress,
      dataProviderAddress,
      normalizedOwner,
      ownershipBatches,
      rpcTimeoutMs
    );
  }

  async function getBeastsByTokenIds(
    tokenIds: number[],
    options?: GetBeastsByTokenIdsOptions
  ): Promise<BeastFetchResult> {
    const includeRank = options?.includeRank ?? true;

    const beasts = await getBeastsByTokenIdsViaRpc(
      fetcher,
      rpcUrl,
      beastNftAddress,
      tokenIds,
      rpcTimeoutMs,
      rpcConcurrency
    );
    const ranked = includeRank
      ? await fillMissingRanks(fetcher, beasts)
      : beasts;
    return { beasts: resolveBeastRenderDataList(ranked), source: "rpc" };
  }

  async function fillMissingRanks(
    fetchImpl: typeof fetch,
    beasts: BeastOnchain[]
  ): Promise<BeastOnchain[]> {
    const missing = beasts.filter(
      (beast) => beast.rank == null && !isGenesisToken(beast.tokenId)
    );

    if (missing.length === 0) {
      return beasts.map((beast) => ({
        ...beast,
        rank: beast.rank ?? (isGenesisToken(beast.tokenId) ? 0 : null),
      }));
    }

    const ranks = await getBeastRanksViaRpc(
      fetchImpl,
      rpcUrl,
      beastNftAddress,
      missing.map((beast) => beast.tokenId),
      rpcTimeoutMs,
      rpcConcurrency
    );

    return beasts.map((beast) => ({
      ...beast,
      rank:
        beast.rank ??
        ranks.get(beast.tokenId) ??
        (isGenesisToken(beast.tokenId) ? 0 : null),
    }));
  }

  return {
    getAccountBeasts,
    getAccountTokenIds,
    getBeastsByTokenIds,
  };
}

export function resolveBeastRenderData(beast: BeastOnchain): BeastRenderData {
  const name = getBeastName(beast.beastId);
  const tier = getBeastTier(beast.beastId);
  const type = getBeastType(beast.beastId) as BeastRenderData["type"];
  const prefixName = beast.prefix > 0 ? getPrefix(beast.prefix) : null;
  const suffixName = beast.suffix > 0 ? getSuffix(beast.suffix) : null;
  const fullName = formatFullName(name, prefixName, suffixName);
  const power = calculatePower(tier, beast.level);
  const rank =
    beast.rank ?? (isGenesisToken(beast.tokenId) ? 0 : null);

  return {
    tokenId: beast.tokenId,
    beastId: beast.beastId,
    prefix: beast.prefix,
    suffix: beast.suffix,
    level: beast.level,
    health: beast.health,
    shiny: beast.shiny === 1,
    animated: beast.animated === 1,
    rank,
    name,
    prefixName,
    suffixName,
    fullName,
    tier,
    type,
    power,
  };
}

export function resolveBeastRenderDataList(
  beasts: BeastOnchain[]
): BeastRenderData[] {
  return beasts
    .map(resolveBeastRenderData)
    .sort((a, b) => a.tokenId - b.tokenId);
}

export function toBeastSvgInput(beast: BeastRenderData): BeastSvgInput {
  return {
    beastId: beast.beastId,
    prefix: beast.prefixName,
    suffix: beast.suffixName,
    tier: beast.tier,
    level: beast.level,
    health: beast.health,
    power: beast.power,
    shiny: beast.shiny,
    rank: beast.rank,
    animated: beast.animated,
  };
}

export function normalizeStarknetAddress(address: string): string {
  const trimmed = address.trim().toLowerCase();
  if (!trimmed) {
    throw new Error("Address is empty");
  }
  const hex = trimmed.startsWith("0x") ? trimmed.slice(2) : trimmed;
  const value = BigInt(`0x${hex}`);
  return `0x${value.toString(16).padStart(64, "0")}`;
}

function formatFullName(
  beastName: string,
  prefix: string | null,
  suffix: string | null
): string {
  if (prefix && suffix) {
    return `"${prefix} ${suffix}" ${beastName}`;
  }
  if (prefix) {
    return `"${prefix}" ${beastName}`;
  }
  if (suffix) {
    return `"${suffix}" ${beastName}`;
  }
  return beastName;
}

function isGenesisToken(tokenId: number): boolean {
  return tokenId >= 1 && tokenId <= 75;
}

function toHex(value: bigint | number): string {
  return `0x${BigInt(value).toString(16)}`;
}

function toU256Calldata(value: bigint | number): [string, string] {
  const big = BigInt(value);
  const lowMask = (1n << 128n) - 1n;
  const low = big & lowMask;
  const high = big >> 128n;
  return [toHex(low), toHex(high)];
}

function parseFeltNumber(value: string, field: string): number {
  try {
    return Number(BigInt(value));
  } catch (error) {
    throw new Error(`Invalid felt for ${field}: ${value}`);
  }
}

function coerceNumber(value: unknown, field: string): number {
  if (typeof value === "number") {
    return value;
  }
  if (typeof value === "string") {
    try {
      return Number(BigInt(value));
    } catch {
      const parsed = parseInt(value, 10);
      if (!Number.isNaN(parsed)) {
        return parsed;
      }
    }
  }
  throw new Error(`Invalid number for ${field}`);
}

async function fetchJson<T>(
  fetchImpl: typeof fetch,
  url: string,
  init: RequestInit,
  timeoutMs: number
): Promise<T> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const response = await fetchImpl(url, {
      ...init,
      signal: controller.signal,
    });
    if (!response.ok) {
      throw new Error(`HTTP ${response.status} ${response.statusText}`);
    }
    return (await response.json()) as T;
  } finally {
    clearTimeout(timeoutId);
  }
}

async function fetchSummitBeasts(
  fetchImpl: typeof fetch,
  baseUrl: string,
  owner: string,
  pageSize: number,
  timeoutMs: number
): Promise<BeastOnchain[]> {
  const beasts: BeastOnchain[] = [];
  let offset = 0;
  let hasMore = true;

  while (hasMore) {
    const url = new URL(`${baseUrl}/beasts/all`);
    url.searchParams.set("owner", owner);
    url.searchParams.set("limit", pageSize.toString());
    url.searchParams.set("offset", offset.toString());

    const response = await fetchJson<SummitBeastListResponse>(
      fetchImpl,
      url.toString(),
      { method: "GET" },
      timeoutMs
    );

    for (const row of response.data) {
      beasts.push(parseSummitBeastRow(row));
    }

    hasMore = Boolean(response.pagination?.has_more);
    offset += response.data.length;

    if (response.data.length === 0) {
      hasMore = false;
    }
  }

  return beasts;
}

function parseSummitBeastRow(row: SummitBeastRow): BeastOnchain {
  return {
    tokenId: coerceNumber(row.token_id, "token_id"),
    beastId: coerceNumber(row.beast_id, "beast_id"),
    prefix: coerceNumber(row.prefix, "prefix"),
    suffix: coerceNumber(row.suffix, "suffix"),
    level: coerceNumber(row.level, "level"),
    health: coerceNumber(row.health, "health"),
    shiny: coerceNumber(row.shiny, "shiny"),
    animated: coerceNumber(row.animated, "animated"),
  };
}

async function fetchVoyagerBeasts(
  fetchImpl: typeof fetch,
  apiUrl: string,
  apiKey: string,
  contractAddress: string,
  owner: string,
  pageSize: number,
  timeoutMs: number
): Promise<BeastOnchain[]> {
  const beasts: BeastOnchain[] = [];
  let cursor: string | null = null;
  let hasMore = true;

  while (hasMore) {
    const url = new URL(`${apiUrl}/nft-items`);
    url.searchParams.set("contract_address", contractAddress);
    url.searchParams.set("owner_address", owner);
    url.searchParams.set("limit", pageSize.toString());
    if (cursor) {
      url.searchParams.set("cursor", cursor);
    }

    const response = await fetchJson<VoyagerResponse>(
      fetchImpl,
      url.toString(),
      {
        method: "GET",
        headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json",
        },
      },
      timeoutMs
    );

    for (const item of response.items) {
      beasts.push(parseVoyagerBeastItem(item));
    }

    const nextCursor = extractCursorFromUrl(response.pagination?.next ?? null);
    if (!nextCursor || response.items.length < pageSize) {
      hasMore = false;
    } else {
      cursor = nextCursor;
    }
  }

  return beasts;
}

function extractCursorFromUrl(url: string | null): string | null {
  if (!url) return null;
  try {
    const urlObj = new URL(url, DEFAULT_VOYAGER_API_URL);
    return urlObj.searchParams.get("cursor");
  } catch {
    return null;
  }
}

function getAttributeValue(
  attributes: VoyagerAttribute[] | null | undefined,
  traitType: string
): string | null {
  if (!attributes) return null;
  const attr = attributes.find((attr) => attr.trait_type === traitType);
  return attr?.value ?? null;
}

function getAttributeNumber(
  attributes: VoyagerAttribute[] | null | undefined,
  traitType: string
): number | null {
  const value = getAttributeValue(attributes, traitType);
  if (value == null) return null;
  const parsed = parseInt(value, 10);
  return Number.isNaN(parsed) ? null : parsed;
}

function getAttributeBoolean(
  attributes: VoyagerAttribute[] | null | undefined,
  traitType: string
): boolean {
  const value = getAttributeValue(attributes, traitType);
  if (value == null) return false;
  const normalized = value.toLowerCase();
  return normalized === "true" || normalized === "1";
}

function parseVoyagerBeastItem(item: VoyagerNftItem): BeastOnchain {
  const attributes = item.attributes ?? null;
  const tokenId = coerceNumber(item.tokenId, "tokenId");
  const beastId =
    getAttributeNumber(attributes, "Beast ID") ??
    getAttributeNumber(attributes, "Beast Id") ??
    getAttributeNumber(attributes, "BeastId") ??
    getBeastIdByName(getAttributeValue(attributes, "Beast"));

  if (beastId == null) {
    throw new Error("Voyager item missing Beast ID");
  }

  const prefixName = getAttributeValue(attributes, "Prefix");
  const suffixName = getAttributeValue(attributes, "Suffix");
  const level = getAttributeNumber(attributes, "Level");
  const health = getAttributeNumber(attributes, "Health");

  if (level == null || health == null) {
    throw new Error("Voyager item missing Level/Health");
  }

  const prefix = getPrefixIdByName(prefixName) ?? 0;
  const suffix = getSuffixIdByName(suffixName) ?? 0;

  const shiny =
    getAttributeBoolean(attributes, "Shiny") ||
    getAttributeBoolean(attributes, "Is Shiny");
  const animated =
    getAttributeBoolean(attributes, "Animated") ||
    getAttributeBoolean(attributes, "Is Animated");
  const rank =
    getAttributeNumber(attributes, "Rank") ??
    (isGenesisToken(tokenId) ? 0 : null);

  return {
    tokenId,
    beastId,
    prefix,
    suffix,
    level,
    health,
    shiny: shiny ? 1 : 0,
    animated: animated ? 1 : 0,
    rank,
  };
}

async function rpcCall(
  fetchImpl: typeof fetch,
  rpcUrl: string,
  method: string,
  params: Record<string, unknown>,
  timeoutMs: number
): Promise<string[]> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetchImpl(rpcUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ jsonrpc: "2.0", id: 1, method, params }),
      signal: controller.signal,
    });

    const data = (await response.json()) as {
      result?: string[];
      error?: { code: number; message: string };
    };

    if (data.error) {
      throw new Error(`RPC error: ${data.error.message}`);
    }

    return data.result ?? [];
  } finally {
    clearTimeout(timeoutId);
  }
}

async function getTotalSupply(
  fetchImpl: typeof fetch,
  rpcUrl: string,
  beastNftAddress: string,
  timeoutMs: number
): Promise<number> {
  const params = {
    request: {
      contract_address: beastNftAddress,
      entry_point_selector: TOTAL_SUPPLY_SELECTOR,
      calldata: [],
    },
    block_id: "latest",
  };

  const result = await rpcCall(
    fetchImpl,
    rpcUrl,
    "starknet_call",
    params,
    timeoutMs
  );

  const low = result[0] ? BigInt(result[0]) : 0n;
  const high = result[1] ? BigInt(result[1]) : 0n;
  const total = low + (high << 128n);

  if (total > BigInt(Number.MAX_SAFE_INTEGER)) {
    throw new Error("total_supply exceeds MAX_SAFE_INTEGER");
  }

  return Number(total);
}

async function getTokenIdsByOwnerViaRpc(
  fetchImpl: typeof fetch,
  rpcUrl: string,
  beastNftAddress: string,
  dataProviderAddress: string,
  owner: string,
  batches: number,
  timeoutMs: number
): Promise<number[]> {
  const totalSupply = await getTotalSupply(
    fetchImpl,
    rpcUrl,
    beastNftAddress,
    timeoutMs
  );

  if (totalSupply === 0) {
    return [];
  }

  const safeBatches = Math.max(1, batches);
  const batchSize = Math.ceil(totalSupply / safeBatches);
  const ranges: Array<[number, number]> = [];

  for (let i = 0; i < safeBatches; i++) {
    const start = i * batchSize + 1;
    const end = Math.min((i + 1) * batchSize, totalSupply);
    if (start <= totalSupply) {
      ranges.push([start, end]);
    }
  }

  const normalizedOwner = normalizeStarknetAddress(owner);

  const results = await Promise.all(
    ranges.map(([start, end]) =>
      getBeastOwnersRange(
        fetchImpl,
        rpcUrl,
        dataProviderAddress,
        start,
        end,
        normalizedOwner,
        timeoutMs
      )
    )
  );

  return results.flat().sort((a, b) => a - b);
}

async function getBeastOwnersRange(
  fetchImpl: typeof fetch,
  rpcUrl: string,
  dataProviderAddress: string,
  startToken: number,
  endToken: number,
  owner: string,
  timeoutMs: number
): Promise<number[]> {
  const params = {
    request: {
      contract_address: dataProviderAddress,
      entry_point_selector: GET_BEAST_OWNERS_RANGE_SELECTOR,
      calldata: [toHex(startToken), toHex(endToken)],
    },
    block_id: "latest",
  };

  const result = await rpcCall(
    fetchImpl,
    rpcUrl,
    "starknet_call",
    params,
    timeoutMs
  );

  if (result.length === 0) {
    return [];
  }

  const count = parseFeltNumber(result[0], "owners_length");
  const matches: number[] = [];

  for (let i = 0; i < count; i++) {
    const ownerIndex = 1 + i;
    if (ownerIndex >= result.length) break;
    const tokenOwner = normalizeStarknetAddress(result[ownerIndex]);
    if (tokenOwner === owner) {
      matches.push(startToken + i);
    }
  }

  return matches;
}

async function getBeastsByTokenIdsViaRpc(
  fetchImpl: typeof fetch,
  rpcUrl: string,
  beastNftAddress: string,
  tokenIds: number[],
  timeoutMs: number,
  concurrency: number
): Promise<BeastOnchain[]> {
  if (tokenIds.length === 0) return [];

  const results = await mapWithConcurrency(tokenIds, concurrency, async (tokenId) => {
    const params = {
      request: {
        contract_address: beastNftAddress,
        entry_point_selector: GET_BEAST_SELECTOR,
        calldata: toU256Calldata(tokenId),
      },
      block_id: "latest",
    };

    const result = await rpcCall(
      fetchImpl,
      rpcUrl,
      "starknet_call",
      params,
      timeoutMs
    );

    if (result.length < 7) {
      throw new Error(`RPC get_beast returned ${result.length} values`);
    }

    return {
      tokenId,
      beastId: parseFeltNumber(result[0], "beast_id"),
      prefix: parseFeltNumber(result[1], "prefix"),
      suffix: parseFeltNumber(result[2], "suffix"),
      level: parseFeltNumber(result[3], "level"),
      health: parseFeltNumber(result[4], "health"),
      shiny: parseFeltNumber(result[5], "shiny"),
      animated: parseFeltNumber(result[6], "animated"),
    };
  });

  return results;
}

async function getBeastRanksViaRpc(
  fetchImpl: typeof fetch,
  rpcUrl: string,
  beastNftAddress: string,
  tokenIds: number[],
  timeoutMs: number,
  concurrency: number
): Promise<Map<number, number>> {
  const ranks = new Map<number, number>();
  if (tokenIds.length === 0) return ranks;

  const results = await mapWithConcurrency(tokenIds, concurrency, async (tokenId) => {
    const params = {
      request: {
        contract_address: beastNftAddress,
        entry_point_selector: GET_BEAST_RANK_SELECTOR,
        calldata: toU256Calldata(tokenId),
      },
      block_id: "latest",
    };

    const result = await rpcCall(
      fetchImpl,
      rpcUrl,
      "starknet_call",
      params,
      timeoutMs
    );

    if (result.length === 0) {
      throw new Error(`RPC get_beast_rank returned empty for ${tokenId}`);
    }

    return [tokenId, parseFeltNumber(result[0], "rank")] as const;
  });

  for (const [tokenId, rank] of results) {
    ranks.set(tokenId, rank);
  }

  return ranks;
}

async function mapWithConcurrency<T, R>(
  items: T[],
  limit: number,
  mapper: (item: T, index: number) => Promise<R>
): Promise<R[]> {
  if (items.length === 0) return [];

  const results = new Array<R>(items.length);
  let nextIndex = 0;
  const safeLimit = Math.max(1, limit);

  const worker = async () => {
    while (true) {
      const currentIndex = nextIndex++;
      if (currentIndex >= items.length) return;
      results[currentIndex] = await mapper(items[currentIndex], currentIndex);
    }
  };

  const workers = Array.from(
    { length: Math.min(safeLimit, items.length) },
    () => worker()
  );
  await Promise.all(workers);

  return results;
}
