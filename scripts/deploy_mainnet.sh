#!/bin/bash
set -e

source .env

# Build the project
scarb build

# Constructor parameters
NAME="Beasts"
SYMBOL="BEAST"
BASE_URI="https://api.beasts.game/metadata/"
OWNER=$(jq -r '.deployment.address' $STARKNET_ACCOUNT)

# Set RPC URL
export STARKNET_RPC=https://api.cartridge.gg/x/starknet/mainnet

# Contract class declaration
DECLARE_OUTPUT=$(starkli declare --account "$STARKNET_ACCOUNT" --private-key $STARKNET_PRIVATE_KEY target/dev/beasts_BeastsNft.contract_class.json 2>&1)

CLASS_HASH=$(echo "$DECLARE_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)

# Contract deployment
DEPLOY_OUTPUT=$(starkli deploy --account "$STARKNET_ACCOUNT" --private-key $STARKNET_PRIVATE_KEY $CLASS_HASH \
    bytearray:str:"$NAME" \
    bytearray:str:"$SYMBOL" \
    bytearray:str:"$BASE_URI" \
    $OWNER 2>&1)

DEPLOYED_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)

echo "Deployment successful!"
echo "Contract Address: $DEPLOYED_ADDRESS"
echo "Class Hash: $CLASS_HASH"