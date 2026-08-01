/**
 * Client-side mirrors of the contract's guards.
 *
 * These exist so the web app can reject bad input before it costs a
 * transaction — they are a convenience, never the security boundary. The
 * contract re-checks everything, and it is the only thing that decides what
 * is valid.
 */

// ---------------------------------------------------------------- names

/**
 * Species name charset, mirroring `assert_valid_name` in
 * `src/beast_registry.cairo`.
 *
 * This is an injection guard, not a style rule: the contract's JSON and SVG
 * builders embed names unescaped, so the charset is what keeps every token's
 * metadata well-formed. Uniqueness is deliberately NOT enforced — requiring
 * it would let anyone squat the good names. Species ID is the identity.
 */
const NAME_CHARSET = /^[A-Za-z0-9 '-]+$/;

/** Names are stored in a single felt252, which holds at most 31 bytes. */
export const MAX_NAME_BYTES = 31;

export interface ValidationResult {
  valid: boolean;
  error?: string;
}

export function validateSpeciesName(name: string): ValidationResult {
  if (name.length === 0) return { valid: false, error: 'Name cannot be empty' };
  if (new TextEncoder().encode(name).length > MAX_NAME_BYTES) {
    return { valid: false, error: `Name cannot exceed ${MAX_NAME_BYTES} bytes` };
  }
  if (!NAME_CHARSET.test(name)) {
    return {
      valid: false,
      error: "Name may only contain letters, numbers, spaces, apostrophes, and hyphens",
    };
  }
  if (name.startsWith(' ')) return { valid: false, error: 'Name cannot start with a space' };
  if (name.endsWith(' ')) return { valid: false, error: 'Name cannot end with a space' };
  return { valid: true };
}

// ------------------------------------------------------------------ art

/**
 * Media types the contract accepts from a community art provider at render
 * time (`src/art_validation.cairo`).
 */
export const ALLOWED_ART_PREFIXES = [
  'data:image/png;base64,',
  'data:image/gif;base64,',
  'data:image/webp;base64,',
  'data:image/svg+xml;base64,',
] as const;

/**
 * Base64-encoded magic bytes the *factory* provider additionally requires at
 * write time (`src/stored_art_provider.cairo`). A fixed leading signature
 * always encodes to a fixed character prefix, so this needs no decoding:
 *   PNG 89 50 4E 47 0D 0A 1A 0A + IHDR length -> "iVBORw0KGgo"
 *   GIF "GIF87a" -> "R0lGODdh", "GIF89a" -> "R0lGODlh"
 */
const PNG_MAGIC = 'iVBORw0KGgo';
const GIF_MAGICS = ['R0lGODdh', 'R0lGODlh'] as const;

const BASE64_BODY = /^[A-Za-z0-9+/]*={0,2}$/;

/**
 * Validates a data URI the way `token_uri` will when it renders: allowlisted
 * media type plus a structurally sound standard-base64 payload.
 *
 * Deliberately imposes no size cap. If an artist is willing to pay for the
 * storage and the network accepts the transaction, the art is valid.
 */
export function validateRenderableArt(uri: string): ValidationResult {
  const prefix = ALLOWED_ART_PREFIXES.find((p) => uri.startsWith(p));
  if (!prefix) {
    return {
      valid: false,
      error: 'Art must be a base64 data URI of type png, gif, webp, or svg+xml',
    };
  }

  const payload = uri.slice(prefix.length);
  if (payload.length === 0) return { valid: false, error: 'Art payload is empty' };
  if (payload.length % 4 !== 0) {
    return { valid: false, error: 'Art payload is not valid base64 (length must be a multiple of 4)' };
  }
  if (!BASE64_BODY.test(payload)) {
    return { valid: false, error: 'Art payload contains characters outside the base64 alphabet' };
  }
  return { valid: true };
}

/**
 * Validates art destined for the *factory* provider, which is stricter than
 * render-time: it must additionally carry real PNG or GIF magic bytes. This
 * is what earns factory art its "verified" designation — a locked factory
 * species is provably frozen and provably an inert image.
 */
export function validateFactoryArt(uri: string, kind: 'png' | 'gif'): ValidationResult {
  const expectedPrefix = kind === 'png' ? 'data:image/png;base64,' : 'data:image/gif;base64,';
  if (!uri.startsWith(expectedPrefix)) {
    return { valid: false, error: `Expected a ${kind.toUpperCase()} data URI` };
  }

  const structural = validateRenderableArt(uri);
  if (!structural.valid) return structural;

  const payload = uri.slice(expectedPrefix.length);
  if (kind === 'png') {
    if (!payload.startsWith(PNG_MAGIC)) {
      return { valid: false, error: 'File is not a valid PNG' };
    }
  } else if (!GIF_MAGICS.some((m) => payload.startsWith(m))) {
    return { valid: false, error: 'File is not a valid GIF (must be GIF87a or GIF89a)' };
  }
  return { valid: true };
}

/** Validates the complete four-variant set the factory path requires. */
export function validateArtSet(art: {
  pngRegular: string;
  pngShiny: string;
  gifRegular: string;
  gifShiny: string;
}): ValidationResult {
  const checks: Array<[string, ValidationResult]> = [
    ['Regular PNG', validateFactoryArt(art.pngRegular, 'png')],
    ['Shiny PNG', validateFactoryArt(art.pngShiny, 'png')],
    ['Regular GIF', validateFactoryArt(art.gifRegular, 'gif')],
    ['Shiny GIF', validateFactoryArt(art.gifShiny, 'gif')],
  ];
  for (const [label, result] of checks) {
    if (!result.valid) return { valid: false, error: `${label}: ${result.error}` };
  }
  return { valid: true };
}

// ----------------------------------------------------------------- tier

export function validateTier(tier: number): ValidationResult {
  if (!Number.isInteger(tier) || tier < 1 || tier > 5) {
    return { valid: false, error: 'Tier must be a whole number from 1 to 5' };
  }
  return { valid: true };
}
