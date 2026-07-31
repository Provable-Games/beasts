#!/usr/bin/env bash
set -euo pipefail

# Declare and deploy the standalone Black Shuck collection with Starknet Foundry sncast.
# Required in .env: NAME, SYMBOL, OWNER, MINTER_ADDRESS, ROYALTY_RECEIVER, ROYALTY_FRACTION.
# The RPC url comes from snfoundry.toml via SNCAST_PROFILE; signing uses a starkli-style
# keystore + account pair, overridable with KEYSTORE and ACCOUNT_FILE (defaults below).
#
# The declare step is idempotent: re-running against a network that already has this class is
# reported and skipped rather than treated as a failure, so the script is safe to retry after a
# deploy that failed for an unrelated reason.
#
# Every value may also be given with a BLACK_SHUCK_ prefix (BLACK_SHUCK_NAME,
# BLACK_SHUCK_SYMBOL, BLACK_SHUCK_OWNER, BLACK_SHUCK_MINTER_ADDRESS,
# BLACK_SHUCK_ROYALTY_RECEIVER, BLACK_SHUCK_ROYALTY_FRACTION). The prefixed value wins when set,
# so a .env shared with another collection's deploy cannot silently mislabel this one.

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
else
  echo "Error: .env file not found." >&2
  exit 1
fi

NAME=${BLACK_SHUCK_NAME:-${NAME:-}}
SYMBOL=${BLACK_SHUCK_SYMBOL:-${SYMBOL:-}}
OWNER=${BLACK_SHUCK_OWNER:-${OWNER:-}}
MINTER_ADDRESS=${BLACK_SHUCK_MINTER_ADDRESS:-${MINTER_ADDRESS:-}}
ROYALTY_RECEIVER=${BLACK_SHUCK_ROYALTY_RECEIVER:-${ROYALTY_RECEIVER:-}}
ROYALTY_FRACTION=${BLACK_SHUCK_ROYALTY_FRACTION:-${ROYALTY_FRACTION:-}}

: "${NAME:?NAME (or BLACK_SHUCK_NAME) is required in .env}"
: "${SYMBOL:?SYMBOL (or BLACK_SHUCK_SYMBOL) is required in .env}"
: "${OWNER:?OWNER (or BLACK_SHUCK_OWNER) is required in .env}"
: "${MINTER_ADDRESS:?MINTER_ADDRESS (or BLACK_SHUCK_MINTER_ADDRESS) is required in .env}"
: "${ROYALTY_RECEIVER:?ROYALTY_RECEIVER (or BLACK_SHUCK_ROYALTY_RECEIVER) is required in .env}"
: "${ROYALTY_FRACTION:?ROYALTY_FRACTION (or BLACK_SHUCK_ROYALTY_FRACTION) is required in .env}"

SNCAST_PROFILE=${SNCAST_PROFILE:-default}
DRY_RUN=${DRY_RUN:-0}

command -v scarb >/dev/null 2>&1 || { echo "Error: scarb is required." >&2; exit 1; }
command -v sncast >/dev/null 2>&1 || { echo "Error: sncast is required." >&2; exit 1; }

# --- signing: starkli-style keystore + account pair -----------------------------------------
# sncast supports two signing modes. We use the keystore one, which takes an encrypted keystore
# plus a path to a starkli JSON account file. (The other mode takes an account *name* looked up
# in an sncast accounts file - that is what --accounts-file is for, and we are not using it.)
KEYSTORE=${KEYSTORE:-~/.starknet_accounts/keystore.json}
ACCOUNT_FILE=${ACCOUNT_FILE:-~/.starknet_accounts/account.json}

# Expand a leading ~ ourselves: these usually arrive from .env, where the tilde is quoted and
# therefore never expanded by the shell.
KEYSTORE="${KEYSTORE/#\~/$HOME}"
ACCOUNT_FILE="${ACCOUNT_FILE/#\~/$HOME}"

[ -f "$KEYSTORE" ] || { echo "Error: keystore not found at '$KEYSTORE'." >&2; exit 1; }
[ -f "$ACCOUNT_FILE" ] || { echo "Error: account file not found at '$ACCOUNT_FILE'." >&2; exit 1; }

# snfoundry.toml interpolates these into every profile. sncast fails to load the config file if
# they are undefined, even though keystore mode never reads them - so give them inert values.
export SNCAST_ACCOUNT="${SNCAST_ACCOUNT:-unused-in-keystore-mode}"
export SNCAST_ACCOUNTS_FILE="${SNCAST_ACCOUNTS_FILE:-/dev/null}"
export SEPOLIA_RPC_URL="${SEPOLIA_RPC_URL:-${RPC_URL:-}}"
export MAINNET_RPC_URL="${MAINNET_RPC_URL:-${RPC_URL:-}}"

# Common prefix for every sncast invocation. --keystore/--account are global flags and must
# precede the subcommand.
SNCAST_BASE=(sncast --profile "$SNCAST_PROFILE" --keystore "$KEYSTORE" --account "$ACCOUNT_FILE")

# sncast prompts for the keystore password unless KEYSTORE_PASSWORD is exported. Leaving it
# unset means one interactive confirmation per run, which is a reasonable guard on mainnet.
if [ -z "${KEYSTORE_PASSWORD:-}" ]; then
  echo "Note: KEYSTORE_PASSWORD is not set; sncast will prompt for the keystore password."
fi

for addr_var in OWNER MINTER_ADDRESS ROYALTY_RECEIVER; do
  val=${!addr_var}
  if ! [[ "$val" =~ ^0x[0-9a-fA-F]+$ ]]; then
    echo "Error: $addr_var must be a 0x-prefixed hex address. Got: '$val'" >&2
    exit 1
  fi
done

if ! [[ "$ROYALTY_FRACTION" =~ ^[0-9]+$ ]]; then
  echo "Error: ROYALTY_FRACTION must be a decimal integer (u128). Got: '$ROYALTY_FRACTION'" >&2
  exit 1
fi

# FEE_DENOMINATOR is 10,000 in the contract, so anything above that is over 100%.
if [ "$ROYALTY_FRACTION" -gt 10000 ]; then
  echo "Error: ROYALTY_FRACTION is denominated in 10,000 (500 = 5%); $ROYALTY_FRACTION exceeds 100%." >&2
  exit 1
fi

if [[ "$NAME" == *\"* || "$SYMBOL" == *\"* ]]; then
  echo "Error: NAME and SYMBOL cannot contain double quotes when using sncast --arguments." >&2
  exit 1
fi

echo "Building contracts with scarb..."
scarb build

mkdir -p deployments
TS=$(date +%s)
DEPLOY_LOG="deployments/black-shuck-$TS.txt"
ARGS="\"$NAME\", \"$SYMBOL\", $OWNER, $MINTER_ADDRESS, $ROYALTY_RECEIVER, $ROYALTY_FRACTION"

# --- declare (idempotent) -------------------------------------------------------------------
CLASS_HASH=""
if [[ "$DRY_RUN" == "1" || "$DRY_RUN" == "true" ]]; then
  echo "Dry run: skipping declare."
else
  echo "Declaring black_shuck_nft with sncast profile '$SNCAST_PROFILE'..."
  set +e
  DECLARE_OUTPUT=$("${SNCAST_BASE[@]}" --wait declare --contract-name black_shuck_nft 2>&1)
  DECLARE_STATUS=$?
  set -e
  echo "$DECLARE_OUTPUT"

  if [ "$DECLARE_STATUS" -eq 0 ]; then
    echo "Declared."
  elif printf '%s' "$DECLARE_OUTPUT" | grep -qiE 'already declared|ClassAlreadyDeclared|is already used'; then
    # Re-running against a network that already has this exact class is a success, not a failure.
    echo "Class already declared on this network; skipping."
  else
    echo "Error: declare failed." >&2
    printf '%s\n' "$DECLARE_OUTPUT" >&2
    exit 1
  fi

  CLASS_HASH=$(printf '%s\n' "$DECLARE_OUTPUT" | sed -n 's/.*class_hash: *//p' | tail -1)
  if [ -z "$CLASS_HASH" ]; then
    # The already-declared path reports the hash in prose rather than a class_hash: line, so
    # fall back to the first long hex token. Best-effort: only used for the deployment log.
    # `|| true` matters: under `set -e` a grep with no match would abort the whole script.
    CLASS_HASH=$(printf '%s\n' "$DECLARE_OUTPUT" | grep -oiE '0x[0-9a-f]+' | head -1 || true)
  fi
fi

deploy_cmd=(
  "${SNCAST_BASE[@]}"
  --wait
  deploy
  --contract-name black_shuck_nft
  --arguments "$ARGS"
)

if [[ "$DRY_RUN" == "1" || "$DRY_RUN" == "true" ]]; then
  deploy_cmd+=(--dry-run --detailed)
fi

{
  echo "timestamp=$TS"
  echo "profile=$SNCAST_PROFILE"
  echo "name=$NAME"
  echo "symbol=$SYMBOL"
  echo "owner=$OWNER"
  echo "minter_address=$MINTER_ADDRESS"
  echo "royalty_receiver=$ROYALTY_RECEIVER"
  echo "royalty_fraction=$ROYALTY_FRACTION"
  echo "class_hash=${CLASS_HASH:-unknown}"
  echo "dry_run=$DRY_RUN"
  echo "deploy_command=${deploy_cmd[*]}"
} > "$DEPLOY_LOG"

echo "Deploying black_shuck_nft with sncast profile '$SNCAST_PROFILE'..."
# Capture rather than let `set -e` abort on a non-zero exit: on a failed mainnet deploy the
# sncast output is the only diagnostic there is, and aborting here would discard it unprinted
# and unlogged. Mirrors the declare step above.
set +e
DEPLOY_OUTPUT=$("${deploy_cmd[@]}" 2>&1)
DEPLOY_STATUS=$?
set -e
echo "$DEPLOY_OUTPUT"
printf '%s\n' "$DEPLOY_OUTPUT" >> "$DEPLOY_LOG"

if [ "$DEPLOY_STATUS" -ne 0 ]; then
  echo "Error: deploy failed (sncast exit $DEPLOY_STATUS)." >&2
  echo "Full output written to: $DEPLOY_LOG" >&2
  exit 1
fi

CONTRACT_ADDRESS=$(printf '%s\n' "$DEPLOY_OUTPUT" | sed -n 's/.*contract_address: *//p' | tail -1)
TRANSACTION_HASH=$(printf '%s\n' "$DEPLOY_OUTPUT" | sed -n 's/.*transaction_hash: *//p' | tail -1)

if [[ "$DRY_RUN" != "1" && "$DRY_RUN" != "true" ]]; then
  if [ -z "${CONTRACT_ADDRESS:-}" ] || [ -z "${TRANSACTION_HASH:-}" ]; then
    echo "Error: deploy reported success but no contract address or transaction hash was" >&2
    echo "found in its output. Do NOT re-run blindly - the deploy may have landed." >&2
    echo "Full output written to: $DEPLOY_LOG" >&2
    exit 1
  fi

  {
    echo "contract_address=$CONTRACT_ADDRESS"
    echo "transaction_hash=$TRANSACTION_HASH"
  } >> "$DEPLOY_LOG"

  echo "Deployment successful."
  echo "Contract Address: $CONTRACT_ADDRESS"
  echo "Transaction Hash: $TRANSACTION_HASH"
else
  echo "Dry run complete."
fi

echo "Wrote deployment log to: $DEPLOY_LOG"
