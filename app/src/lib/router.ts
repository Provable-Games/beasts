import { useCallback, useEffect, useState } from 'react';

/**
 * Hash routing, hand-rolled.
 *
 * A hash keeps every page a real, shareable URL without needing server
 * rewrites — this app is a static bundle. The address lives in the path
 * rather than in component state precisely so `#/collection/0xabc…` can be
 * edited to any wallet and shared as-is.
 */
export type Route =
  | { name: 'register' }
  | { name: 'collection'; address: string }
  | { name: 'species-index' }
  | { name: 'species'; beastId: bigint }
  | { name: 'manage' }
  | { name: 'manage-species'; beastId: bigint };

export function parseRoute(hash: string): Route {
  const path = hash.replace(/^#\/?/, '').split('?')[0];
  const [head, tail] = path.split('/');

  switch (head) {
    case 'collection':
      return tail ? { name: 'collection', address: tail } : { name: 'register' };
    case 'beasts':
      if (!tail) return { name: 'species-index' };
      return isDigits(tail) ? { name: 'species', beastId: BigInt(tail) } : { name: 'species-index' };
    case 'manage':
      if (!tail) return { name: 'manage' };
      return isDigits(tail) ? { name: 'manage-species', beastId: BigInt(tail) } : { name: 'manage' };
    default:
      return { name: 'register' };
  }
}

export function href(route: Route): string {
  switch (route.name) {
    case 'collection':
      return `#/collection/${route.address}`;
    case 'species-index':
      return '#/beasts';
    case 'species':
      return `#/beasts/${route.beastId}`;
    case 'manage':
      return '#/manage';
    case 'manage-species':
      return `#/manage/${route.beastId}`;
    default:
      return '#/';
  }
}

export function useRoute(): [Route, (route: Route) => void] {
  const [hash, setHash] = useState(() => window.location.hash);

  useEffect(() => {
    const onChange = () => setHash(window.location.hash);
    window.addEventListener('hashchange', onChange);
    return () => window.removeEventListener('hashchange', onChange);
  }, []);

  const navigate = useCallback((route: Route) => {
    window.location.hash = href(route);
  }, []);

  return [parseRoute(hash), navigate];
}

function isDigits(value: string | undefined): value is string {
  return !!value && /^\d+$/.test(value);
}
