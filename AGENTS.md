# Repository Guidelines

## Project Structure & Module Organization
- `src/` Cairo 1 contracts. Entry: `src/lib.cairo`; keep exported public modules in sync there with `pub mod ...`.
- Tests live alongside code in `src/` (e.g., `mint_tests.cairo`, `integration_test.cairo`, `tests.cairo`).
- `assets/` artwork and examples for docs/previews.
- `scripts/deploy.sh` is the single network-agnostic deploy helper; configure network and constructor values through `.env`.
- Build outputs in `target/`, deployment logs in `deployments/`, and coverage files in `coverage/` are git-ignored.

## Build, Test, and Development Commands
- `scarb build` - Compile the contracts.
- `scarb fmt` / `scarb fmt --check --workspace` - Format and verify formatting; CI uses the workspace check.
- `snforge test` - Run unit and integration tests.
- `snforge test --max-n-steps 4294967295` - Match the CI test command.
- `snforge test --fuzzer-runs 500 --coverage` - Run fuzz-capable tests with 500 fuzzer runs and create `coverage/coverage.lcov`.
- `lcov --summary coverage/coverage.lcov` - Summarize coverage locally.
- Deploy with `bash scripts/deploy.sh` using `.env`: `STARKNET_ACCOUNT`, `STARKNET_PRIVATE_KEY`, `RPC_URL`, `NAME`, `SYMBOL`, `OWNER`, `ROYALTY_RECEIVER`, `ROYALTY_FRACTION`, `TERMINAL_TIMESTAMP`; optional `DEATH_MOUNTAIN_ADDRESS` defaults to `0`.
- Tool versions are pinned in `.tool-versions`; deployment also requires `starkli`, and coverage summaries require `cairo-coverage` plus `lcov`.

## Coding Style & Naming Conventions
- 4-space indent; no tabs. Keep functions small and pure when possible.
- Names: modules/files `snake_case`; functions `snake_case`; types/traits `PascalCase`; constants `UPPER_SNAKE_CASE`.
- Export public APIs in `src/lib.cairo` via `pub mod ...`.
- Prefer traits over free helpers; use `panic` only for invariant checks.

## Beast Token ID Design
- `PackableBeast` in `src/pack.cairo` defines the canonical 53-bit token ID format. Use `encode_token_id(beast)` and `decode_token_id(token_id)`; do not duplicate the bit math elsewhere.
- ERC721 token IDs are deterministic, not sequential: `token_id == encode_token_id(PackableBeast)` for both genesis and non-genesis Beasts.
- The contract intentionally has no `Storage.beasts` map. Decode token IDs only after ERC721 ownership/existence checks where user-facing existence matters.
- The Beasts API intentionally has no enumerable `total_supply()`; use ERC721 `balance_of(owner)` and owner enumeration for owner-level queries.
- Genesis Beasts are minted in the constructor, have rank `0`, and must not rely on `token_id <= 75`. They are entered into the `minted` uniqueness map so `(beast_id, 0, 0)` duplicate attempts fail with `Beast already minted`.
- Beast uniqueness remains based on `(beast_id, prefix, suffix)` via `minted`; ranking, metadata bookmarks, and manual refresh timestamps still index by packed token ID.
- This storage/token-ID design is for fresh deployments only. Do not add migration behavior for legacy sequential token IDs unless explicitly requested.

## Testing Guidelines
- Framework: Starknet Foundry (`snforge_std`).
- Prefer test files in `src/` with `*_test.cairo` or `*_tests.cairo` suffixes; existing legacy files such as `tests.cairo` remain valid.
- Fuzzing is controlled by `#[fuzzer(...)]`, `[tool.snforge]`, and `snforge test --fuzzer-runs`; do not pass `--features fuzzing` unless a matching Scarb feature is added.
- Coverage is recommended locally but is not currently enforced by CI; aim for >=80% overall when feasible.
- Example: `snforge test --coverage && lcov --summary coverage/coverage.lcov`.

## Commit & Pull Request Guidelines
- Commits: short, imperative, scoped (e.g., `add shiny art assets`, `reduce test threshold`).
- PRs: provide a clear description, linked issues, affected modules, and test notes (commands run, coverage delta). Add screenshots for asset changes and note any deploy impact.
- Ensure `scarb fmt --check --workspace` passes and tests are green before requesting review.

## Security & Configuration Tips
- Never commit secrets; use `.env` (git-ignored). Confirm tool versions with `.tool-versions`.
- Keep deploy addresses/keys out of code; deploy scripts read from environment variables.
