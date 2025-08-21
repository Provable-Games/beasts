#!/usr/bin/env bash
set -euo pipefail

# Single deploy script for any network. Configure via .env
# Required in .env: STARKNET_ACCOUNT, STARKNET_PRIVATE_KEY, RPC_URL,
# NAME, SYMBOL, OWNER, ROYALTY_RECEIVER, ROYALTY_FRACTION
# Optional: TERMINAL_TIMESTAMP (u64, defaults to 0), DEATH_MOUNTAIN_ADDRESS (defaults to 0)

# Load environment variables
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
else
  echo "Error: .env file not found. Create one based on .env.example and provide required variables." >&2
  exit 1
fi

# Validate required env vars (no defaults)
: "${STARKNET_ACCOUNT:?STARKNET_ACCOUNT is required in .env}"
: "${STARKNET_PRIVATE_KEY:?STARKNET_PRIVATE_KEY is required in .env}"
: "${RPC_URL:?RPC_URL is required in .env (e.g., Sepolia or Mainnet endpoint)}"
: "${NAME:?NAME is required in .env}"
: "${SYMBOL:?SYMBOL is required in .env}"
: "${OWNER:?OWNER is required in .env (contract owner address)}"
: "${ROYALTY_RECEIVER:?ROYALTY_RECEIVER is required in .env}"
: "${ROYALTY_FRACTION:?ROYALTY_FRACTION is required in .env (u128, denominator 10,000)}"
: "${TERMINAL_TIMESTAMP:?TERMINAL_TIMESTAMP is required in .env (u64, default 0)}"

echo "Using RPC_URL=$RPC_URL"

# Optional config defaults
DEATH_MOUNTAIN_ADDRESS=${DEATH_MOUNTAIN_ADDRESS:-0}

# Ensure required tools are available
command -v scarb >/dev/null 2>&1 || { echo >&2 "Error: scarb is required but not installed."; exit 1; }
command -v starkli >/dev/null 2>&1 || { echo >&2 "Error: starkli is required but not installed."; exit 1; }

# Basic input validation to catch common errors early
if ! [[ "$ROYALTY_FRACTION" =~ ^[0-9]+$ ]]; then
  echo "Error: ROYALTY_FRACTION must be a decimal integer (u128). Got: '$ROYALTY_FRACTION'" >&2
  exit 1
fi
if ! [[ "$TERMINAL_TIMESTAMP" =~ ^[0-9]+$ ]]; then
  echo "Error: TERMINAL_TIMESTAMP must be a decimal integer (u64). Got: '$TERMINAL_TIMESTAMP'" >&2
  exit 1
fi
for addr_var in OWNER ROYALTY_RECEIVER; do
  val=${!addr_var}
  if ! [[ "$val" =~ ^0x[0-9a-fA-F]+$ ]]; then
    echo "Error: $addr_var must be a 0x-prefixed hex address. Got: '$val'" >&2
    exit 1
  fi
done

# Validate optional DEATH_MOUNTAIN_ADDRESS if provided
if [[ -n "$DEATH_MOUNTAIN_ADDRESS" && "$DEATH_MOUNTAIN_ADDRESS" != "0" ]]; then
  if ! [[ "$DEATH_MOUNTAIN_ADDRESS" =~ ^0x[0-9a-fA-F]+$ ]]; then
    echo "Error: DEATH_MOUNTAIN_ADDRESS must be 0 or a 0x-prefixed hex address. Got: '$DEATH_MOUNTAIN_ADDRESS'" >&2
    exit 1
  fi
fi

# Build the project
echo "Building contracts with scarb..."
scarb build

# Prepare deployments log
mkdir -p deployments
TS=$(date +%s)
DEPLOY_LOG="deployments/log-$TS.txt"
{
  echo "timestamp=$TS"
  echo "rpc_url=$RPC_URL"
  echo "name=$NAME"
  echo "symbol=$SYMBOL"
} > "$DEPLOY_LOG"

# Helper: declare and deploy a contract_class.json
declare_and_deploy() {
  local artifact_path=$1
  local label=$2

  echo "Declaring $label... ($artifact_path)" >&2
  local declare_output class_hash deploy_output deployed_address
  declare_output=$(starkli declare --watch --account "$STARKNET_ACCOUNT" --private-key "$STARKNET_PRIVATE_KEY" --rpc "$RPC_URL" "$artifact_path" 2>&1 || true)
  echo "$declare_output" >&2

  # Extract last 0x... which should be the class hash
  class_hash=$(echo "$declare_output" | grep -oE "0x[0-9a-fA-F]+" | tail -1)
  if [ -z "${class_hash:-}" ]; then
    echo "Error: Failed to extract class hash for $label" >&2
    exit 1
  fi

  sleep 9
  echo "Deploying $label... (class_hash=$class_hash)" >&2
  deploy_output=$(starkli deploy --watch --account "$STARKNET_ACCOUNT" --private-key "$STARKNET_PRIVATE_KEY" --rpc "$RPC_URL" "$class_hash" 2>&1 || true)
  echo "$deploy_output" >&2

  # Extract the address from the explicit success marker
  deployed_address=$(echo "$deploy_output" | awk '/^Contract deployed:/{getline; print $0}' | tail -1)
  if [ -z "${deployed_address:-}" ]; then
    echo "Error: Failed to extract deployed address for $label. Full output:" >&2
    echo "$deploy_output" >&2
    exit 1
  fi

  echo "$label deployed at: $deployed_address" >&2
  echo "$deployed_address"
}

# 1) Declare + deploy image data provider contracts
REGULAR_PNG_PROVIDER=$(declare_and_deploy target/dev/beasts_nft_beast_png_regular_data.contract_class.json "beast_png_regular_data")
sleep 9
SHINY_PNG_PROVIDER=$(declare_and_deploy target/dev/beasts_nft_beast_png_shiny_data.contract_class.json "beast_png_shiny_data")
sleep 9
REGULAR_GIF_PROVIDER=$(declare_and_deploy target/dev/beasts_nft_beast_gif_regular_data.contract_class.json "beast_gif_regular_data")
sleep 9
SHINY_GIF_PROVIDER=$(declare_and_deploy target/dev/beasts_nft_beast_gif_shiny_data.contract_class.json "beast_gif_shiny_data")
sleep 9

echo "Regular PNG provider: $REGULAR_PNG_PROVIDER"
echo "Shiny   PNG provider: $SHINY_PNG_PROVIDER"
echo "Regular GIF provider: $REGULAR_GIF_PROVIDER"
echo "Shiny   GIF provider: $SHINY_GIF_PROVIDER"

# Write provider addresses to log
{
  echo "regular_png_provider=$REGULAR_PNG_PROVIDER"
  echo "shiny_png_provider=$SHINY_PNG_PROVIDER"
  echo "regular_gif_provider=$REGULAR_GIF_PROVIDER"
  echo "shiny_gif_provider=$SHINY_GIF_PROVIDER"
} >> "$DEPLOY_LOG"

# 2) Declare + deploy core NFT contract, wiring in provider addresses to constructor
echo "Declaring beasts_nft..."
DECLARE_OUTPUT=$(starkli declare --watch --account "$STARKNET_ACCOUNT" --private-key "$STARKNET_PRIVATE_KEY" --rpc "$RPC_URL" target/dev/beasts_nft_beasts_nft.contract_class.json 2>&1 || true)
echo "$DECLARE_OUTPUT"

CLASS_HASH=$(echo "$DECLARE_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)
if [ -z "$CLASS_HASH" ]; then
    echo "Error: Failed to extract class hash for beasts_nft"
    echo "Declare output: $DECLARE_OUTPUT"
    exit 1
fi

sleep 9
echo "Deploying beasts_nft..."
# Compose the exact deploy command (private key intentionally omitted for safety)
NFT_DEPLOY_CMD="starkli deploy --watch --account \"$STARKNET_ACCOUNT\" --rpc \"$RPC_URL\" \"$CLASS_HASH\" \\
    bytearray:str:\"$NAME\" \\
    bytearray:str:\"$SYMBOL\" \\
    \"$OWNER\" \\
    \"$ROYALTY_RECEIVER\" \\
    \"$ROYALTY_FRACTION\" \\
    \"$REGULAR_PNG_PROVIDER\" \\
    \"$SHINY_PNG_PROVIDER\" \\
    \"$REGULAR_GIF_PROVIDER\" \\
    \"$SHINY_GIF_PROVIDER\" \\
    \"$DEATH_MOUNTAIN_ADDRESS\" \\
    \"$TERMINAL_TIMESTAMP\""
echo "NFT deploy command (no key): $NFT_DEPLOY_CMD"
DEPLOY_OUTPUT=$(starkli deploy --watch --account "$STARKNET_ACCOUNT" --private-key "$STARKNET_PRIVATE_KEY" --rpc "$RPC_URL" "$CLASS_HASH" \
    bytearray:str:"$NAME" \
    bytearray:str:"$SYMBOL" \
    "$OWNER" \
    "$ROYALTY_RECEIVER" \
    "$ROYALTY_FRACTION" \
    "$REGULAR_PNG_PROVIDER" \
    "$SHINY_PNG_PROVIDER" \
    "$REGULAR_GIF_PROVIDER" \
    "$SHINY_GIF_PROVIDER" \
    "$DEATH_MOUNTAIN_ADDRESS" \
    "$TERMINAL_TIMESTAMP" 2>&1 || true)

echo "$DEPLOY_OUTPUT"

DEPLOYED_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)
if [ -z "$DEPLOYED_ADDRESS" ]; then
  echo "Error: Failed to extract deployed address for beasts_nft" >&2
  exit 1
fi

echo "Deployment successful!"
echo "Contract Address: $DEPLOYED_ADDRESS"
echo "Class Hash: $CLASS_HASH"
echo "Providers:"
echo "  REGULAR_PNG_PROVIDER=$REGULAR_PNG_PROVIDER"
echo "  SHINY_PNG_PROVIDER=$SHINY_PNG_PROVIDER"
echo "  REGULAR_GIF_PROVIDER=$REGULAR_GIF_PROVIDER"
echo "  SHINY_GIF_PROVIDER=$SHINY_GIF_PROVIDER"

# Append NFT deployment info to log
{
  echo "nft_address=$DEPLOYED_ADDRESS"
  echo "nft_deploy_cmd=$NFT_DEPLOY_CMD"
  echo "terminal_timestamp=$TERMINAL_TIMESTAMP"
  echo "death_mountain_address=$DEATH_MOUNTAIN_ADDRESS"
} >> "$DEPLOY_LOG"

echo "Wrote deployment log to: $DEPLOY_LOG"
