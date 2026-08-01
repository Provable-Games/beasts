# @provable-games/beasts-sdk

TypeScript SDK for the Beasts onchain bestiary.

```bash
pnpm add @provable-games/beasts-sdk starknet
```

## Everything static is offline

A Beast's token ID *is* the Beast. The 116-bit layout encodes species, affixes,
level, health, tier, type, and the shiny/animated flags, so the full static
profile is recoverable without touching a node:

```ts
import { decodeTokenId, beastPower, fullBeastName } from '@provable-games/beasts-sdk';

const beast = decodeTokenId('0x2e0064000a081000000000000004c');
// { id: 76n, prefix: 1, suffix: 1, level: 10, health: 100,
//   shiny: 0, animated: 1, tier: 3, beastType: 1 }

beastPower(beast); // 30  — level * (6 - tier)
```

Only two things need a chain read, and both cache per species: the **name** and
the **art** of community species. Genesis species (1–75) resolve entirely
offline:

```ts
import { genesisSpecies, fullBeastName, decodeTokenId } from '@provable-games/beasts-sdk';

genesisSpecies(1n);                                  // { name: 'Warlock', tier: 1, beastType: 0 }
fullBeastName(decodeTokenId(genesisWarlockTokenId)); // 'Warlock'
fullBeastName(communityBeast, 'Gloomfang');          // '"Agony Bane" Gloomfang'
```

## Genesis Beasts are derived, not flagged

There is no genesis bit. The `(id, 0, 0)` affix slot is reserved as each
species' Genesis Beast — the artist's provenance token — so `isGenesis` is just
`prefix === 0 && suffix === 0`. Every other mint requires both affixes, which is
what caps a species at exactly 1,243.

## Validation mirrors the contract

`validateSpeciesName`, `validateRenderableArt`, `validateFactoryArt` and
`validateArtSet` reproduce the contract's guards so a UI can fail fast instead
of failing a transaction. They are a convenience, never the security boundary —
the contract re-checks everything and is the only thing that decides what is
valid.

The name charset is an injection guard, not a style rule: the contract's JSON
and SVG builders embed names unescaped. Names are deliberately **not** unique —
requiring uniqueness would let anyone squat the good ones.

## Finding what a wallet controls

```ts
await client.getSpeciesByArtist(address); // [77n, 78n]
await client.getOwnedSpecies(address);    // + definition and Genesis token ID
```

Derived from `BeastRegistered` and `ArtistTransferred` events rather than by
scanning IDs: the registry keeps no artist index and `species_count` grows
without bound, so a scan would cost one call per species forever.

**"Controls" means the artist role, not the Genesis Beast.** The two start
together but diverge the moment either is transferred, and the registry's
permissioned entrypoints check the role.

`BeastsAddresses.fromBlock` anchors those event scans. It is not just an
optimisation: public RPC nodes cap how far back `starknet_getEvents` will
look, and at least one returns an **empty result rather than an error** for a
range it will not serve — so a scan from genesis reports "this wallet owns
nothing" instead of failing. If you point the SDK at your own deployment, set
`fromBlock` with it.

## Reads and calls

`BeastsClient` returns `Call` objects rather than sending them, so the caller
decides how to sign — a wallet popup, a session, or a multicall batching several
changes into one transaction.

```ts
import { BeastsClient, BeastType, SEPOLIA_ADDRESSES } from '@provable-games/beasts-sdk';
import { RpcProvider } from 'starknet';

const client = new BeastsClient(new RpcProvider({ nodeUrl }), SEPOLIA_ADDRESSES, account);

await client.execute(
  client.registerWithArtCall({
    name: 'Gloomfang',
    beastType: BeastType.Hunter,
    tier: 3,
    minter: dungeonAddress, // '0x0' registers paused
    art: { pngRegular, pngShiny, gifRegular, gifShiny },
  }),
);
```

## Tests

```bash
pnpm test        # unit tests, no network
pnpm test:live   # additionally reads the Sepolia deployment
```

The unit tests are anchored on two token IDs produced by the deployed contract,
not by this SDK, so a layout drift between Cairo and TypeScript fails the suite.
The live tests prove the client's calldata and ABI decoding match the deployed
contracts — something fixtures cannot.

`src/tables.ts` is generated from `src/beast_definitions.cairo`; regenerate with
`node scripts/gen-tables.mjs` from the repo root rather than editing it.
