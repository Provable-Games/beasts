import { type Beast, type BeastsClient, isGenesis } from '@provable-games/beasts-sdk';
import { useEffect, useMemo, useState } from 'react';
import { artFor, useArt } from '../lib/useArt';
import { BeastTile } from './BeastTile';

interface Props {
  client: BeastsClient;
  address: string;
  isYou: boolean;
  onOpenSpecies: (beastId: bigint) => void;
  onViewAddress: (address: string) => void;
}

/**
 * Every Beast an address holds.
 *
 * The address is a route parameter, not component state, so the URL can be
 * edited to any wallet and shared — viewing someone else's collection needs no
 * connection at all.
 */
export function Collection({ client, address, isYou, onOpenSpecies, onViewAddress }: Props) {
  const [beasts, setBeasts] = useState<Beast[] | null>(null);
  const [names, setNames] = useState<Map<string, string>>(new Map());
  const [error, setError] = useState<string | null>(null);
  const [lookup, setLookup] = useState('');

  useEffect(() => {
    let cancelled = false;
    setBeasts(null);
    setError(null);

    async function load() {
      try {
        const held = await client.getTokensOfOwner(address);
        if (cancelled) return;
        setBeasts(held);

        // One name lookup per distinct species, not per token.
        const species = [...new Set(held.map((b) => b.id.toString()))];
        const resolved = new Map<string, string>();
        for (const id of species) {
          try {
            resolved.set(id, await client.getSpeciesName(BigInt(id)));
          } catch {
            resolved.set(id, `Species ${id}`);
          }
        }
        if (!cancelled) setNames(resolved);
      } catch (e) {
        if (!cancelled) setError(e instanceof Error ? e.message : String(e));
      }
    }

    void load();
    return () => {
      cancelled = true;
    };
  }, [client, address]);

  const art = useArt(client, beasts ?? []);

  const sorted = useMemo(
    () =>
      [...(beasts ?? [])].sort(
        (a, b) => Number(a.id - b.id) || a.prefix - b.prefix || a.suffix - b.suffix,
      ),
    [beasts],
  );

  const genesisCount = sorted.filter(isGenesis).length;

  return (
    <div className="page">
      <header className="page__header">
        <div>
          <h1>{isYou ? 'Your collection' : 'Collection'}</h1>
          <p className="muted">
            <code>{address}</code>
          </p>
          {beasts && (
            <p className="muted">
              {beasts.length} {beasts.length === 1 ? 'Beast' : 'Beasts'}
              {genesisCount > 0 &&
                ` · ${genesisCount} Genesis ${genesisCount === 1 ? 'Beast' : 'Beasts'}, so ${genesisCount === 1 ? 'one species' : `${genesisCount} species`} controlled`}
            </p>
          )}
        </div>

        <form
          className="lookup"
          onSubmit={(e) => {
            e.preventDefault();
            if (lookup.trim()) onViewAddress(lookup.trim());
          }}
        >
          <input
            value={lookup}
            placeholder="View another address"
            onChange={(e) => setLookup(e.target.value)}
          />
          <button type="submit" disabled={!lookup.trim()}>
            View
          </button>
        </form>
      </header>

      {error && <p className="field__error">{error}</p>}
      {beasts === null && !error && <p className="muted">Reading the collection…</p>}
      {beasts?.length === 0 && (
        <div className="empty">
          <p>{isYou ? 'You hold no Beasts yet.' : 'This address holds no Beasts.'}</p>
        </div>
      )}

      <div className="tiles">
        {sorted.map((beast) => (
          <BeastTile
            key={`${beast.id}-${beast.prefix}-${beast.suffix}`}
            beast={beast}
            speciesName={names.get(beast.id.toString()) ?? `Species ${beast.id}`}
            art={artFor(art, beast)}
            onClick={() => onOpenSpecies(beast.id)}
          />
        ))}
      </div>
    </div>
  );
}
