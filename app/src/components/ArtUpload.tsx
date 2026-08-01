import { useState } from 'react';
import { ART_SLOTS, ArtLoadError, loadArtFile, type ArtSlot, type LoadedArt } from '../lib/art';

interface Props {
  loaded: Partial<Record<ArtSlot, LoadedArt>>;
  onChange: (slot: ArtSlot, art: LoadedArt | undefined) => void;
  onSelect: (slot: ArtSlot) => void;
  selected: ArtSlot;
  disabled?: boolean;
}

export function ArtUpload({ loaded, onChange, onSelect, selected, disabled }: Props) {
  const [errors, setErrors] = useState<Partial<Record<ArtSlot, string>>>({});

  async function handleFile(slot: ArtSlot, kind: 'png' | 'gif', file: File | undefined) {
    if (!file) return;
    setErrors((e) => ({ ...e, [slot]: undefined }));
    try {
      const art = await loadArtFile(file, kind);
      onChange(slot, art);
      onSelect(slot);
    } catch (error) {
      const message =
        error instanceof ArtLoadError ? error.message : 'Could not process that file';
      setErrors((e) => ({ ...e, [slot]: message }));
      onChange(slot, undefined);
    }
  }

  return (
    <div className="art-grid">
      {ART_SLOTS.map(({ slot, label, hint, kind, accept }) => {
        const art = loaded[slot];
        const error = errors[slot];
        return (
          <div
            key={slot}
            className={`art-slot ${selected === slot ? 'art-slot--selected' : ''} ${
              error ? 'art-slot--error' : ''
            }`}
            onClick={() => art && onSelect(slot)}
          >
            <div className="art-slot__header">
              <span className="art-slot__label">{label}</span>
              <span className="art-slot__kind">{kind.toUpperCase()}</span>
            </div>

            <label className="art-slot__drop">
              {art ? (
                <img src={art.dataUri} alt={label} />
              ) : (
                <span className="art-slot__placeholder">Choose {kind.toUpperCase()}</span>
              )}
              <input
                type="file"
                accept={accept}
                disabled={disabled}
                onChange={(e) => handleFile(slot, kind, e.target.files?.[0])}
              />
            </label>

            <p className="art-slot__hint">{hint}</p>
            {art && (
              <p className="art-slot__meta">
                {(art.bytes / 1024).toFixed(1)} KB · {art.slots.toLocaleString()} slots
              </p>
            )}
            {error && <p className="art-slot__error">{error}</p>}
          </div>
        );
      })}
    </div>
  );
}
