import { RpcProvider } from 'starknet';
import { describe, expect, it } from 'vitest';
import { BeastType, BeastsClient, SEPOLIA_ADDRESSES, decodeTokenId } from '../src/index.js';

/**
 * Live reads against the Sepolia deployment in
 * `docs/sepolia-v3-deployment.md`.
 *
 * Skipped by default — they need network and will drift if that deployment is
 * replaced. Run with `pnpm test:live`. Their job is to prove the client's
 * calldata and return-value decoding actually match the deployed ABI, which
 * unit tests with hand-written fixtures cannot.
 */
const RPC_URL = process.env.STARKNET_RPC_URL ?? 'https://api.zan.top/public/starknet-sepolia/rpc/v0_10';
const live = process.env.RUN_LIVE_TESTS ? describe : describe.skip;

const GENESIS_WARLOCK = 0x7006400010000000000000000001n;
const GLOOMFANG = 0x2e0064000a081000000000000004cn;

live('Sepolia deployment', () => {
  const client = new BeastsClient(new RpcProvider({ nodeUrl: RPC_URL }), SEPOLIA_ADDRESSES);

  it('reads the registered community species', async () => {
    const definition = await client.getDefinition(76n);
    expect(definition.name).toBe('Gloomfang');
    expect(definition.beastType).toBe(BeastType.Hunter);
    expect(definition.tier).toBe(3);
    expect(definition.factoryProvider).toBe(true);
    expect(definition.artLocked).toBe(false);
    expect(definition.minterLocked).toBe(false);
    // No stats source was set, so kill stats are off for this species.
    expect(BigInt(definition.statsSource)).toBe(0n);
  }, 30_000);

  it('counts species and supply', async () => {
    expect(await client.speciesCount()).toBeGreaterThanOrEqual(76n);
    expect(await client.totalSupply()).toBeGreaterThanOrEqual(76n);
  }, 30_000);

  it('reports registration only above the genesis range', async () => {
    expect(await client.isRegistered(76n)).toBe(true);
    expect(await client.isRegistered(1n)).toBe(false);
    expect(await client.isRegistered(9_999n)).toBe(false);
  }, 30_000);

  it('ranks the community mint first in its species', async () => {
    expect(await client.getBeastRank(GLOOMFANG)).toBe(1);
    // Genesis Beasts sit outside the ranked list.
    expect(await client.getBeastRank(GENESIS_WARLOCK)).toBe(0);
  }, 30_000);

  it('renders token_uri as base64 JSON with the expected identity', async () => {
    const uri = await client.tokenUri(GLOOMFANG);
    expect(uri.startsWith('data:application/json;base64,')).toBe(true);

    const json = JSON.parse(
      Buffer.from(uri.slice('data:application/json;base64,'.length), 'base64').toString('utf8'),
    );
    expect(json.name).toBe('"Agony Bane" Gloomfang');

    const attribute = (t: string) =>
      json.attributes.find((a: { trait_type: string }) => a.trait_type === t)?.value;
    expect(attribute('Beast')).toBe('Gloomfang');
    expect(attribute('Type')).toBe('Hunter');
    expect(attribute('Tier')).toBe('3');
    expect(attribute('Power')).toBe('30');
    expect(attribute('Genesis')).toBe('0');
  }, 60_000);

  it('fetches art from the species art provider', async () => {
    const art = await client.getArt(decodeTokenId(GLOOMFANG));
    // animated = 1, shiny = 0, so the provider must return the regular GIF.
    expect(art.startsWith('data:image/gif;base64,R0lGOD')).toBe(true);
  }, 30_000);

  it('agrees with the chain on who owns the genesis token', async () => {
    const owner = await client.ownerOf(GENESIS_WARLOCK);
    expect(BigInt(owner)).not.toBe(0n);
  }, 30_000);
});
