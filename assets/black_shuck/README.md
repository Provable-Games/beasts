# Black Shuck artwork

Source art for the collection. The contract never reads these files — it reads the base64 data
URIs embedded in `src/black_shuck_assets.cairo`. These are the originals those URIs were built
from.

| File | Format | Used when | Raw |
| --- | --- | --- | --- |
| `t1_black-shuck.png` | PNG, 32×32 | `animated = false, shiny = false` | 298 B |
| `t1_black-shuck_shiny.png` | PNG, 32×32 | `animated = false, shiny = true` | 498 B |
| `t1_black-shuck.gif` | GIF, 32×32, 4 frames | `animated = true, shiny = false` | 674 B |
| `t1_black-shuck_shiny.gif` | GIF89a, 32×32, 4 frames | `animated = true, shiny = true` | 1,418 B |

The two regular files are hand-authored. **Both shiny files are generated** — don't edit them by
hand, regenerate them:

```
python3 scripts/make_shiny.py assets/black_shuck/t1_black-shuck.png
python3 scripts/make_shiny.py assets/black_shuck/t1_black-shuck.gif
```

## Authoring convention

A regular sprite is only ever two colours: opaque black for the body and one tier accent for the
outline. Black Shuck is Tier 1, so its accent is `#ff8000`. `make_shiny.py` keys off that accent
— if a regular sprite is authored with any other colour the script exits rather than silently
producing nothing.

The GIF additionally sits on an **opaque black field** with a 4-entry global colour table, which
is what the rest of the collection's regular GIFs do.

## After changing any sprite

1. Re-run `make_shiny.py` for whichever format changed.
2. Re-embed all four as base64 in `src/black_shuck_assets.cairo`.
3. `scarb build && snforge test --max-n-steps 4294967295`.
4. Regenerate the `assets/examples/black_shuck_*.svg` card snapshots.

## Constraints

- Statics must stay PNG and animateds must stay GIF — the metadata tests assert on the
  `data:image/png;base64,` and `data:image/gif;base64,` prefixes.
- All four URIs must stay distinct; `test_asset_variants_are_distinct` catches a half-finished
  swap.
- Keep them small. The whole URI is stored on-chain and rebuilt on every `token_uri` call. The
  current four total 3,856 base64 chars.
