import { validateFactoryArt, type ValidationResult } from '@provable-games/beasts-sdk';

export type ArtSlot = 'pngRegular' | 'pngShiny' | 'gifRegular' | 'gifShiny';

export interface ArtSlotSpec {
  slot: ArtSlot;
  label: string;
  hint: string;
  kind: 'png' | 'gif';
  accept: string;
}

/**
 * The four variants a factory-provider species stores. Which one a token
 * renders is decided by the shiny and animated bits in its token ID, so all
 * four are required — a species cannot ship a partial set.
 */
export const ART_SLOTS: readonly ArtSlotSpec[] = [
  {
    slot: 'pngRegular',
    label: 'Standard',
    hint: 'The default look. Shown when a Beast is neither shiny nor animated.',
    kind: 'png',
    accept: 'image/png',
  },
  {
    slot: 'pngShiny',
    label: 'Shiny',
    hint: 'The rare colourway. Static.',
    kind: 'png',
    accept: 'image/png',
  },
  {
    slot: 'gifRegular',
    label: 'Animated',
    hint: 'The default look, in motion.',
    kind: 'gif',
    accept: 'image/gif',
  },
  {
    slot: 'gifShiny',
    label: 'Animated + Shiny',
    hint: 'The rarest combination. Both bits set.',
    kind: 'gif',
    accept: 'image/gif',
  },
];

export interface LoadedArt {
  dataUri: string;
  bytes: number;
  /** On-chain storage cost: art is stored 31 bytes per felt slot. */
  slots: number;
}

export class ArtLoadError extends Error {}

/**
 * Reads a file into a base64 data URI and checks it against the same rules
 * the factory provider enforces on write.
 *
 * The browser's own decode is the real format check — magic bytes only prove
 * the header, and a file that cannot be decoded here would render as a broken
 * image for every holder of the species.
 */
export async function loadArtFile(file: File, kind: 'png' | 'gif'): Promise<LoadedArt> {
  const dataUri = await readAsDataUri(file);

  const validation: ValidationResult = validateFactoryArt(dataUri, kind);
  if (!validation.valid) throw new ArtLoadError(validation.error ?? 'Invalid art');

  await assertDecodable(dataUri);

  const bytes = dataUri.length;
  return { dataUri, bytes, slots: Math.ceil(bytes / 31) };
}

function readAsDataUri(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onerror = () => reject(new ArtLoadError('Could not read that file'));
    reader.onload = () => {
      const result = reader.result;
      if (typeof result !== 'string') {
        reject(new ArtLoadError('Could not read that file'));
        return;
      }
      resolve(result);
    };
    reader.readAsDataURL(file);
  });
}

function assertDecodable(dataUri: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve();
    image.onerror = () => reject(new ArtLoadError('That file is not a valid image'));
    image.src = dataUri;
  });
}

/**
 * Rough cost signal for the registration transaction. Advisory only — the
 * contract imposes no size cap, and the network decides what it will accept.
 */
export function totalStorageSlots(loaded: Partial<Record<ArtSlot, LoadedArt>>): number {
  return ART_SLOTS.reduce((sum, { slot }) => sum + (loaded[slot]?.slots ?? 0), 0);
}
