import {
  BEAST_TYPE_NAMES,
  MAX_SUPPLY_PER_SPECIES,
  type Beast,
  type BeastsClient,
  type SpeciesSummary,
  decodeTokenId,
  isGenesis,
} from '@provable-games/beasts-sdk';
import { useEffect, useState } from 'react';
import { artFor, useArt } from '../lib/useArt';
import { BeastTile } from './BeastTile';

interface Props {
  client: BeastsClient;
  beastId: bigint;
  onBack: () => void;
  onViewOwner: (address: string) => void;
}

interface Entry {
  beast: Beast;
  rank: number;
  owner?: string;
}

/**
 * Every Beast of one species, strongest first.
 *
 * Read from the contract's own per-species rank list rather than by scanning:
 * the NFT already keeps `rank -> token_id` to drive metadata refreshes, so the
 * ordering here is the same one the collection itself uses.
 */
export function SpeciesCollection({ client, beastId, onBack, onViewOwner }: Props) {
  const [summary, setSummary] = useState<SpeciesSummary | null>(null);
  const [entries, setEntries] = useState<Entry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    setEntries([]);
    setSummary(null);
    setLoading(true);
    setError(null);

    async function load() {
      try {
        const info = await client.getSpeciesSummary(beastId);
        if (cancelled) return;
        setSummary(info);

        const tokens = await client.getSpeciesTokens(beastId);
        if (cancelled) return;

        const collected: Entry[] = [];
        for (let i = 0; i < tokens.length && !cancelled; i += 4) {
          const batch = await Promise.all(
            tokens.slice(i, i + 4).map(async (tokenId) => {
              const beast = decodeTokenId(tokenId);
              const owner = await client.ownerOf(tokenId).catch(() => undefined);
              return { beast, rank: isGenesis(beast) ? 0 : 0, owner };
            }),
          );
          collected.push(...batch);
          if (!cancelled) setEntries([...collected]);
        }

        // Tokens arrive in rank order from the contract's list, with the
        // Genesis Beast appended last.
        if (!cancelled) {
          setEntries(
            collected.map((entry, index) => ({
              ...entry,
              rank: isGenesis(entry.beast) ? 0 : index + 1,
            })),
          );
        }
      } catch (e) {
        if (!cancelled) setError(e instanceof Error ? e.message : String(e));
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    void load();
    return () => {
      cancelled = true;
    };
  }, [client, beastId]);

  const art = useArt(
    client,
    entries.map((e) => e.beast),
  );

  return (
    <div className="page">
      <button className="backlink" onClick={onBack}>
        ← The bestiary
      </button>

      <header className="page__header">
        <div>
          <h1>
            {summary?.name ?? 'Species'} <span className="muted">#{beastId.toString()}</span>
          </h1>
          {summary && (
            <p className="muted">
              {BEAST_TYPE_NAMES[summary.beastType]} · Tier {summary.tier} ·{' '}
              {summary.minted} of {MAX_SUPPLY_PER_SPECIES.toLocaleString()} minted
              {summary.community ? '' : ' · one of the original 75'}
            </p>
          )}
        </div>
      </header>

      {error && <p className="field__error">{error}</p>}
      {loading && entries.length === 0 && !error && <p className="muted">Reading the species…</p>}
      {!loading && entries.length === 0 && !error && (
        <div className="empty">
          <p>No Beasts of this species have been minted yet.</p>
        </div>
      )}

      <div className="tiles">
        {entries.map((entry) => (
          <BeastTile
            key={`${entry.beast.prefix}-${entry.beast.suffix}`}
            beast={entry.beast}
            speciesName={summary?.name ?? `Species ${beastId}`}
            art={artFor(art, entry.beast)}
            rank={entry.rank}
            onClick={entry.owner ? () => onViewOwner(entry.owner!) : undefined}
          />
        ))}
      </div>
    </div>
  );
}
