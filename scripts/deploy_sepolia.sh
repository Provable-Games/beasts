#!/bin/bash
set -e

source .env

# Build the project
scarb build

# Constructor parameters
NAME="Beasts"
SYMBOL="BEAST"
BASE_URI="https://api.beasts.game/metadata/"
OWNER="0x418ed348930686c844fda4556173457d3f71ae547262406d271de534af6b35e"
ROYALTY_RECEIVER="0x418ed348930686c844fda4556173457d3f71ae547262406d271de534af6b35e"
ROYALTY_FRACTION="500"


# Contract class declaration
echo "Starting contract declaration..."
DECLARE_OUTPUT=$(starkli declare --account "$STARKNET_ACCOUNT" --private-key $STARKNET_PRIVATE_KEY --rpc https://api.cartridge.gg/x/starknet/sepolia target/dev/beasts_nft_beasts_nft.contract_class.json 2>&1)
echo "Declare output: $DECLARE_OUTPUT"

CLASS_HASH=$(echo "$DECLARE_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)

if [ -z "$CLASS_HASH" ]; then
    echo "Error: Failed to extract class hash"
    echo "Declare output: $DECLARE_OUTPUT"
    exit 1
fi

# Contract deployment
DEPLOY_OUTPUT=$(starkli deploy --account "$STARKNET_ACCOUNT" --private-key $STARKNET_PRIVATE_KEY --rpc https://api.cartridge.gg/x/starknet/sepolia $CLASS_HASH \
    bytearray:str:"$NAME" \
    bytearray:str:"$SYMBOL" \
    bytearray:str:"$BASE_URI" \
    $OWNER \
    $ROYALTY_RECEIVER \
    $ROYALTY_FRACTION 2>&1)

DEPLOYED_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)

echo "Deployment successful!"
echo "Contract Address: $DEPLOYED_ADDRESS"
echo "Class Hash: $CLASS_HASH"