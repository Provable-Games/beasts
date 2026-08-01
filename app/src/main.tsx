import { StarknetConfig, jsonRpcProvider, voyager } from '@starknet-react/core';
import React from 'react';
import ReactDOM from 'react-dom/client';
import { App } from './App';
import { RPC_URL, chains, connectors } from './lib/chain';
import './styles.css';

// `publicProvider()` pins RPC spec 0.8.1, which starknet 9.x no longer
// supports — it throws before the tree ever renders. Supplying the node URL
// directly lets the provider negotiate whatever the node actually speaks.
const rpc = () => ({ nodeUrl: RPC_URL });

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <StarknetConfig
      chains={chains}
      provider={jsonRpcProvider({ rpc })}
      connectors={connectors}
      explorer={voyager}
      autoConnect
    >
      <App />
    </StarknetConfig>
  </React.StrictMode>,
);
