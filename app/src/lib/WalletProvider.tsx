import {
  StarknetConfig,
  braavos,
  jsonRpcProvider,
  ready,
  useInjectedConnectors,
  voyager,
} from '@starknet-react/core';
import type { PropsWithChildren } from 'react';
import { RPC_URL, chains, controllerConnector } from './chain';

/**
 * Wallet wiring for the app.
 *
 * Two kinds of wallet, deliberately both supported: Cartridge Controller
 * (no extension, good for a first-time artist) and any injected browser
 * wallet — Ready (formerly Argent) and Braavos are surfaced as recommended
 * even when not installed, so the picker shows what is possible rather than
 * only what is present.
 *
 * `useInjectedConnectors` scans `window.starknet*`, so it must run inside a
 * component; the connector list is then handed to `StarknetConfig` as a prop.
 */
export function WalletProvider({ children }: PropsWithChildren) {
  const { connectors: injected } = useInjectedConnectors({
    recommended: [ready(), braavos()],
    includeRecommended: 'always',
    order: 'alphabetical',
  });

  // `publicProvider()` pins RPC spec 0.8.1, which starknet 9.x dropped — it
  // throws before the tree ever renders. Naming the node lets the provider
  // negotiate whatever that node actually speaks.
  const rpc = () => ({ nodeUrl: RPC_URL });

  return (
    <StarknetConfig
      chains={chains}
      provider={jsonRpcProvider({ rpc })}
      connectors={[controllerConnector, ...injected]}
      explorer={voyager}
      autoConnect
    >
      {children}
    </StarknetConfig>
  );
}
