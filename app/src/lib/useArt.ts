import { type Beast, type BeastsClient, encodeTokenId } from '@provable-games/beasts-sdk';
import { useEffect, useState } from 'react';

/**
 * Art is fetched per Beast, not per species.
 *
 * A community provider receives the whole decoded Beast, so it may legitimately
 * vary art by affix, tier or level — caching by species would show the wrong
 * picture for exactly the providers that make the interface worth having.
 * Keyed by token ID and shared across pages, so navigating back is free.
 */
const cache = new Map<string, string | null>();

/** Fetches art for a list of Beasts, filling in progressively. */
export function useArt(
  client: BeastsClient,
  beasts: Beast[],
): Map<string, string | null> {
  const [, setTick] = useState(0);
  const key = beasts.map((b) => encodeTokenId(b).toString()).join(',');

  useEffect(() => {
    let cancelled = false;

    async function load() {
      // Bounded batches: one request per Beast will out-run a public node's
      // per-second budget on any collection worth showing.
      const pending = beasts.filter((b) => !cache.has(encodeTokenId(b).toString()));
      for (let i = 0; i < pending.length && !cancelled; i += 4) {
        await Promise.all(
          pending.slice(i, i + 4).map(async (beast) => {
            const id = encodeTokenId(beast).toString();
            try {
              cache.set(id, await client.getArt(beast));
            } catch {
              // A provider that reverts costs its own thumbnail, nothing more.
              cache.set(id, null);
            }
          }),
        );
        if (!cancelled) setTick((t) => t + 1);
      }
    }

    void load();
    return () => {
      cancelled = true;
    };
    // `key` collapses the beast list to a stable identity.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [client, key]);

  return cache;
}

export function artFor(cache: Map<string, string | null>, beast: Beast): string | null | undefined {
  return cache.get(encodeTokenId(beast).toString());
}
