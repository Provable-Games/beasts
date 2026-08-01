# Beasts V3 — Sepolia deployment

Deployed 2026-07-31 from branch `feat/nft-registry-integration` (PR #20,
stacked on #19). Tooling: **sncast 0.60.0** (`--network sepolia`). Not
starkli — it is unsupported and absent from this environment.

Deployer / owner / royalty receiver: sncast account `commit-reveal-sepolia`
`0x736faa0dca6a4569bf22471b574ddf42107f5af81d67e2cb9e1aa9bba7de76b`

Total cost: ~10 STRK.

## Deployed contracts

| Contract | Address |
|---|---|
| **beasts_nft** | `0x01dac77837c6751777d917051a6e405967c5c75f46df5ab7c635e52819634bfd` |
| **beast_registry** | `0x06d46c98087a1246182c6cd8ef144ee0a67da6e6cc9e44e39aef08cf92d30045` |
| beast_png_regular_data | `0x045f6cf8249ebee56f699a46cb66f02cbd23419f1c2cd3e62a3dfdedaf894279` |
| beast_png_shiny_data | `0x0291ad81a428262fd709f0075dedf69814173bf5b60f989cf7095f5efa72c670` |
| beast_gif_regular_data | `0x04a15db02fc7c991f2080e349cfbfb8f96f5fd61dd92c1cbe60ed7dbd4d49bfe` |
| beast_gif_shiny_data | `0x07bf05b8aa73d7fe6cc3bfb67efae46daa1260bd71634f08c43fd555cdf17631` |

## Declared class hashes

| Contract | Class hash |
|---|---|
| beasts_nft | `0x350e97a3244fecad9f850d84843a0effc26a364c392c2e8c4379cb5de0193ea` |
| beast_registry | `0x2afeefe9818b1c3fa839cef077cad5c6767bda41e6737e31ed44ed1a3fd6a97` |
| stored_art_provider | `0x2e3011cf968bbea8b72e75efdfe120318ccf61fe711d2f7f927114e2d8da56e` |
| beast_png_regular_data | `0x15d5742d2e7804531ac456b7ba82e9dc961ba154cbaaad631e2e7b4e887b68b` |
| beast_png_shiny_data | `0x3a1bfcae2737a12df248675d57c3a1a94eeceb5a696f14fa6f23fd99bf3d247` |
| beast_gif_regular_data | `0x1597fbb34f42f6b49fa2944943c74396ff7bdec4028743e02290b7c6714c900` |
| beast_gif_shiny_data | `0x44f9108354ce2a7699348ae13cb6c2dc595c8eff342c936bd9e0f3c79252939` |

`stored_art_provider` is declared but never deployed directly — the registry
deploys one instance per species with `salt = beast_id`.

## Wiring

Both pointers are write-once and both are required; a stack missing either
accepts no community species at all.

```
registry.set_nft_address(0x01dac778...)   tx 0x06a0634be77503b1e32507406b046d320098f2f17a0142cc56dba07639e22fd5
nft.set_registry_address(0x06d46c98...)   tx 0x02af8798debaea3fbd5949bafe2b506e048a8fed8cde08101e63149fa4236ded
```

`dungeon_address` is **unset (zero)**, so genesis species 1–75 cannot be
minted yet. That is deliberate: it is also the state mainnet must launch in
until the `burn_and_mint` migration completes, or a dungeon could claim an
`(id, prefix, suffix)` slot a V2 holder still needs.

## Verification performed

| Check | Result |
|---|---|
| Constructor genesis mint | `total_supply() == 75` |
| Genesis token ownership | `owner_of(0x7006400010000000000000000001)` → deployer |
| Genesis render (legacy art path) | `token_uri` → `"Warlock"`, new bestiary description |
| Permissionless registration | `register_beast_with_art('Gloomfang', Hunter, 3, ...)` → species **76** |
| Factory art provider auto-deploy | `0x4b11caad7b2b29949f957c0854d2fa3a37fc40519bfee2eb844d8f319ac19b9`, `factory_provider: true` |
| Provenance mint | `total_supply()` 75 → 76 |
| Per-species mint auth | `mint(..., 76, 1, 1, 10, 100, 0, 1)` from the registered minter succeeded |
| Community render | `"Agony Bane" Gloomfang`, Rank 1, 20,970-byte SVG |

Decoded attributes of the community mint — every value routed correctly:

```
Beast ID 76   Beast Gloomfang   Type Hunter   Tier 3    (from registry)
Prefix Agony  Suffix Bane                                (shared tables)
Level 10      Health 100        Power 30      Rank 1
Shiny 0       Animated 1        Genesis 0
Adventurers Killed 0  Last Killed By 0  Last Death Timestamp 0
```

`animated = 1` selected the GIF variant (`R0lGODdh...`) from the factory
provider, confirming variant routing. Power 30 = level 10 × (6 − tier 3).
Stats are zero because no `stats_source` is set — the cache is read, never a
live call.

## Not done here

- **Registering the original 75 into the registry** — dropped from scope.
  Species 1–75 resolve name/tier/type from `beast_definitions` and render
  through the legacy art contracts without any registry entry. See the
  design doc; a backfill remains possible later.
- `set_dungeon_address` — left zero, see above.
- `set_death_mountain_address` — zero; genesis stats read as 0.

## Reproducing

Declares must be run **one at a time with `--wait`**. Firing them
back-to-back produces `Invalid transaction nonce`, because sncast reads the
account nonce before the previous declare is accepted.
