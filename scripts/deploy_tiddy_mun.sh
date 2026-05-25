#!/usr/bin/env bash
set -euo pipefail

# Deploy the standalone Tiddy Mun collection with Starknet Foundry sncast.
# Required in .env: NAME, SYMBOL, OWNER, MINTER_ADDRESS.
# sncast account/RPC settings are read from snfoundry.toml via SNCAST_PROFILE.

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
else
  echo "Error: .env file not found." >&2
  exit 1
fi

: "${NAME:?NAME is required in .env}"
: "${SYMBOL:?SYMBOL is required in .env}"
: "${OWNER:?OWNER is required in .env}"
: "${MINTER_ADDRESS:?MINTER_ADDRESS is required in .env}"

SNCAST_PROFILE=${SNCAST_PROFILE:-default}
DRY_RUN=${DRY_RUN:-0}

command -v scarb >/dev/null 2>&1 || { echo "Error: scarb is required." >&2; exit 1; }
command -v sncast >/dev/null 2>&1 || { echo "Error: sncast is required." >&2; exit 1; }

for addr_var in OWNER MINTER_ADDRESS; do
  val=${!addr_var}
  if ! [[ "$val" =~ ^0x[0-9a-fA-F]+$ ]]; then
    echo "Error: $addr_var must be a 0x-prefixed hex address. Got: '$val'" >&2
    exit 1
  fi
done

if [[ "$NAME" == *\"* || "$SYMBOL" == *\"* ]]; then
  echo "Error: NAME and SYMBOL cannot contain double quotes when using sncast --arguments." >&2
  exit 1
fi

echo "Building contracts with scarb..."
scarb build

mkdir -p deployments
TS=$(date +%s)
DEPLOY_LOG="deployments/tiddy-mun-$TS.txt"
ARGS="\"$NAME\", \"$SYMBOL\", $OWNER, $MINTER_ADDRESS"

deploy_cmd=(
  sncast
  --profile "$SNCAST_PROFILE"
  --wait
  deploy
  --contract-name tiddy_mun_nft
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
  echo "dry_run=$DRY_RUN"
  echo "deploy_command=${deploy_cmd[*]}"
} > "$DEPLOY_LOG"

echo "Deploying tiddy_mun_nft with sncast profile '$SNCAST_PROFILE'..."
DEPLOY_OUTPUT=$("${deploy_cmd[@]}" 2>&1)
echo "$DEPLOY_OUTPUT"
printf '%s\n' "$DEPLOY_OUTPUT" >> "$DEPLOY_LOG"

CONTRACT_ADDRESS=$(printf '%s\n' "$DEPLOY_OUTPUT" | sed -n 's/.*contract_address: *//p' | tail -1)
TRANSACTION_HASH=$(printf '%s\n' "$DEPLOY_OUTPUT" | sed -n 's/.*transaction_hash: *//p' | tail -1)

if [[ "$DRY_RUN" != "1" && "$DRY_RUN" != "true" ]]; then
  if [ -z "${CONTRACT_ADDRESS:-}" ] || [ -z "${TRANSACTION_HASH:-}" ]; then
    echo "Error: failed to extract deployed contract address or transaction hash." >&2
    echo "Wrote deploy output to: $DEPLOY_LOG" >&2
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
