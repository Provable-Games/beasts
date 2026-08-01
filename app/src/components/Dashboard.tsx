import {
  BEAST_TYPE_NAMES,
  type BeastDefinition,
  type BeastsClient,
} from '@provable-games/beasts-sdk';
import { useState } from 'react';
import { ART_SLOTS, loadArtFile, type ArtSlot, type LoadedArt } from '../lib/art';

interface Props {
  beastId: bigint;
  definition: BeastDefinition;
  client: BeastsClient;
  isArtist: boolean;
  onChanged: () => void;
}

const ZERO = '0x0';

/**
 * Per-species controls. Every action here is artist-only on-chain; the UI
 * simply hides what the caller cannot do, and the contract is the real gate.
 */
export function Dashboard({ beastId, definition, client, isArtist, onChanged }: Props) {
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [minter, setMinter] = useState(definition.minter);
  const [statsSource, setStatsSource] = useState(definition.statsSource);
  const [newArtist, setNewArtist] = useState('');
  const [customProvider, setCustomProvider] = useState('');
  const [art, setArt] = useState<Partial<Record<ArtSlot, LoadedArt>>>({});

  async function run(label: string, build: () => Parameters<BeastsClient['execute']>[0]) {
    setBusy(label);
    setError(null);
    try {
      await client.execute(build());
      onChanged();
    } catch (e) {
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(null);
    }
  }

  const paused = BigInt(definition.minter) === 0n;
  const artComplete = ART_SLOTS.every(({ slot }) => art[slot]);

  return (
    <div className="dashboard">
      <header className="dashboard__header">
        <div>
          <h2>
            {definition.name} <span className="muted">#{beastId.toString()}</span>
          </h2>
          <p className="muted">
            {BEAST_TYPE_NAMES[definition.beastType]} · Tier {definition.tier} ·{' '}
            {definition.factoryProvider ? 'Verified art' : 'Custom provider'}
          </p>
        </div>
        <div className="badges">
          {paused && <span className="badge badge--warn">Minting paused</span>}
          {definition.artLocked && <span className="badge">Art locked</span>}
          {definition.minterLocked && <span className="badge">Minter locked</span>}
        </div>
      </header>

      {!isArtist && (
        <p className="notice">
          You are not the artist for this species. These controls are read-only.
        </p>
      )}
      {error && <p className="field__error">{error}</p>}

      <section className="panel">
        <h3>Minting</h3>
        {definition.minterLocked ? (
          <p className="muted">
            The minter is locked to <code>{short(definition.minter)}</code> and can
            never change. Holders can rely on that.
          </p>
        ) : (
          <>
            <p className="muted">
              Set to zero to pause. Pausing stops new mints; it never affects
              Beasts already minted.
            </p>
            <div className="row">
              <input
                value={minter}
                placeholder="0x..."
                disabled={!isArtist || !!busy}
                onChange={(e) => setMinter(e.target.value)}
              />
              <button
                disabled={!isArtist || !!busy}
                onClick={() => run('minter', () => client.setMinterCall(beastId, minter))}
              >
                {busy === 'minter' ? 'Saving…' : 'Set minter'}
              </button>
              <button
                disabled={!isArtist || !!busy || paused}
                onClick={() => run('pause', () => client.setMinterCall(beastId, ZERO))}
              >
                Pause
              </button>
            </div>
            <button
              className="danger"
              disabled={!isArtist || !!busy || paused}
              onClick={() => {
                if (
                  confirm(
                    'Locking the minter is permanent. The minting address can never change again. Continue?',
                  )
                ) {
                  run('lockMinter', () => client.lockMinterCall(beastId));
                }
              }}
            >
              Lock minter forever
            </button>
          </>
        )}
      </section>

      <section className="panel">
        <h3>Artwork</h3>
        {definition.artLocked ? (
          <p className="muted">
            Art is locked.{' '}
            {definition.factoryProvider
              ? 'This species is frozen: the art is stored onchain and can never change.'
              : 'The provider address is frozen, but a custom provider can still change what it returns — so refreshes stay available.'}
          </p>
        ) : definition.factoryProvider ? (
          <>
            <p className="muted">
              Replacing art re-renders every Beast of this species and notifies
              marketplaces automatically. Limited to one refresh per hour.
            </p>
            <div className="art-grid art-grid--compact">
              {ART_SLOTS.map(({ slot, label, kind, accept }) => (
                <label key={slot} className="art-slot art-slot--compact">
                  <span className="art-slot__label">{label}</span>
                  {art[slot] ? (
                    <img src={art[slot]!.dataUri} alt={label} />
                  ) : (
                    <span className="art-slot__placeholder">{kind.toUpperCase()}</span>
                  )}
                  <input
                    type="file"
                    accept={accept}
                    disabled={!isArtist || !!busy}
                    onChange={async (e) => {
                      const file = e.target.files?.[0];
                      if (!file) return;
                      try {
                        const loaded = await loadArtFile(file, kind);
                        setArt((a) => ({ ...a, [slot]: loaded }));
                      } catch (err) {
                        setError(err instanceof Error ? err.message : String(err));
                      }
                    }}
                  />
                </label>
              ))}
            </div>
            <button
              disabled={!isArtist || !!busy || !artComplete}
              onClick={() =>
                run('art', () =>
                  client.updateArtCall(beastId, {
                    pngRegular: art.pngRegular!.dataUri,
                    pngShiny: art.pngShiny!.dataUri,
                    gifRegular: art.gifRegular!.dataUri,
                    gifShiny: art.gifShiny!.dataUri,
                  }),
                )
              }
            >
              {busy === 'art' ? 'Updating…' : 'Replace all four variants'}
            </button>
          </>
        ) : (
          <>
            <p className="muted">
              This species renders through your own provider at{' '}
              <code>{short(definition.artProvider)}</code>. Announce changes so
              marketplaces re-read it.
            </p>
            <button
              disabled={!isArtist || !!busy}
              onClick={() => run('notify', () => client.notifyArtUpdatedCall(beastId))}
            >
              {busy === 'notify' ? 'Refreshing…' : 'Refresh metadata'}
            </button>
          </>
        )}

        <details className="advanced">
          <summary>Advanced: swap art provider</summary>
          <p className="muted">
            Point this species at your own <code>IBeastArtProvider</code> contract
            to vary art by affix, tier or level. Your provider must return an
            allowlisted image data URI or rendering will fail for your species.
          </p>
          <div className="row">
            <input
              value={customProvider}
              placeholder="0x..."
              disabled={!isArtist || !!busy || definition.artLocked}
              onChange={(e) => setCustomProvider(e.target.value)}
            />
            <button
              disabled={!isArtist || !!busy || definition.artLocked || !customProvider}
              onClick={() =>
                run('provider', () => client.setArtProviderCall(beastId, customProvider))
              }
            >
              Swap provider
            </button>
          </div>
        </details>

        {!definition.artLocked && (
          <button
            className="danger"
            disabled={!isArtist || !!busy}
            onClick={() => {
              if (
                confirm(
                  'Locking art is permanent. For verified (factory) art this freezes your species forever. Continue?',
                )
              ) {
                run('lockArt', () => client.lockArtCall(beastId));
              }
            }}
          >
            Lock art forever
          </button>
        )}
      </section>

      <section className="panel">
        <h3>Kill stats</h3>
        <p className="muted">
          Optional. A stats source lets your Beasts show how many Adventurers
          they have slain. It must implement the stats interface; set zero to
          turn stats off.
        </p>
        <div className="row">
          <input
            value={statsSource}
            placeholder="0x0"
            disabled={!isArtist || !!busy}
            onChange={(e) => setStatsSource(e.target.value)}
          />
          <button
            disabled={!isArtist || !!busy}
            onClick={() => run('stats', () => client.setStatsSourceCall(beastId, statsSource))}
          >
            {busy === 'stats' ? 'Saving…' : 'Set source'}
          </button>
        </div>
      </section>

      <section className="panel">
        <h3>Transfer artist role</h3>
        <p className="muted">
          Hands every control on this page to another address. This does not move
          your Genesis Beast — that is an ordinary NFT you keep or sell
          separately.
        </p>
        <div className="row">
          <input
            value={newArtist}
            placeholder="0x..."
            disabled={!isArtist || !!busy}
            onChange={(e) => setNewArtist(e.target.value)}
          />
          <button
            className="danger"
            disabled={!isArtist || !!busy || !newArtist}
            onClick={() => {
              if (confirm(`Hand control of ${definition.name} to ${newArtist}?`)) {
                run('artist', () => client.transferArtistRoleCall(beastId, newArtist));
              }
            }}
          >
            Transfer
          </button>
        </div>
      </section>
    </div>
  );
}

function short(address: string): string {
  const hex = BigInt(address).toString(16);
  if (hex === '0') return '0x0';
  return `0x${hex.slice(0, 4)}…${hex.slice(-4)}`;
}
