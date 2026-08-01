import { useAccount, useDisconnect } from '@starknet-react/core';
import { BeastsClient, type BeastDefinition } from '@provable-games/beasts-sdk';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { ADDRESSES, provider } from './lib/chain';
import { href, useRoute } from './lib/router';
import { Collection } from './components/Collection';
import { ConnectModal } from './components/ConnectModal';
import { Dashboard } from './components/Dashboard';
import { MySpecies } from './components/MySpecies';
import { RegisterForm, type RegistrationInput } from './components/RegisterForm';
import { SpeciesCollection } from './components/SpeciesCollection';
import { SpeciesIndex } from './components/SpeciesIndex';

export function App() {
  const { address, account } = useAccount();
  const { disconnect } = useDisconnect();
  const [route, navigate] = useRoute();

  const [connecting, setConnecting] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | undefined>();
  const [definition, setDefinition] = useState<BeastDefinition | null>(null);
  const [speciesCount, setSpeciesCount] = useState<bigint | null>(null);

  const client = useMemo(() => new BeastsClient(provider(), ADDRESSES, account), [account]);

  const refresh = useCallback(async () => {
    setSpeciesCount(await client.speciesCount().catch(() => null));
    if (route.name !== 'manage-species') {
      setDefinition(null);
      return;
    }
    try {
      setDefinition(await client.getDefinition(route.beastId));
      setError(undefined);
    } catch {
      setDefinition(null);
      setError(`Species ${route.beastId} is not registered`);
    }
  }, [client, route]);

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
      navigate({ name: 'manage-species', beastId: before + 1n });
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setSubmitting(false);
    }
  }

  const isArtist = !!address && !!definition && BigInt(definition.artist) === BigInt(address);

  function openMine() {
    if (address) navigate({ name: 'manage' });
    else setConnecting(true);
  }

  function openMyCollection() {
    if (address) navigate({ name: 'collection', address });
    else setConnecting(true);
  }

  return (
    <div className="app">
      <header className="topbar">
        <a className="brand" href={href({ name: 'register' })}>
          Add a Beast
        </a>

        <nav className="topbar__right">
          <a className="navlink" href={href({ name: 'species-index' })}>
            Bestiary
          </a>
          <button onClick={openMyCollection} title="Beasts you hold">
            Collection
          </button>
          <button onClick={openMine} title="Species you control">
            Manage
          </button>

          {address ? (
            <button onClick={() => disconnect()} title="Disconnect">
              {`0x${BigInt(address).toString(16).slice(0, 6)}…`}
            </button>
          ) : (
            <button className="primary" onClick={() => setConnecting(true)}>
              Connect
            </button>
          )}
        </nav>
      </header>

      <main>
        {route.name === 'register' && (
          <>
            <div className="hero">
              <h1>Put your Beast onchain</h1>
              <p>
                Anyone can add a species to the bestiary. Upload pixel art, name it,
                pick where it lives — one transaction, no permission needed. You keep
                the Genesis Beast: the creator's token, one per species, forever.
              </p>
              {speciesCount !== null && (
                <p className="muted">
                  {speciesCount.toString()} species in the bestiary so far.
                </p>
              )}
            </div>
            <RegisterForm onSubmit={register} submitting={submitting} error={error} />
          </>
        )}

        {route.name === 'collection' && (
          <Collection
            client={client}
            address={route.address}
            isYou={!!address && safeEquals(address, route.address)}
            onOpenSpecies={(beastId) => navigate({ name: 'species', beastId })}
            onViewAddress={(next) => navigate({ name: 'collection', address: next })}
          />
        )}

        {route.name === 'species-index' && (
          <SpeciesIndex
            client={client}
            onOpen={(beastId) => navigate({ name: 'species', beastId })}
          />
        )}

        {route.name === 'species' && (
          <SpeciesCollection
            client={client}
            beastId={route.beastId}
            onBack={() => navigate({ name: 'species-index' })}
            onViewOwner={(owner) => navigate({ name: 'collection', address: owner })}
          />
        )}

        {route.name === 'manage' &&
          (address ? (
            <MySpecies
              client={client}
              address={address}
              onOpen={(beastId) => navigate({ name: 'manage-species', beastId })}
              onRegister={() => navigate({ name: 'register' })}
            />
          ) : (
            <div className="empty">
              <p>Connect a wallet to see the species you control.</p>
              <button className="primary" onClick={() => setConnecting(true)}>
                Connect
              </button>
            </div>
          ))}

        {route.name === 'manage-species' &&
          (definition ? (
            <>
              <button className="backlink" onClick={openMine}>
                ← Your Beasts
              </button>
              <Dashboard
                address={address}
                beastId={route.beastId}
                definition={definition}
                client={client}
                isArtist={isArtist}
                onChanged={() => void refresh()}
              />
            </>
          ) : (
            <div className="empty">
              <p>{error ?? 'Loading…'}</p>
              <a className="navlink" href={href({ name: 'species-index' })}>
                Browse the bestiary
              </a>
            </div>
          ))}
      </main>

      <footer className="footer">
        <span>
          Sepolia · Registry <code>{shortAddr(ADDRESSES.registry)}</code> · Collection{' '}
          <code>{shortAddr(ADDRESSES.nft)}</code>
        </span>
      </footer>

      {connecting && <ConnectModal onClose={() => setConnecting(false)} />}
    </div>
  );
}

/** Addresses differ in padding and case, so compare numerically. */
function safeEquals(a: string, b: string): boolean {
  try {
    return BigInt(a) === BigInt(b);
  } catch {
    return false;
  }
}

function shortAddr(address: string): string {
  const hex = BigInt(address).toString(16);
  return `0x${hex.slice(0, 6)}…${hex.slice(-4)}`;
}
