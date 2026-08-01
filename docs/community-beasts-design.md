# Community Beasts: Permissionless Species Registration

Status: DRAFT v3 — post design review (2026-07-23). All open decisions resolved.

## Goal

Anyone can add a new Beast species to the collection with a single transaction:
pixel art (4 variants), name, type, tier, and a minter (dungeon) address. The
Beasts become an **infinitely expandable, fully onchain bestiary**. The end
state is a self-service web app where pixel artists register Beasts that live
fully on-chain and are mintable through Loot Survivor dungeons.

## Decision log

| # | Decision | Resolution |
|---|----------|-----------|
| 1 | Species ID width | `u64` — collection can never be filled or squatted out |
| 2 | Token ID encoding | all static data in a deterministic **116-bit** token ID; zero per-beast storage |
| 3 | Art model | per-species `IBeastArtProvider` address; factory auto-deploys canonical `StoredArtProvider`; custom providers allowed |
| 4 | Provenance | artist receives the species' Genesis Beast at registration |
| 20 | Artist role | **the Genesis Beast IS the artist role.** No stored `artists` map: every permissioned entrypoint resolves the artist as `owner_of(genesis_token_id(beast_id))`, so control transfers with the token on any marketplace and the two can never drift apart |
| 5 | Art locking | one-way `lock_art` |
| 6 | Minter locking | one-way `lock_minter` |
| 7 | Registration fee | **none** — no fee mechanism at all (no shared resource to protect once name uniqueness was dropped) |
| 8 | Name rules | on-chain charset `[A-Za-z0-9 ' -]`, no edge spaces, non-empty; **no uniqueness** (uniqueness would enable name-squatting griefs; identity = species ID; impersonation is a UI/curation concern) |
| 9 | Kill stats | **opt-in per species**, cached-on-refresh — never a live external call in `token_uri` |
| 10 | ERC721Votes | **removed entirely** (with NoncesComponent); permissionless supply makes token-votes Sybil-inflatable |
| 11 | Non-genesis affixes | `prefix >= 1 && suffix >= 1` enforced — makes max supply exactly 1,243/species and the genesis bit derivable (bit dropped) |
| 12 | terminal_timestamp | **removed entirely** from this version (constructor, token_uri gate, getter, deploy script) |
| 13 | Description | new generalized "infinitely expandable onchain bestiary" copy; 1337 Skulls art credit retained for species 1–75 only |
| 14 | Genesis trait | kept, shared by all species — the Genesis Beast is the Artist/Creator token |
| 15 | Art size caps | none on-chain — if the artist pays and the network accepts, it's valid |
| 16 | Death Mountain | not backwards compatible; DM gets a new interface version with `u64` entity IDs |
| 17 | Downstream consumers | games (Summit, tournaments, …) MUST allowlist species; self-declared tier makes unfiltered acceptance exploitable |
| 18 | Migration | holders move 1:1 into the new collection. Mainnet target is a player-initiated **`burn_and_mint`**: burn the V2 Beast, mint the V3 equivalent. Deferred — not built yet, and nothing in the design may foreclose it (see Migration) |
| 19 | Registry backfill of 1–75 | **deferred**, not required. Species 1–75 resolve from the baked-in `beast_definitions` tables; the registry is community-only (`FIRST_COMMUNITY_ID = 76`). Backfill stays possible later because no read path asserts a lower bound on registry keys |

## Architecture

```
pixel artist ──(web app, 1 tx)──▶ BeastRegistry ──deploys──▶ StoredArtProvider (factory path)
                                     │    │                       or
                                     │    └───points to────▶ custom IBeastArtProvider
                                     │
                        reads + provenance-mint hook
                                     │
                                  beasts_nft ◀──mint(beast_id, ...)── per-species dungeon
                                     ▲
                                     └──(opt-in, cached)── per-species stats source
```

- **`BeastRegistry`** (new contract) — the only permissionless surface. Holds
  species definitions, assigns IDs, deploys factory art providers, triggers the
  provenance mint, and manages per-species admin (artist role).
- **`beasts_nft`** (existing) — stays the closed mint/ownership/metadata core.
  Reads the registry for minter auth and species data; exposes registry-only
  entrypoints for provenance mints and metadata-refresh fan-out.
- **`StoredArtProvider`** (new, declared class) — canonical art provider the
  factory deploys per species. Serves 4 stored data URIs, selected by the
  beast's `shiny`/`animated` flags.

Separate registry contract (not a component in `beasts_nft`) because the NFT
contract is near Sierra size limits, the registry will iterate faster, and the
web app then needs approval against exactly one contract.

## Token ID format — 116 bits

`felt252` gives 251 bits; we use 116 (fits `u128` — token IDs stay a two-word
value for indexers/DBs; JS clients use `BigInt`). Everything **static** about a
token is encoded in its ID, so clients and contracts never need a storage read
for it. Layout (low bits first):

| Bits    | Width | Field    | Notes                                          |
|---------|-------|----------|------------------------------------------------|
| 0–63    | 64    | id       | `u64` species ID. 1–75 genesis species, 76+ community |
| 64–70   | 7     | prefix   | 0 (genesis token only) or 1–69                 |
| 71–75   | 5     | suffix   | 0 (genesis token only) or 1–18                 |
| 76–91   | 16    | level    | unchanged                                      |
| 92–107  | 16    | health   | unchanged                                      |
| 108     | 1     | shiny    | unchanged                                      |
| 109     | 1     | animated | unchanged                                      |
| 110–112 | 3     | tier     | 1–5, static per species                        |
| 113–115 | 3     | type     | 0=Magic, 1=Hunter, 2=Brute (room for future)   |

**Genesis is derived, not stored**: `genesis == (prefix == 0 && suffix == 0)`.
Mint validation enforces both-zero (registry provenance path only) or both ≥ 1
(dungeon path) — mixed zero is invalid, so the equivalence is exact and the
former genesis bit is unnecessary.

`decode_token_id` validation: trailing `packed == 0` assert plus range checks —
`id != 0`, tier 1–5, type ≤ 2, prefix ≤ 69, suffix ≤ 18, **and** (prefix == 0)
== (suffix == 0). Legacy 53-bit IDs decode with tier 0 and are rejected.

Why encode tier/type:

- `get_beast_power` (`level * (6 - tier)`) becomes a pure function of the token
  ID — no registry read, no hardcoded table. Dungeons and clients compute power
  offline.
- `token_uri` needs no registry round-trip for tier/type.
- Integrity: tier/type are resolved **by the contract at mint time** (genesis
  tables for 1–75, registry otherwise) when encoding the ID. Minters cannot
  supply them. After an ERC721 existence check, decoded fields are trustworthy
  because only the contract ever encodes IDs.

`PackableBeast` gains `tier: u8`, `beast_type: u8` and `id` widens to `u64`.

Rejected encoding candidates: name (needs felt252 width; cacheable per
species), artist/provider addresses (dynamic, 252 bits), registration
timestamp (in the `BeastRegistered` event).

**Max supply per species: 1,243** — uniqueness is `(id, prefix, suffix)` with
prefix 1–69 × suffix 1–18 = 1,242 named beasts + 1 genesis. Canonical hash:
`poseidon(id, prefix, suffix)` with `id` as `u64` (same shape as today's
`pack::get_hash`, widened).

## BeastRegistry

```cairo
#[derive(Drop, Copy, Serde, starknet::Store)]
pub enum BeastType { Magic, Hunter, Brute }

#[derive(Drop, Serde)]
pub struct BeastDefinition {
    pub name: felt252,              // charset-validated short string
    pub beast_type: BeastType,
    pub tier: u8,                   // 1..=5
    pub minter: ContractAddress,    // dungeon allowed to mint this species
    pub artist: ContractAddress,    // derived: holder of the Genesis Beast
    pub art_provider: ContractAddress,
    pub stats_source: ContractAddress, // 0 = no kill stats (default)
    pub factory_provider: bool,
    pub art_locked: bool,
    pub minter_locked: bool,
}
// Stored manually packed: name | minter | art_provider = 3 slots,
// meta (tier 3b | type 3b | factory 1b | art_locked 1b | minter_locked 1b) = 1 slot.
// stats_source gets a slot only when set (zero-default maps cost nothing unwritten).

#[starknet::interface]
pub trait IBeastRegistry<T> {
    // -------- permissionless registration --------

    /// Simple path: registry deploys the canonical StoredArtProvider with the
    /// supplied art. One transaction, no contract knowledge needed.
    fn register_beast_with_art(
        ref self: T,
        name: felt252,
        beast_type: BeastType,
        tier: u8,
        minter: ContractAddress,
        png_regular: ByteArray,     // data:image/png;base64,...
        png_shiny: ByteArray,
        gif_regular: ByteArray,     // data:image/gif;base64,...
        gif_shiny: ByteArray,
    ) -> u64;

    /// Advanced path: artist supplies their own IBeastArtProvider (non-zero).
    fn register_beast(
        ref self: T,
        name: felt252,
        beast_type: BeastType,
        tier: u8,
        minter: ContractAddress,
        art_provider: ContractAddress,
    ) -> u64;

    // -------- per-species admin (artist only) --------
    fn set_minter(ref self: T, beast_id: u64, minter: ContractAddress); // until lock_minter
    fn lock_minter(ref self: T, beast_id: u64);                         // one-way
    fn update_art(ref self: T, beast_id: u64,
        png_regular: ByteArray, png_shiny: ByteArray,
        gif_regular: ByteArray, gif_shiny: ByteArray); // factory providers only
    fn set_art_provider(ref self: T, beast_id: u64, provider: ContractAddress);
    fn notify_art_updated(ref self: T, beast_id: u64);  // custom providers: trigger refresh
    fn lock_art(ref self: T, beast_id: u64);            // one-way
    fn set_stats_source(ref self: T, beast_id: u64, source: ContractAddress);

    // -------- reads --------
    fn get_definition(self: @T, beast_id: u64) -> BeastDefinition;
    fn get_minter(self: @T, beast_id: u64) -> ContractAddress;
    fn get_art_provider(self: @T, beast_id: u64) -> ContractAddress;
    fn get_stats_source(self: @T, beast_id: u64) -> ContractAddress;
    fn is_art_locked(self: @T, beast_id: u64) -> bool;
    fn is_minter_locked(self: @T, beast_id: u64) -> bool;
    fn species_count(self: @T) -> u64;

    // -------- owner levers --------
    fn set_stored_art_class_hash(ref self: T, class_hash: ClassHash);
    fn set_nft_address(ref self: T, nft: ContractAddress); // one-time, reverts if already set
}
```

### Registration semantics

- IDs assigned sequentially starting at **76**. Valid species: `1..=75`
  (genesis tables) or `76..next_id` (registry).
- **Type and tier immutable after registration** — baked into every token ID
  of the species; feed combat math. Restricted to the existing 3 types /
  5 tiers so community beasts slot into Loot Survivor combat unchanged.
- **Name validation (on-chain, mandatory)**: bytes restricted to
  `[A-Za-z0-9]`, space, apostrophe, hyphen; non-empty; ≤31 bytes; no leading
  or trailing space. This is an **injection guard**, not a style rule —
  `components_to_json` and the SVG builder embed the name unescaped, so the
  charset is what keeps every token's metadata well-formed. **No uniqueness
  check**: duplicate names (including genesis names) are allowed; species ID
  is the identity, and impersonation is handled by UI/indexer curation.
- `minter` **may be zero** at registration = "register now, wire the dungeon
  later" (minting paused until set).
- Ordering: registry writes the full definition FIRST, then calls
  `beasts_nft.mint_provenance(artist, beast_id)` — the NFT reads tier/type
  back from the registry to encode the provenance token ID.
- Registry reverts all registration/admin calls until `set_nft_address` has
  been called (deploy-window guard).
- Emits `BeastRegistered { beast_id, name, artist, minter, tier, beast_type,
  art_provider }`.
- No fee. Registration cost = gas + storage, borne by the artist. Spam
  registrations harm no shared resource; curation is UI-level.

### Factory path

`register_beast_with_art` uses `deploy_syscall` on the canonical
`StoredArtProvider` class hash with `salt = beast_id` (deterministic address)
and constructor calldata `(registry, beast_id, art x4)`. The registry records
the deployed address as the species' **canonical factory provider** (stored or
recomputed deterministically).

`set_art_provider` recomputes `factory_provider = (provider == the species'
canonical factory address)` on every call — the flag can never be true while
pointing at another species' provider.

The class hash is owner-updatable so improved provider versions can ship;
existing deployments are unaffected.

No art size caps: if the artist pays for the storage and the network accepts
the transaction, the art is valid. (Practical bound = network calldata/step
limits. RPC consumers of `token_uri` must tolerate large responses.)

## IBeastArtProvider — full beast, variant-aware

Replaces `IBeastImageDataProvider.get_data_uri(beast_id: u8)`:

```cairo
#[starknet::interface]
pub trait IBeastArtProvider<TContractState> {
    fn get_data_uri(self: @TContractState, beast: PackableBeast) -> ByteArray;
}
```

- `shiny`/`animated` are in the struct, so **the provider selects the
  variant** — the four-way selection currently in `token_uri`
  (`src/lib.cairo:614-625`) collapses into the provider for community beasts.
- Custom providers can render by `prefix`/`suffix` (special art for
  "Ghoul Bane" beasts), tier, level bands — anything in the ID.

Resolution in `beasts_nft.token_uri`:

1. `id <= 75` → legacy path, unchanged: pick among the 4 deployed data
   contracts by flags (checked `u64 → u8` conversion). **Genesis art data
   contracts are not redeployed.**
2. `id >= 76` → `registry.get_art_provider(beast_id)`, dispatch
   `get_data_uri(beast)`. The returned ByteArray is passed pre-fetched into
   the metadata/SVG builders (which currently take a dispatcher + `u8` id —
   they change to accept the data URI directly).

Blast radius of a reverting **custom** provider: `token_uri` reverts for that
species only, and only the artist's own pointer choice causes it. Factory
providers are canonical-class and cannot revert. The web app badges
"verified art" only for canonical-class providers.

**Render-time output validation (PR 4)**: `token_uri` validates whatever a
custom provider returns before embedding it — an exact
`data:image/{png,gif,svg+xml,webp};base64,` prefix plus base64-charset body
(same validator family as the factory provider, with a wider mime allowlist
to preserve dynamic-art optionality). A misbehaving custom provider can
therefore revert its own species' rendering (accepted: self-inflicted and
contained) but can never inject markup into the SVG or JSON. Factory
providers guarantee inertness at write time; custom providers get it
enforced at read time.

## StoredArtProvider (canonical class)

- Storage: 4 `ByteArray` data URIs + `registry` + `beast_id`.
- `get_data_uri(beast)`: asserts `beast.id == stored beast_id`, then selects
  by `beast.shiny` / `beast.animated` — same truth table as today.
- `set_art(beast_id, ...)`: caller must be the registry AND `beast_id` must
  match storage (defense against any registry-side routing bug). No other
  mutators. Not upgradable.

## Art updates and locking

- `update_art` (factory path): registry checks artist + `!art_locked` +
  per-species refresh cooldown, calls `provider.set_art`, then
  `beasts_nft.emit_species_metadata_update(beast_id)` (registry-only), which
  fans out `MetadataUpdate` events reusing the existing 650-cap + bookmark
  machinery.
- `notify_art_updated` (custom path): same fan-out, artist-gated, **same
  shared per-species cooldown** (one timestamp governs both mutators, so
  neither bypasses the indexer rate limit).
- Fan-out fix (applies to the existing machinery too): the species' Genesis
  token `(id, 0, 0)` is not in `beast_species_lists` (rank 0) — the fan-out
  must **explicitly emit for the genesis token ID first**, then walk the
  ranked list. Bookmark writes use `min(existing_nonzero, new)` so an
  interleaved deep-insert mint can never silently drop a pending refresh
  range.
- `lock_art` is one-way and blocks `update_art` and `set_art_provider`.
  Honesty note: for **custom** providers the lock freezes the *pointer*, not
  the provider's internal behavior (it may be upgradable). Only
  factory-provider + locked = provably frozen art; the web app badges
  accordingly.
- Because of that asymmetry, `lock_art` gates `notify_art_updated` **only for
  factory providers**, where a locked provider genuinely cannot produce new
  art. A locked *custom* species keeps its refresh path: its provider can
  still change what it returns, so blocking notification would strand
  ERC-4906 consumers on permanently stale metadata. The cooldown still
  applies.

## Kill stats — opt-in, cached, never live in token_uri

Design constraint discovered in review: Starknet contracts cannot catch a
failed external call, so any live read from an artist-controlled address
inside `token_uri` lets a bad (or rotated) minter brick rendering for the
species. Therefore:

- **Default: no stats.** `stats_source = 0` → community tokens render
  kill-stat traits as zeros. Nothing external is called.
- **Opt-in**: artist calls `set_stats_source(beast_id, source)`. The source
  must implement the new `IBeastStats` interface (u64 entity IDs; SRC5
  interface check performed once, at set time).
- **Cached, not live**: a permissionless
  `beasts_nft.refresh_stats(token_id)` reads from the species'
  `stats_source`, writes the values into one packed slot per token
  (`adventurers_killed u64 | last_killed_by u64 | last_killed_timestamp u64`
  = 192 bits), emits `MetadataUpdate`, and rate-limits via the existing
  `last_manual_metadata_refresh` pattern. `token_uri` reads **only the
  cache**. A reverting stats source breaks refresh transactions, never
  rendering.
- Genesis species 1–75 keep the current live path against the global Death
  Mountain dispatcher (trusted, owner-set) — unchanged behavior. Optional
  future work: migrate genesis to the cached model too and remove all
  external calls from `token_uri` except art.

### Death Mountain / dungeon interface

Not backwards compatible, by decision. The existing
`IBeastSystems.add_collectable(entity_id: u8, ...)` cannot address species
≥ 76. Death Mountain gets a new interface version with `entity_id: u64`, and
the canonical entity hash everywhere is `poseidon(id: u64, prefix, suffix)` —
matching the widened `pack::get_hash`. No silent `u64 → u8` truncation
anywhere; legacy conversions are checked.

## The artist role is the Genesis Beast

There is no `artists` map. Every permissioned entrypoint resolves the artist
by asking the NFT who holds the species' Genesis Beast:

```cairo
fn artist_of(self: @ContractState, beast_id: u64) -> ContractAddress {
    IERC721Dispatcher { contract_address: self.nft.read() }
        .owner_of(Self::genesis_token_id(self, beast_id))
}
```

`genesis_token_id` is derived, not stored: it is `encode_token_id` over the
canonical `(id, 0, 0)` shape with the species' registered tier and type, so
the registry and any client compute the same value offline.

Why this over a stored role:

- **The creator token means what it says.** Selling it on any marketplace
  hands over the species; there is no second, invisible role that stays
  behind.
- **They cannot drift.** A stored role plus a transferable token is two
  sources of truth, and every UI then has to explain which one governs.
- **Enumeration answers everything.** `token_of_owner_by_index` plus a local
  `decode_token_id` tells a client which species a wallet controls, with no
  registry reads and no event scanning.
- **Less state and less surface**: one storage slot per species saved, and
  `transfer_artist_role` deleted entirely.

Costs, accepted deliberately:

- Each permissioned write now makes one `owner_of` call to the NFT. The NFT
  is owner-set and write-once, so this is not an untrusted call.
- Sending a Genesis Beast to an address nobody controls would freeze that
  species' admin permanently. Burning cannot cause this — the enumeration
  component rejects burns outright — but a mis-sent transfer can. This is the
  same risk profile as any NFT and the UI warns before transfer.

## Provenance mint (community Genesis Beasts)

At registration, `beasts_nft.mint_provenance(artist, beast_id)` mints the
species' Genesis Beast to the artist:

- Attributes: `prefix=0, suffix=0, level=1, health=100, shiny=1, animated=1`
  — same convention as the original 75. This is the **Artist/Creator token**.
- Uses plain `erc721.mint` (NOT `safe_mint` — no `onERC721Received` callback,
  so a contract-artist cannot reenter the registry mid-registration).
- Rank 0 (excluded from ranking, like genesis today).
- Recorded in `minted` under hash `(beast_id, 0, 0)`.
- The `Genesis` metadata trait is shared by all species — every species has
  exactly one Genesis Beast.

**Invariant: `(id, 0, 0)` is reserved for the Genesis Beast of every species**,
and regular mints require `prefix >= 1 && suffix >= 1` (tightened from
today's independent 0-allowed validation in `validate_beast_attributes`) —
mixed-zero combos are invalid everywhere, making supply exactly 1,243 and
genesis derivable from the ID. (Genesis-in-`minted` follows the direction of
the `owner-enumeration-packed-ids` branch.)

## beasts_nft changes

- **Removed components**: `VotesComponent` and `NoncesComponent` (and the
  `before_update` voting-unit hook). Permissionless supply makes token-votes
  trivially Sybil-inflatable; nothing may ever gate on them, so they go.
  Transfers and mints get cheaper (no checkpoint writes ever).
- **Removed**: all `terminal_timestamp` logic — constructor param, the
  `token_uri` gate, `get_terminal_time`, and the `TERMINAL_TIMESTAMP` deploy
  env var.
- **Mint auth per species** (replaces the single check at `src/lib.cairo:280`):

  ```cairo
  let authorized = if beast_id <= 75 {
      self.dungeon_address.read()              // genesis behavior unchanged
  } else {
      self.registry.read().get_minter(beast_id)
  };
  assert(authorized.is_non_zero() && caller == authorized, 'Not authorized to mint');
  ```

  Zero minter (unregistered id, or artist-paused species) rejects for free.
- **Token ID encoding at mint**: contract resolves tier/type (genesis tables
  for 1–75, registry otherwise) and encodes. Minters never supply tier/type.
  Mint validation: `prefix >= 1 && suffix >= 1`.
- **New registry-only entrypoints**: `mint_provenance`,
  `emit_species_metadata_update`. Registry address set once at deploy.
- **New permissionless entrypoint**: `refresh_stats(token_id)` (see Kill
  stats).
- `get_beast_power` / `get_beast_attributes` read tier/type from the decoded
  beast instead of `beast_definitions` tables.
- `get_beast_name`: genesis-table for 1–75; registry read for registered
  community ids; **reverts for unregistered ids** (mirrors the "decode only
  after existence check" repo rule).
- **Description** (in `metadata_generator.cairo`): replace the hardcoded
  "1,243 variants across 75 species / fixed supply of 93,225" copy with
  generalized text for the infinitely expandable bestiary (final copy TBD —
  marketing pass). The 1337 Skulls art credit line renders only for species
  1–75. Per-species supply (1,243) can be stated per species, not globally.
- Type widening `u8 → u64` for `beast_id` in: `MintRequest`, `get_beast_hash`,
  `beast_species_lists` / `beast_counts` / bookmark maps, events,
  `metadata_generator` / `beast_svg` call signatures (which also switch from
  dispatcher + id to a pre-fetched art ByteArray).
- `beast_definitions.cairo` keeps: genesis name/tier/type tables (encode-time
  for 1–75 + `get_beast_name`), prefix/suffix tables (shared by all species).

## Downstream consumer guidance (Summit, tournaments, markets)

Tier is self-declared by registrants. Any system that grants value to Beasts
**must filter by species** — accept genesis-only, or maintain an allowlist.
The registry exposes everything needed for cheap filtering:
`get_definition(id)` (artist, minter, locks) and `id <= 75` for genesis-only.
This is a documented, deliberate consequence of a permissionless contract
layer; curation lives in UIs and consuming games, never in the registry.

## Storage footprint

Slot = one felt252 storage slot. `ByteArray` storage ≈ `1 + ⌈bytes/31⌉` slots.
Reference art sizes measured from the genesis data contracts (data URI
included): regular PNG ~485 B → 17, shiny PNG ~552 B → 19, regular GIF
~635 B → 22, shiny GIF ~1,617 B → 54 ⇒ **~112 slots** for a genesis-quality
art set.

### Registering a Beast — factory path (`register_beast_with_art`)

| Where | What | Slots |
|---|---|---|
| Registry | `name` | 1 |
| Registry | `minter` | 1 |
| Registry | `art_provider` | 1 |
| Registry | packed meta (tier, type, factory, art_locked, minter_locked) | 1 |
| Registry | `next_id` | (update, existing slot) |
| StoredArtProvider | `registry` + `beast_id` | 2 |
| StoredArtProvider | 4 art ByteArrays | `Σ(1 + ⌈bytes/31⌉)` ≈ **112** at genesis-avg sizes |
| NFT (provenance mint) | `minted[(id,0,0)]` | 1 |
| NFT | ERC721 `owners[token_id]` | 1 |
| NFT | ERC721 `balances[artist]` | 1 |
| NFT | enumeration `owned_tokens` + index | 2 |

**Total: 12 fixed slots + art ≈ 124 at genesis-average art (~90% art).**
`stats_source` costs 1 slot only if the artist opts in later. Custom-provider
path: **10 fixed slots** (registry 5 + provenance mint 5); art lives on the
artist's own contract at their cost. No Votes checkpoints exist anymore in
any path.

### Minting a Beast (dungeon path)

| What | Slots |
|---|---|
| `minted[hash]` | 1 new |
| ERC721 `owners[token_id]` | 1 new |
| ERC721 `balances[to]` | 1 write |
| ranking `beast_species_lists[id][rank]` | 1 new |
| ranking `beast_token_ranks[token_id]` | 1 new |
| ranking `beast_counts[id]` | 1 update |
| enumeration `owned_tokens` + index | 2 new |
| metadata bookmark | 0–1 update (only when species > 650 and deep insert) |
| registry `get_minter` read | 0 (read-only) |

**Total: ~8 slot writes (6 new, 2 updates)**, plus 2 updates per displaced
entry when the new beast out-ranks existing ones. **The beast data itself
costs 0 slots** — everything static rides in the token ID. `refresh_stats`
(opt-in) adds 1 packed slot per refreshed token.

## Artist controls and limitations

### Fixed forever at registration

| Property | Why immutable |
|---|---|
| Species ID | sequential; identity of every token ID |
| Name | embedded in metadata identity (duplicates allowed, so no reason to mutate) |
| Type (Magic/Hunter/Brute) | encoded in every token ID; feeds combat |
| Tier (1–5) | encoded in every token ID; power = level × (6 − tier) |
| Provenance mint | Genesis Beast `(id,0,0)` minted to registrant, once |

### Updatable after the fact (artist role only)

| Control | Mutability | Notes |
|---|---|---|
| `set_minter` | until `lock_minter` | rotate dungeons freely; **zero address = pause minting**; affects future mints only |
| `lock_minter` | one-way | binds the species to its dungeon forever |
| `update_art` | until `lock_art` | factory providers only; auto `MetadataUpdate` fan-out (cooldown-shared) |
| `set_art_provider` | until `lock_art` | swap factory ↔ custom; factory flag recomputed against canonical address |
| `notify_art_updated` | until `lock_art` | custom providers; shares the per-species cooldown |
| `lock_art` | one-way | freezes art + provider pointer permanently |
| `set_stats_source` | anytime | opt-in kill stats; SRC5-verified at set time; zero = off |
| `transfer_artist_role` | anytime | non-zero target only; single-key — recommend multisig for serious species |

### Hard limitations

- **Max supply per species: exactly 1,243** — `(id, prefix, suffix)`
  uniqueness with prefix 1–69 × suffix 1–18 + 1 genesis. Stat variations
  never create extra mintable slots.
- No species deletion, no burns, no name/type/tier changes, ever.
- The artist *may* set themselves as minter — full mint power over their own
  species. By design; UIs and consuming games surface/filter on minter
  identity.
- `lock_art` on a **custom** provider freezes the pointer, not the provider's
  internals. Only factory-provider + locked = provably frozen.
- Lost artist key = species config frozen as-is; minting continues through
  the current minter unaffected.

## Migration: holders move 1:1 into the new collection

Every holder of the live collection ends up with the same Beasts in the new
collection — same `(id, prefix, suffix, level, health, shiny, animated)`,
re-encoded under the 116-bit deterministic token IDs.

### Mainnet target: player-initiated `burn_and_mint` (deferred)

The intended mainnet path is **not** an owner-run airdrop but a `burn_and_mint`
entrypoint players call themselves: present a V2 Beast, burn it, receive the
V3 equivalent. That keeps the migration permissionless, makes the V2 supply
verifiably retired, and removes the owner from the critical path.

**This is deferred and deliberately unbuilt.** The constraint carried through
every PR is that nothing may foreclose it. Concretely, what keeps the door
open:

- Mint validation lives in reusable helpers (`assert_can_mint`,
  `MintingCoordinatorTrait::prepare_mint_with_traits`) rather than inlined in
  the `mint` entrypoint, so a second entrypoint can reuse the whole chain
  without relaxing any invariant.
- The `minted` uniqueness map starts empty except for the 75 genesis affix
  slots, so every `(id, prefix, suffix)` a V2 holder could present is still
  free to claim.
- Species 1–75 resolve tier/type/name from the baked-in tables with no
  registry involvement, so burn-and-mint of an original Beast needs no
  registry entry to exist.
- Token IDs are a pure function of beast attributes, so the V3 ID for any V2
  Beast is computable off-chain before the contract exists.

One live hazard to respect at cutover: because V2 Beasts and V3 dungeon mints
draw from the same `(id, prefix, suffix)` space, a dungeon could mint a slot a
V2 holder still needs. Mainnet deploy must therefore leave `dungeon_address`
at zero (and community species paused, or registration closed) until
migration completes.

### Fallback mechanism: owner-run airdrop

Retained as the fallback if `burn_and_mint` slips. Requires zero
migration-specific code in `beasts_nft`.

- **Snapshot**: index the old collection (owners + `get_beast` per token) at a
  stable block. If the old collection's `terminal_timestamp` has passed it is
  already frozen; otherwise pause it first (`set_dungeon_address(0)` on the
  old contract). Any mints after snapshot are handled by re-running the diff
  before cutover.
- **Non-genesis beasts** (the bulk): deploy a one-shot `Migrator` contract
  holding the snapshot batches (owner-gated). Temporarily
  `set_dungeon_address(migrator)` on the NEW contract; the migrator calls the
  ordinary `mint(to, id, prefix, suffix, level, health, shiny, animated)` for
  every snapshot row; then rotate `dungeon_address` to the real dungeon. All
  invariants (uniqueness, ranking, prefix/suffix >= 1) are enforced by the
  normal mint path — the migrator has no special powers beyond being the
  minter for the migration window.
- **Genesis beasts 1–75**: constructor mints them to the owner (unchanged);
  the owner batch-transfers each to its snapshot holder. 75 transfers, no
  code change.

### Gas/event optimization: mint in descending power order per species

`calculate_and_store_rank` inserts via binary search; minting each species'
beasts strongest-first means every insert lands at the END of the species
list → **zero rank-shift writes and zero `MetadataUpdate` fan-out events**
for the entire airdrop (and no bookmark writes). Sorting the snapshot
off-chain is free; not sorting makes the airdrop quadratic-ish in storage
writes for large species. Cost per beast ≈ the normal ~8 slot writes.

### What carries over automatically

- **Kill-stat history**: the entity hash is `poseidon(id, prefix, suffix)`
  over felts (`src/pack.cairo:16-22`), and a `u8` and `u64` with the same
  value produce the same felt — so hashes for species 1–75 are **identical**
  after widening. The existing live Death Mountain path serves the same
  history to the airdropped tokens with no data migration.
- **Ranking**: same power formula → identical final ordering regardless of
  mint order.
- **Rarity/uniqueness**: `(id, prefix, suffix)` entries repopulate through
  the normal `minted` map.

### Registry backfill of species 1–75 — deferred, not required

Backfill was considered and **dropped from scope**. Species 1–75 resolve
name, tier, and type from `beast_definitions`, authorize against
`dungeon_address`, and render through the four legacy art contracts — all
without the registry. A backfill would only add a second, redundant lookup
surface for clients.

It stays available later: `FIRST_COMMUNITY_ID = 76` gates *registration*
only, and no registry read path asserts a lower bound on a stored key, so a
future admin entrypoint could write entries for 1–75 without touching the
existing logic. `is_registered` and `assert_registered` would need their
range check widened at that point; nothing else would.

### Cutover sequence

1. Old collection frozen (terminal passed, or dungeon set to 0).
2. Snapshot + sort (descending power per species).
3. Deploy new stack (sequence below), verify genesis + registry backfill.
4. `set_dungeon_address(migrator)`; run airdrop batches; verify supply and
   spot-check holders/ranks against snapshot.
5. Owner transfers the 75 genesis tokens to snapshot holders.
6. `set_dungeon_address(death_mountain)`; announce; marketplaces index the
   new contract.

## Deployment sequence (fresh deploy, per repo policy)

1. Declare and deploy the four genesis art data contracts.
2. Declare `StoredArtProvider` class (never deployed directly — the registry
   deploys instances per species).
3. Deploy `BeastRegistry(owner, stored_art_class_hash)`.
4. Deploy `beasts_nft(name, symbol, owner, royalty_receiver,
   royalty_fraction, 4 art providers, death_mountain)` — constructor mints
   the 75 genesis beasts (entered into `minted`). No `terminal_timestamp`
   param, and no registry param: the two contracts are wired after the fact
   because each needs the other's address.
5. `registry.set_nft_address(nft)` — one-time; registry reverts all
   registration until this is called.
6. `nft.set_registry_address(registry)` — one-time; community-species mints
   and renders revert until this is called.

Steps 5 and 6 are both write-once and both required; a stack missing either
accepts no community species at all, which is the intended fail-closed state.

## Web app flow

1. Artist uploads up to 4 images; app validates format client-side, strips
   metadata, base64-encodes to data URIs, and previews the exact card via the
   TS SDK renderer. App *suggests* size budgets with a live fee estimate from
   the slot formula — but caps are advisory, not contractual.
2. Name (client-side charset validation mirroring the contract), type, tier,
   minter (featured path: a Loot Survivor dungeon; or "set later" = zero =
   paused).
3. One `register_beast_with_art` transaction via Cartridge Controller. The
   artist's wallet receives the Genesis Beast in the same transaction.
4. Dashboard: update art (auto marketplace refresh), rotate/pause/lock
   minter, lock art, opt into kill stats, transfer artist role, graduate to a
   custom provider.

Curation is UI/indexer-level only; the contract layer stays permissionless.

## SDK changes

- `decodeTokenId`/`encodeTokenId` → 116-bit layout, `BigInt` throughout;
  `isGenesis = prefix === 0 && suffix === 0`.
- Static profile derived offline from the token ID; only name + art need
  chain reads, both cacheable per species.
- Renderer gains community-art support (fetch data URI from provider).

## Test plan

- `pack.cairo`: round-trips incl. tier/type, max values, `u128` bound,
  mixed-zero prefix/suffix rejection, legacy-53-bit rejection, `id != 0`,
  fuzz encode/decode.
- Registry: both registration paths; sequential IDs from 76; **name charset
  enforcement incl. injection payloads (`"`, `<`, `\`, control bytes, edge
  spaces)**; duplicate names accepted; artist-only admin; both locks one-way
  and blocking; zero-minter registration; pre-`set_nft_address` reverts;
  factory determinism; `set_art_provider` factory-flag recomputation.
- StoredArtProvider: variant truth table; `set_art` double gating (registry +
  beast_id match); `get_data_uri` id assert.
- NFT: per-species mint auth (wrong dungeon, unregistered id, zero/paused
  minter); provenance mint + `(id,0,0)` reservation; `prefix/suffix >= 1`
  enforcement; tier/type sourced from registry not caller; ranking with `u64`
  keys; `token_uri` via new provider interface; fan-out includes genesis
  token; bookmark `min()` under interleaved mint + art-update; cooldown
  shared across both art mutators; `refresh_stats` cache + rate limit +
  reverting-source containment; no Votes/Nonces/terminal artifacts remain.
- Integration: full artist journey — register → provenance mint → dungeon
  mints → transfer → `token_uri` → art update → lock art → lock minter →
  stats opt-in → refresh.

## Implementation phasing

1. **PR 1 — token ID format**: `pack.cairo` 116-bit layout, `PackableBeast`
   fields, `u64` widening across ranking/minting/coordinator,
   `prefix/suffix >= 1` validation, all existing tests updated.
2. **PR 2 — strip-down**: remove VotesComponent + Nonces + terminal_timestamp;
   new description copy; genesis-into-`minted` (or land the enumeration
   branch first, which includes it).
3. **PR 3 — registry + provider**: `BeastRegistry`, `StoredArtProvider`,
   factory, `IBeastArtProvider`, name charset guard, registry tests.
4. **PR 4 — NFT integration**: per-species mint auth, provenance mint,
   `token_uri` art/name/stats routing, render-time output validation for
   untrusted providers, fan-out fix (genesis token), cached `refresh_stats`,
   end-to-end integration tests. Stacked on PR 3 rather than on `main` —
   the registry is not merged to `main` until the whole stack has been
   exercised on Sepolia.
5. **PR 5 — SDK + web app**: TS SDK encode/decode + renderer; self-service
   app (likely separate repo). Death Mountain `u64` interface update tracked
   in the DM repo.
6. **PR 6 — migration**: `burn_and_mint` entrypoint (see Migration), plus
   snapshot/verification tooling and the cutover runbook. Needed before
   mainnet, independent of PRs 3–5.

## Remaining open items

- Final description copy (marketing pass) for the generalized bestiary text.
- `IBeastStats` interface finalization + Death Mountain u64 upgrade scope
  (owned by the DM repo).
- Migration logistics: snapshot tooling (indexer query vs. event replay),
  batch size per migrator transaction, and whether the migrator contract or
  a multicall script executes the batches.
