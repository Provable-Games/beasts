import ControllerConnector from '@cartridge/connector/controller';
import { sepolia } from '@starknet-react/chains';
import { SEPOLIA_ADDRESSES } from '@provable-games/beasts-sdk';
import { RpcProvider } from 'starknet';

export const RPC_URL =
  import.meta.env.VITE_STARKNET_RPC_URL ??
  'https://api.cartridge.gg/x/starknet/sepolia';

export const ADDRESSES = {
  nft: import.meta.env.VITE_BEASTS_NFT ?? SEPOLIA_ADDRESSES.nft,
  registry: import.meta.env.VITE_BEASTS_REGISTRY ?? SEPOLIA_ADDRESSES.registry,
  // Event scans start here. Point this at your own deployment block if you
  // override the addresses, or artist lookups will scan a range that predates
  // the contracts — and some public nodes answer an over-wide range with an
  // empty result rather than an error.
  fromBlock: Number(import.meta.env.VITE_BEASTS_FROM_BLOCK ?? SEPOLIA_ADDRESSES.fromBlock),
};

/** Sepolia only. Everything this app talks to is deployed there. */
export const chains = [sepolia];

export const provider = () => new RpcProvider({ nodeUrl: RPC_URL });

/**
 * Cartridge Controller with the registry's *management* entrypoints
 * pre-approved, so an artist signs once and can then iterate on their species —
 * update art, rotate the minter, refresh metadata — without a popup for every
 * change.
 *
 * `register_beast_with_art` is deliberately NOT in the session policy: it
 * mints the artist's provenance token and permanently assigns a species ID, so
 * it should always be an explicit, visible signature.
 */
export const controllerConnector = new ControllerConnector({
  chains: [{ rpcUrl: RPC_URL }],
  // Must be 0x-prefixed hex; the bare digits parse as neither hex nor decimal.
  defaultChainId: `0x${sepolia.id.toString(16)}`,
  propagateSessionErrors: true,
  policies: {
    contracts: {
      [ADDRESSES.registry]: {
        name: 'Beast Registry',
        methods: [
          { name: 'Update art', entrypoint: 'update_art' },
          { name: 'Set minter', entrypoint: 'set_minter' },
          { name: 'Set art provider', entrypoint: 'set_art_provider' },
          { name: 'Refresh metadata', entrypoint: 'notify_art_updated' },
          { name: 'Set stats source', entrypoint: 'set_stats_source' },
        ],
      },
    },
  },
});
