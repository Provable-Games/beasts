import {
  BEAST_TYPE_NAMES,
  type BeastsClient,
  type OwnedSpecies,
  decodeTokenId,
} from '@provable-games/beasts-sdk';
import { useCallback, useEffect, useState } from 'react';

interface Props {
  client: BeastsClient;
  address: string;
  onOpen: (beastId: bigint) => void;
  onRegister: () => void;
}

interface Row extends OwnedSpecies {
  /** Undefined while loading; null when the provider could not be read. */
  art?: string | null;
}

/**
 * Everything the connected wallet controls.
 *
 * "Controls" means holding the artist role, which is what the registry's
 * permissioned entrypoints actually check — not holding the Genesis Beast.
 * The two start together but diverge the moment either is transferred, and
 * showing the wrong one would offer controls that revert.
 */
export function MySpecies({ client, address, onOpen, onRegister }: Props) {
  const [rows, setRows] = useState<Row[] | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [lookup, setLookup] = useState('');

  const load = useCallback(async () => {
    setRows(null);
    setError(null);
    try {
      const owned = await client.getOwnedSpecies(address);
      setRows(owned);

      // Art comes from each species' own provider, which for a custom
      // provider is arbitrary contract code. One that reverts must cost its
      // own thumbnail, not the whole list.
      const withArt = await Promise.all(
        owned.map(async (species) => {
          try {
            const beast = decodeTokenId(species.genesisTokenId);
            return { ...species, art: await client.getArt(beast) };
          } catch {
            return { ...species, art: null };
          }
        }),
      );
      setRows(withArt);
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    }
  }, [client, address]);

  useEffect(() => {
    void load();
  }, [load]);

  return (
    <div className="mine">
      <header className="mine__header">
        <div>
          <h1>Your Beasts</h1>
          <p className="muted">
            Species you hold the artist role for. That role — not the Genesis
            Beast — is what the contract checks.
          </p>
        </div>
        <form
          className="lookup"
          onSubmit={(e) => {
            e.preventDefault();
            if (lookup) onOpen(BigInt(lookup));
          }}
        >
          <input
            value={lookup}
            placeholder="Open by ID"
            inputMode="numeric"
            onChange={(e) => setLookup(e.target.value.replace(/\D/g, ''))}
          />
          <button type="submit" disabled={!lookup}>
            Open
          </button>
        </form>
      </header>

      {error && <p className="field__error">{error}</p>}

      {rows === null && !error && <p className="muted">Looking up your species…</p>}

      {rows?.length === 0 && (
        <div className="empty">
          <p>You haven’t added a Beast yet.</p>
          <button className="primary" onClick={onRegister}>
            Add your first Beast
          </button>
        </div>
      )}

      {rows && rows.length > 0 && (
        <ul className="species-grid">
          {rows.map((row) => {
            const paused = BigInt(row.definition.minter) === 0n;
            return (
              <li key={row.beastId.toString()}>
                <button className="species-card" onClick={() => onOpen(row.beastId)}>
                  <div className="species-card__art">
                    {row.art ? (
                      <img src={row.art} alt={row.definition.name} />
                    ) : (
                      <span className="species-card__art-empty">
                        {row.art === null ? 'Art unavailable' : '…'}
                      </span>
                    )}
                  </div>

                  <div className="species-card__body">
                    <div className="species-card__title">
                      {row.definition.name}
                      <span className="muted"> #{row.beastId.toString()}</span>
                    </div>
                    <div className="muted">
                      {BEAST_TYPE_NAMES[row.definition.beastType]} · Tier{' '}
                      {row.definition.tier} ·{' '}
                      {row.definition.factoryProvider ? 'Verified art' : 'Custom provider'}
                    </div>

                    <div className="badges">
                      {paused ? (
                        <span className="badge badge--warn">Minting paused</span>
                      ) : (
                        <span className="badge badge--ok">Minting live</span>
                      )}
                      {row.definition.artLocked && <span className="badge">Art locked</span>}
                      {row.definition.minterLocked && (
                        <span className="badge">Minter locked</span>
                      )}
                    </div>
                  </div>
                </button>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
