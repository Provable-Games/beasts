# Repository Guidelines

## Project Structure & Module Organization
- `src/` Cairo 1 code. Main entry is `src/lib.cairo` (exposes `beasts_nft` and modules like `beast_*`, `pack`, `metadata_generator`, `minting_coordinator`, `interfaces`).
- `assets/` Artwork and examples used for docs and previews.
- `scripts/` Network deploy helpers (`deploy_sepolia.sh`, `deploy_mainnet.sh`).
- Tests live alongside code in `src/` (e.g., `mint_tests.cairo`, `integration_test.cairo`, `tests.cairo`).
- Build artifacts go to `target/` (git‑ignored).

## Build, Test, and Development Commands
- `scarb build` — Compile the contracts.
- `scarb fmt` / `scarb fmt --check` — Format and lint formatting.
- `snforge test` — Run unit/integration tests.
- `snforge test --features fuzzing --fuzzer-runs 500 --coverage` — Fuzz and produce `coverage/coverage.lcov`.
- `lcov --summary coverage/coverage.lcov` — Summarize coverage locally.
- Deployment: `scripts/deploy.sh` (configure network and params via `.env` — requires at least `STARKNET_ACCOUNT`, `STARKNET_PRIVATE_KEY`, `RPC_URL`, `NAME`, `SYMBOL`, `OWNER`, `ROYALTY_RECEIVER`, `ROYALTY_FRACTION`).

## Coding Style & Naming Conventions
- Cairo style: 4‑space indent, no tabs. Keep functions small and pure where possible.
- Naming: modules/files `snake_case`; functions `snake_case`; types/traits `PascalCase`; constants `UPPER_SNAKE_CASE`.
- Public APIs must be exported in `src/lib.cairo` via `pub mod ...`.
- Prefer traits over free helpers; avoid `panic` except for invariant checks.

## Testing Guidelines
- Framework: Starknet Foundry (`snforge_std`). Place tests in `src/` with suffix `*_test.cairo` or `*_tests.cairo` for clarity.
- Cover new logic with deterministic tests; add fuzz cases behind the `fuzzing` feature when helpful.
- CI enforces formatting and runs `snforge` with coverage; patch coverage threshold is ≥35%. Aim for ≥80% overall when feasible.

## Commit & Pull Request Guidelines
- Commits: short, imperative, scoped (e.g., `add shiny art assets`, `reduce test threshold`).
- PRs: include a clear description, linked issues, affected modules, and test notes (commands run, coverage delta). Add screenshots for asset changes and note any deploy impact.
- Ensure `scarb fmt --check` passes and tests are green before requesting review.

## Security & Configuration Tips
- Do not commit secrets; use `.env` (git‑ignored). Confirm tool versions with `.tool-versions` before running commands.
- Keep deploy addresses/keys out of code; scripts read from environment.
