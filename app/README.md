# Add a Beast

Self-service web app for adding a species to the bestiary. Upload pixel art,
name it, choose where it can be minted — one transaction, no permission needed.

```bash
pnpm install
pnpm build:sdk       # the app consumes the SDK's build output
pnpm dev:app
```

## Configuration

Defaults point at the Sepolia deployment in `docs/sepolia-v3-deployment.md`.
Override with a `.env`:

```
VITE_STARKNET_RPC_URL=https://api.cartridge.gg/x/starknet/sepolia
VITE_BEASTS_NFT=0x...
VITE_BEASTS_REGISTRY=0x...
```

## Pages

Hash routing, so every page is a real shareable URL on a static host.

| URL | |
|---|---|
| `#/` | Add a Beast |
| `#/collection/0xabc…` | Every Beast an address holds. **Swap the address to view any wallet** — no connection needed |
| `#/beasts` | The bestiary, one card per species. The original 75 are behind a toggle |
| `#/beasts/76` | Every Beast of one species, strongest first |
| `#/manage` | Species you control |
| `#/manage/76` | Per-species controls |

Grouping the bestiary by species is the default because the collection is
unbounded and a single species can hold 1,243 Beasts — a flat list of every
token would be unreadable long before it was useful.

Species pages read the contract's own per-species rank list rather than
scanning, so the ordering shown is the one the collection itself uses.

## What the app does

**Register.** Four art variants are required — which one a Beast shows is
decided by the shiny and animated bits in its token ID, so a species cannot ship
a partial set. Art is validated client-side against the same rules the contract
enforces (media type, base64 structure, PNG/GIF magic bytes) *and* decoded by
the browser, because a file that will not decode here renders broken for every
holder. Registration mints the artist's Genesis Beast in the same transaction.

**Manage.** Lists every species the connected wallet holds the artist role for,
with its live art, and opens the per-species controls: replace art, rotate or
pause the minter, lock either one permanently, opt into kill stats, transfer
the artist role, or graduate to a custom art provider.

The list comes from the wallet's own tokens: the collection exposes
`token_of_owner_by_index`, and a Genesis Beast is any token with no affixes, so
the species a wallet controls fall straight out of a local decode. That works
because the **artist role is ownership of the Genesis Beast** — there is no
separate role to drift from the token. Everything is artist-only on-chain; the
UI hides what the caller cannot do and the contract is the real gate.

Transferring a species means sending its Genesis Beast, which the dashboard
spells out before it asks for a signature.

Art thumbnails come from each species' own provider, which for a custom
provider is arbitrary contract code. One that reverts costs its own thumbnail,
not the whole list.

## Art loading

Art is fetched per Beast, not per species. A community provider receives the
whole decoded Beast, so it may legitimately vary art by affix, tier or level —
caching by species would show the wrong picture for exactly the providers that
make the interface worth having. Requests are batched and the cache is keyed by
token ID, shared across pages.

The contract validates art structurally — media type, base64, magic bytes — but
cannot prove a payload decodes. A tile whose art will not render says so rather
than showing a broken-image icon.

## The preview card is an approximation

`CardPreview` mirrors the layout of the on-chain SVG so an artist can judge
their work in context before paying for a transaction. It is **not** the
contract's renderer — that lives in `src/beast_svg.cairo` and only produces
output once a species exists. Porting it byte-for-byte to TypeScript would let
the preview be exact; until then, treat the card as indicative and `token_uri`
as the truth.

## Session policy

The Cartridge connector pre-approves the registry's *management* entrypoints, so
an artist signs once and can then iterate without a popup per change.
`register_beast_with_art` is deliberately excluded: it mints a provenance token
and permanently assigns a species ID, so it should always be an explicit
signature.

## Smoke test

`scripts/smoke.mjs` drives the built app in headless Chromium against the live
deployment — it checks the chain read renders, name validation rejects an
injection attempt, the preview derives power correctly, and the dashboard loads
a real species.

```bash
pnpm build && pnpm preview &
node scripts/smoke.mjs
```

It needs a Playwright browser; in this dev container that means
`LD_LIBRARY_PATH=/workspace/.playwright-libs/root/usr/lib/x86_64-linux-gnu` and
an `executablePath` pointing at the cached Chromium.
