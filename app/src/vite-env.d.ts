/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_STARKNET_RPC_URL?: string;
  readonly VITE_BEASTS_NFT?: string;
  readonly VITE_BEASTS_REGISTRY?: string;
  readonly VITE_BEASTS_FROM_BLOCK?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
