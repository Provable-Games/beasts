import { useAccount, useConnect, useDisconnect } from '@starknet-react/core';
import {
  BeastsClient,
  FIRST_COMMUNITY_ID,
  type BeastDefinition,
} from '@provable-games/beasts-sdk';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { ADDRESSES, provider } from './lib/chain';
import { Dashboard } from './components/Dashboard';
import { RegisterForm, type RegistrationInput } from './components/RegisterForm';

type View = { kind: 'register' } | { kind: 'species'; id: bigint };

export function App() {
  const { address, account } = useAccount();
  const { connect, connectors } = useConnect();
  const { disconnect } = useDisconnect();

  const [view, setView] = useState<View>({ kind: 'register' });
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | undefined>();
  const [definition, setDefinition] = useState<BeastDefinition | null>(null);
  const [speciesCount, setSpeciesCount] = useState<bigint | null>(null);
  const [lookup, setLookup] = useState('');

  const client = useMemo(
    () => new BeastsClient(provider(), ADDRESSES, account),
    [account],
  );

  const refresh = useCallback(async () => {
    setSpeciesCount(await client.speciesCount().catch(() => null));
    if (view.kind !== 'species') {
      setDefinition(null);
      return;
    }
    try {
      setDefinition(await client.getDefinition(view.id));
      setError(undefined);
    } catch {
      setDefinition(null);
      setError(`Species ${view.id} is not registered`);
    }
  }, [client, view]);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  async function register(input: RegistrationInput) {
    setSubmitting(true);
    setError(undefined);
    try {
      const before = await client.speciesCount();
      await client.execute(
        client.registerWithArtCall({
          name: input.name,
          beastType: input.beastType,
          tier: input.tier,
          minter: input.minter,
          art: input.art,
        }),
      );
      // species_count counts genesis too, so the new ID is the old count + 1.
      setView({ kind: 'species', id: before + 1n });
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setSubmitting(false);
    }
  }

  const isArtist =
    !!address && !!definition && BigInt(definition.artist) === BigInt(address);

  return (
    <div className="app">
      <header className="topbar">
        <button className="brand" onClick={() => setView({ kind: 'register' })}>
          Add a Beast
        </button>

        <div className="topbar__right">
          <form
            className="lookup"
            onSubmit={(e) => {
              e.preventDefault();
              const id = BigInt(lookup || '0');
              if (id >= FIRST_COMMUNITY_ID) setView({ kind: 'species', id });
            }}
          >
            <input
              value={lookup}
              placeholder="Species #"
              inputMode="numeric"
              onChange={(e) => setLookup(e.target.value.replace(/\D/g, ''))}
            />
            <button type="submit">Manage</button>
          </form>

          {address ? (
            <button onClick={() => disconnect()}>
              {`0x${BigInt(address).toString(16).slice(0, 6)}…`}
            </button>
          ) : (
            <button className="primary" onClick={() => connect({ connector: connectors[0] })}>
              Connect
            </button>
          )}
        </div>
      </header>

      <main>
        {view.kind === 'register' ? (
          <>
            <div className="hero">
              <h1>Put your Beast onchain</h1>
              <p>
                Anyone can add a species to the bestiary. Upload pixel art, name
                it, pick where it lives — one transaction, no permission needed.
                You keep the Genesis Beast: the creator's token, one per species,
                forever.
              </p>
              {speciesCount !== null && (
                <p className="muted">
                  {speciesCount.toString()} species in the bestiary so far.
                </p>
              )}
            </div>
            <RegisterForm onSubmit={register} submitting={submitting} error={error} />
          </>
        ) : definition ? (
          <Dashboard
            beastId={view.id}
            definition={definition}
            client={client}
            isArtist={isArtist}
            onChanged={() => void refresh()}
          />
        ) : (
          <div className="empty">
            <p>{error ?? 'Loading…'}</p>
            <button onClick={() => setView({ kind: 'register' })}>
              Register a new Beast
            </button>
          </div>
        )}
      </main>

      <footer className="footer">
        <span>
          Registry <code>{shortAddr(ADDRESSES.registry)}</code> · Collection{' '}
          <code>{shortAddr(ADDRESSES.nft)}</code>
        </span>
      </footer>
    </div>
  );
}

function shortAddr(address: string): string {
  const hex = BigInt(address).toString(16);
  return `0x${hex.slice(0, 6)}…${hex.slice(-4)}`;
}
