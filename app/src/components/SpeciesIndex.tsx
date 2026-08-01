import {
  BEAST_TYPE_NAMES,
  type BeastsClient,
  type SpeciesSummary,
  genesisBeast,
} from '@provable-games/beasts-sdk';
import { useEffect, useState } from 'react';
import { artFor, useArt } from '../lib/useArt';

interface Props {
  client: BeastsClient;
  onOpen: (beastId: bigint) => void;
}

/**
 * The whole bestiary, one card per species.
 *
 * Grouping by species is the default because the collection is unbounded and
 * a species can hold up to 1,243 Beasts — a flat list of every token would be
 * unreadable long before it was useful. Selecting a species opens its own
 * collection.
 *
 * Each card shows the species' Genesis Beast as the representative art: it is
 * the one Beast guaranteed to exist for every registered species.
 */
export function SpeciesIndex({ client, onOpen }: Props) {
  const [species, setSpecies] = useState<SpeciesSummary[]>([]);
  const [total, setTotal] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [showGenesis, setShowGenesis] = useState(false);

  useEffect(() => {
    let cancelled = false;
    setSpecies([]);
    setError(null);

    async function load() {
      try {
        const count = Number(await client.speciesCount());
        if (cancelled) return;
        setTotal(count);

        // Community species first — they are the ones that change.
        const order = [
          ...range(76, count),
          ...(showGenesis ? range(1, Math.min(75, count)) : []),
        ];

        const collected: SpeciesSummary[] = [];
        for (let i = 0; i < order.length && !cancelled; i += 4) {
          const batch = await Promise.all(
            order.slice(i, i + 4).map((id) =>
              client.getSpeciesSummary(BigInt(id)).catch(() => null),
            ),
          );
          collected.push(...batch.filter((s): s is SpeciesSummary => s !== null));
          if (!cancelled) setSpecies([...collected]);
        }
      } catch (e) {
        if (!cancelled) setError(e instanceof Error ? e.message : String(e));
      }
    }

    void load();
    return () => {
      cancelled = true;
    };
  }, [client, showGenesis]);

  const representatives = species.map((s) => genesisBeast(s.beastId, s.tier, s.beastType));
  const art = useArt(client, representatives);

  return (
    <div className="page">
      <header className="page__header">
        <div>
          <h1>The bestiary</h1>
          <p className="muted">
            {total === null
              ? 'Counting species…'
              : showGenesis
                ? `All ${total} species. Open one to see every Beast of its kind.`
                : `${Math.max(0, total - 75)} community ${total - 75 === 1 ? 'species' : 'species'} of ${total}. Open one to see every Beast of its kind.`}
          </p>
        </div>
        <label className="toggle">
          <input
            type="checkbox"
            checked={showGenesis}
            onChange={(e) => setShowGenesis(e.target.checked)}
          />
          <span>Include the original 75</span>
        </label>
      </header>

      {error && <p className="field__error">{error}</p>}
      {species.length === 0 && !error && <p className="muted">Loading species…</p>}

      <div className="tiles">
        {species.map((s, index) => (
          <button
            key={s.beastId.toString()}
            className="tile tile--clickable"
            onClick={() => onOpen(s.beastId)}
          >
            <div className="tile__art">
              {(() => {
                const uri = artFor(art, representatives[index]);
                if (uri === undefined) return <span className="tile__art-note">…</span>;
                if (uri === null) return <span className="tile__art-note">Art unavailable</span>;
                return <img src={uri} alt={s.name} />;
              })()}
              {!s.community && <span className="tile__badge">Original</span>}
            </div>

            <div className="tile__name" title={s.name}>
              {s.name} <span className="muted">#{s.beastId.toString()}</span>
            </div>
            <div className="tile__meta">
              {BEAST_TYPE_NAMES[s.beastType]} · Tier {s.tier}
            </div>
            <div className="tile__stats">
              <span>
                {s.minted} minted
              </span>
              <span>of 1,243</span>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}

function range(from: number, to: number): number[] {
  return to < from ? [] : Array.from({ length: to - from + 1 }, (_, i) => from + i);
}
