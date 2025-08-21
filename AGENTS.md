# Repository Guidelines

## Project Structure & Module Organization
- `src/` Cairo 1 contracts. Entry: `src/lib.cairo` exporting `beasts_nft`, `beast_*`, `pack`, `metadata_generator`, `minting_coordinator`, and `interfaces`.
- Tests live alongside code in `src/` (e.g., `mint_tests.cairo`, `integration_test.cairo`, `tests.cairo`).
- `assets/` artwork and examples for docs/previews.
- `scripts/` network deploy helpers (`deploy_sepolia.sh`, `deploy_mainnet.sh`).
- Build outputs in `target/` (git‑ignored).

## Build, Test, and Development Commands
- `scarb build` — Compile the contracts.
- `scarb fmt` / `scarb fmt --check` — Format and verify formatting.
- `snforge test` — Run unit and integration tests.
- `snforge test --features fuzzing --fuzzer-runs 500 --coverage` — Fuzz and create `coverage/coverage.lcov`.
- `lcov --summary coverage/coverage.lcov` — Summarize coverage locally.
- Deploy with `scripts/deploy.sh` using `.env`: `STARKNET_ACCOUNT`, `STARKNET_PRIVATE_KEY`, `RPC_URL`, `NAME`, `SYMBOL`, `OWNER`, `ROYALTY_RECEIVER`, `ROYALTY_FRACTION`.

## Coding Style & Naming Conventions
- 4‑space indent; no tabs. Keep functions small and pure when possible.
- Names: modules/files `snake_case`; functions `snake_case`; types/traits `PascalCase`; constants `UPPER_SNAKE_CASE`.
- Export public APIs in `src/lib.cairo` via `pub mod ...`.
- Prefer traits over free helpers; use `panic` only for invariant checks.

## Testing Guidelines
- Framework: Starknet Foundry (`snforge_std`).
- Place tests in `src/` with `*_test.cairo` or `*_tests.cairo` suffixes.
- Coverage: CI enforces ≥35% patch coverage; aim for ≥80% overall when feasible.
- Example: `snforge test --coverage && lcov --summary coverage/coverage.lcov`.

## Commit & Pull Request Guidelines
- Commits: short, imperative, scoped (e.g., `add shiny art assets`, `reduce test threshold`).
- PRs: provide a clear description, linked issues, affected modules, and test notes (commands run, coverage delta). Add screenshots for asset changes and note any deploy impact.
- Ensure `scarb fmt --check` passes and tests are green before requesting review.

## Security & Configuration Tips
- Never commit secrets; use `.env` (git‑ignored). Confirm tool versions with `.tool-versions`.
- Keep deploy addresses/keys out of code; deploy scripts read from environment variables.

