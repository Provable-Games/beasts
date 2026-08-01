import { useAccount } from '@starknet-react/core';
import {
  BEAST_TYPE_NAMES,
  BeastType,
  MAX_NAME_BYTES,
  MAX_SUPPLY_PER_SPECIES,
  validateSpeciesName,
  validateTier,
} from '@provable-games/beasts-sdk';
import { useMemo, useState } from 'react';
import { ART_SLOTS, totalStorageSlots, type ArtSlot, type LoadedArt } from '../lib/art';
import { ArtUpload } from './ArtUpload';
import { CardPreview } from './CardPreview';

export interface RegistrationInput {
  name: string;
  tier: number;
  beastType: BeastType;
  minter: string;
  art: { pngRegular: string; pngShiny: string; gifRegular: string; gifShiny: string };
}

interface Props {
  onSubmit: (input: RegistrationInput) => void;
  submitting: boolean;
  error?: string;
}

const ZERO = '0x0';

export function RegisterForm({ onSubmit, submitting, error }: Props) {
  const { address } = useAccount();
  const [name, setName] = useState('');
  const [tier, setTier] = useState(3);
  const [beastType, setBeastType] = useState<BeastType>(BeastType.Magic);
  const [minterMode, setMinterMode] = useState<'later' | 'custom'>('later');
  const [minter, setMinter] = useState('');
  const [loaded, setLoaded] = useState<Partial<Record<ArtSlot, LoadedArt>>>({});
  const [preview, setPreview] = useState<ArtSlot>('pngRegular');

  const nameCheck = name ? validateSpeciesName(name) : { valid: false };
  const tierCheck = validateTier(tier);
  const missingArt = ART_SLOTS.filter(({ slot }) => !loaded[slot]);
  const minterValid = minterMode === 'later' || /^0x[0-9a-fA-F]{1,64}$/.test(minter.trim());

  const ready =
    nameCheck.valid && tierCheck.valid && missingArt.length === 0 && minterValid && !!address;

  const slots = useMemo(() => totalStorageSlots(loaded), [loaded]);

  function submit() {
    if (!ready) return;
    onSubmit({
      name,
      tier,
      beastType,
      minter: minterMode === 'later' ? ZERO : minter.trim(),
      art: {
        pngRegular: loaded.pngRegular!.dataUri,
        pngShiny: loaded.pngShiny!.dataUri,
        gifRegular: loaded.gifRegular!.dataUri,
        gifShiny: loaded.gifShiny!.dataUri,
      },
    });
  }

  return (
    <div className="register">
      <div className="register__form">
        <section>
          <h2>1. Artwork</h2>
          <p className="muted">
            All four variants are required. Which one a Beast shows is decided by
            its token ID, so a species cannot ship a partial set.
          </p>
          <ArtUpload
            loaded={loaded}
            selected={preview}
            onSelect={setPreview}
            onChange={(slot, art) => setLoaded((l) => ({ ...l, [slot]: art }))}
            disabled={submitting}
          />
          {slots > 0 && (
            <p className="muted">
              About {slots.toLocaleString()} storage slots. There is no size cap —
              if you are willing to pay for it and the network accepts it, it is
              valid — but larger art means a more expensive registration.
            </p>
          )}
        </section>

        <section>
          <h2>2. Identity</h2>

          <label className="field">
            <span>Species name</span>
            <input
              value={name}
              maxLength={MAX_NAME_BYTES}
              placeholder="Gloomfang"
              disabled={submitting}
              onChange={(e) => setName(e.target.value)}
            />
            {name && !nameCheck.valid && <em className="field__error">{nameCheck.error}</em>}
            <em className="field__hint">
              Letters, numbers, spaces, apostrophes and hyphens. Up to {MAX_NAME_BYTES}{' '}
              bytes. Names are not unique — your species ID is your identity.
            </em>
          </label>

          <label className="field">
            <span>Type</span>
            <select
              value={beastType}
              disabled={submitting}
              onChange={(e) => setBeastType(Number(e.target.value) as BeastType)}
            >
              {Object.entries(BEAST_TYPE_NAMES).map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
          </label>

          <label className="field">
            <span>Tier</span>
            <select
              value={tier}
              disabled={submitting}
              onChange={(e) => setTier(Number(e.target.value))}
            >
              {[1, 2, 3, 4, 5].map((t) => (
                <option key={t} value={t}>
                  Tier {t} — power multiplier {6 - t}x
                </option>
              ))}
            </select>
            <em className="field__hint">
              Tier is self-declared and permanent. Games decide for themselves
              which species they accept.
            </em>
          </label>
        </section>

        <section>
          <h2>3. Who can mint it</h2>
          <p className="muted">
            Usually a Loot Survivor dungeon. Players earn your Beast by
            defeating it there — Beasts are not sold, they are captured.
          </p>

          <label className="radio">
            <input
              type="radio"
              checked={minterMode === 'later'}
              disabled={submitting}
              onChange={() => setMinterMode('later')}
            />
            <span>
              <strong>Decide later</strong>
              <em>
                Registers paused. Nobody can mint your species until you set a
                minter — you keep the Genesis Beast either way.
              </em>
            </span>
          </label>

          <label className="radio">
            <input
              type="radio"
              checked={minterMode === 'custom'}
              disabled={submitting}
              onChange={() => setMinterMode('custom')}
            />
            <span>
              <strong>Dungeon address</strong>
              <em>The contract allowed to mint your species.</em>
            </span>
          </label>

          {minterMode === 'custom' && (
            <label className="field">
              <input
                value={minter}
                placeholder="0x..."
                disabled={submitting}
                onChange={(e) => setMinter(e.target.value)}
              />
              {minter && !minterValid && (
                <em className="field__error">That does not look like an address</em>
              )}
            </label>
          )}
        </section>

        <section>
          <h2>4. Register</h2>
          <ul className="summary">
            <li>
              Your wallet receives the <strong>Genesis Beast</strong> — the
              creator's token, one per species, in the same transaction.
            </li>
            <li>
              Your species is capped at {MAX_SUPPLY_PER_SPECIES.toLocaleString()}{' '}
              Beasts forever.
            </li>
            <li>
              Name, type and tier can <strong>never</strong> change. Art and
              minter can, until you lock them.
            </li>
          </ul>

          {!address && <p className="field__error">Connect a wallet to register.</p>}
          {missingArt.length > 0 && (
            <p className="field__error">
              Still needed: {missingArt.map((s) => s.label).join(', ')}
            </p>
          )}
          {error && <p className="field__error">{error}</p>}

          <button className="primary" disabled={!ready || submitting} onClick={submit}>
            {submitting ? 'Registering…' : 'Register Beast'}
          </button>
        </section>
      </div>

      <aside className="register__preview">
        <CardPreview
          name={name}
          tier={tier}
          beastType={beastType}
          art={loaded[preview]?.dataUri}
          shiny={preview === 'pngShiny' || preview === 'gifShiny'}
          prefix={1}
          suffix={1}
          level={10}
          health={100}
        />
      </aside>
    </div>
  );
}
