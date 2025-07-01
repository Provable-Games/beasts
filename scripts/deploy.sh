#!/bin/bash
# Deployment script for Beasts NFT contract on Starknet

# Exit on error
set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo -e "${YELLOW}Loading environment variables from .env file...${NC}"
    export $(grep -v '^#' .env | xargs)
elif [ -f ../.env ]; then
    echo -e "${YELLOW}Loading environment variables from ../.env file...${NC}"
    export $(grep -v '^#' ../.env | xargs)
fi

# Configuration
CONTRACT_NAME="beasts_nft"
NETWORK="${STARKNET_NETWORK:-sepolia}"

# Constructor arguments
NAME="${BEASTS_NAME:-Beasts}"
SYMBOL="${BEASTS_SYMBOL:-BEAST}"
BASE_URI="${BEASTS_BASE_URI:-https://api.beasts.game/metadata/}"
RECIPIENT="${BEASTS_RECIPIENT}"
TOKEN_IDS="${BEASTS_TOKEN_IDS:-1,2,3,4,5}"  # Default: mint 5 tokens
OWNER="${BEASTS_OWNER}"

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  --network NETWORK       Network to deploy to (mainnet|sepolia) [default: sepolia]"
    echo "  --name NAME             NFT collection name [default: Beasts]"
    echo "  --symbol SYMBOL         NFT collection symbol [default: BEAST]"
    echo "  --base-uri URI          Base URI for token metadata [default: https://api.beasts.game/metadata/]"
    echo "  --recipient ADDRESS     Address to receive initial NFTs (required)"
    echo "  --token-ids IDS         Comma-separated token IDs to mint [default: 1,2,3,4,5]"
    echo "  --owner ADDRESS         Contract owner address (required)"
    echo ""
    echo "Environment variables (can be set in .env file):"
    echo "  STARKNET_NETWORK        Network to deploy to"
    echo "  STARKNET_ACCOUNT        Path to account JSON file"
    echo "  STARKNET_KEYSTORE       Path to keystore JSON file (use this OR private key)"
    echo "  STARKNET_PRIVATE_KEY    Raw private key (use this OR keystore)"
    echo "  STARKNET_RPC            Custom RPC URL (overrides network defaults)"
    echo "  INFURA_API_KEY          API key for Infura (required for mainnet)"
    echo "  BEASTS_NAME             NFT collection name"
    echo "  BEASTS_SYMBOL           NFT collection symbol"
    echo "  BEASTS_BASE_URI         Base URI for token metadata"
    echo "  BEASTS_RECIPIENT        Address to receive initial NFTs"
    echo "  BEASTS_TOKEN_IDS        Comma-separated token IDs to mint"
    echo "  BEASTS_OWNER            Contract owner address"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        --network)
            NETWORK="$2"
            shift 2
            ;;
        --name)
            NAME="$2"
            shift 2
            ;;
        --symbol)
            SYMBOL="$2"
            shift 2
            ;;
        --base-uri)
            BASE_URI="$2"
            shift 2
            ;;
        --recipient)
            RECIPIENT="$2"
            shift 2
            ;;
        --token-ids)
            TOKEN_IDS="$2"
            shift 2
            ;;
        --owner)
            OWNER="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "$RECIPIENT" ]; then
    echo -e "${RED}Error: Recipient address is required${NC}"
    echo "Set BEASTS_RECIPIENT in your .env file or use --recipient flag"
    usage
fi

if [ -z "$OWNER" ]; then
    echo -e "${RED}Error: Owner address is required${NC}"
    echo "Set BEASTS_OWNER in your .env file or use --owner flag"
    usage
fi

# Set RPC based on network or use custom RPC
if [ -n "$STARKNET_RPC" ]; then
    # Use custom RPC from environment
    RPC_URL="$STARKNET_RPC"
    echo -e "${YELLOW}Using custom RPC URL from environment${NC}"
elif [ "$NETWORK" = "mainnet" ]; then
    if [ -z "$INFURA_API_KEY" ]; then
        echo -e "${RED}Error: INFURA_API_KEY is required for mainnet deployment${NC}"
        echo "Set INFURA_API_KEY in your .env file"
        exit 1
    fi
    RPC_URL="https://starknet-mainnet.infura.io/v3/${INFURA_API_KEY}"
elif [ "$NETWORK" = "sepolia" ]; then
    RPC_URL="https://starknet-sepolia.public.blastapi.io/rpc/v0_7"
else
    echo -e "${RED}Error: Unknown network: $NETWORK${NC}"
    echo "Supported networks: mainnet, sepolia"
    exit 1
fi

# Export environment variables
export STARKNET_RPC=$RPC_URL
export STARKNET_ACCOUNT="${STARKNET_ACCOUNT:-~/.starkli-wallets/deployer/account.json}"

# Check if using private key or keystore
if [ -n "$STARKNET_PRIVATE_KEY" ]; then
    # Using private key
    AUTH_METHOD="--private-key $STARKNET_PRIVATE_KEY"
    AUTH_DISPLAY="Private Key"
else
    # Using keystore
    export STARKNET_KEYSTORE="${STARKNET_KEYSTORE:-~/.starkli-wallets/deployer/keystore.json}"
    AUTH_METHOD=""
    AUTH_DISPLAY="Keystore: $STARKNET_KEYSTORE"
fi

# Display deployment configuration
echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}     Beasts NFT Deployment Script       ${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""
echo -e "Network:          ${GREEN}$NETWORK${NC}"
echo -e "RPC URL:          $RPC_URL"
echo -e "Account:          $STARKNET_ACCOUNT"
echo -e "Auth Method:      $AUTH_DISPLAY"
echo ""
echo -e "${YELLOW}Contract Parameters:${NC}"
echo -e "Name:             $NAME"
echo -e "Symbol:           $SYMBOL"
echo -e "Base URI:         $BASE_URI"
echo -e "Recipient:        $RECIPIENT"
echo -e "Token IDs:        $TOKEN_IDS"
echo -e "Owner:            $OWNER"
echo ""

# Confirm deployment
read -p "Do you want to proceed with deployment? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 0
fi

# Create deployments directory if it doesn't exist
mkdir -p deployments

# Build the contract
echo -e "\n${YELLOW}Building contract...${NC}"
scarb build

# Prepare constructor arguments
echo -e "\n${YELLOW}Preparing constructor arguments...${NC}"

# Convert token IDs array to Cairo format for starkli
convert_token_ids() {
    local ids="$1"
    IFS=',' read -ra ID_ARRAY <<< "$ids"
    local result="${#ID_ARRAY[@]}"  # Array length first
    for id in "${ID_ARRAY[@]}"; do
        # For u256, we need two values (low, high)
        result="$result $id 0"
    done
    echo "$result"
}

TOKEN_IDS_ARRAY=$(convert_token_ids "$TOKEN_IDS")

echo "Name:            $NAME"
echo "Symbol:          $SYMBOL"
echo "Base URI:        $BASE_URI"
echo "Recipient:       $RECIPIENT"
echo "Token IDs:       $TOKEN_IDS_ARRAY"
echo "Owner:           $OWNER"

# Declare the contract
echo -e "\n${YELLOW}Declaring contract...${NC}"
DECLARE_OUTPUT=$(starkli declare target/dev/${CONTRACT_NAME}_${CONTRACT_NAME}.contract_class.json $AUTH_METHOD 2>&1)

# Extract class hash from output
CLASS_HASH=$(echo "$DECLARE_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)

if [ -z "$CLASS_HASH" ]; then
    echo -e "${RED}Error: Failed to extract class hash${NC}"
    echo "Declare output: $DECLARE_OUTPUT"
    exit 1
fi

echo -e "${GREEN}Contract declared with class hash: $CLASS_HASH${NC}"

# Deploy the contract
echo -e "\n${YELLOW}Deploying contract...${NC}"
echo "Constructor arguments:"
echo "  name:       $NAME"
echo "  symbol:     $SYMBOL"
echo "  base_uri:   $BASE_URI"
echo "  recipient:  $RECIPIENT"
echo "  token_ids:  $TOKEN_IDS_ARRAY"
echo "  owner:      $OWNER"

DEPLOY_OUTPUT=$(starkli deploy $CLASS_HASH \
    bytearray:str:"$NAME" \
    bytearray:str:"$SYMBOL" \
    bytearray:str:"$BASE_URI" \
    $RECIPIENT \
    $TOKEN_IDS_ARRAY \
    $OWNER \
    $AUTH_METHOD 2>&1)

# Extract deployed address from output
DEPLOYED_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oE "0x[0-9a-fA-F]+" | tail -1)

if [ -z "$DEPLOYED_ADDRESS" ]; then
    echo -e "${RED}Error: Failed to extract deployed address${NC}"
    echo "Deploy output: $DEPLOY_OUTPUT"
    exit 1
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}    Deployment Successful!              ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Contract Address: ${GREEN}$DEPLOYED_ADDRESS${NC}"
echo -e "Class Hash:       ${GREEN}$CLASS_HASH${NC}"

# Save deployment info
DEPLOYMENT_FILE="deployments/${NETWORK}_${CONTRACT_NAME}_$(date +%Y%m%d_%H%M%S).json"
cat > "$DEPLOYMENT_FILE" << EOF
{
  "network": "$NETWORK",
  "contract_name": "$CONTRACT_NAME",
  "contract_address": "$DEPLOYED_ADDRESS",
  "class_hash": "$CLASS_HASH",
  "constructor_args": {
    "name": "$NAME",
    "symbol": "$SYMBOL",
    "base_uri": "$BASE_URI",
    "recipient": "$RECIPIENT",
    "token_ids": "$TOKEN_IDS",
    "owner": "$OWNER"
  },
  "deployed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

echo -e "\nDeployment info saved to: ${GREEN}$DEPLOYMENT_FILE${NC}"

# Create symlink to latest deployment
ln -sf "$(basename "$DEPLOYMENT_FILE")" "deployments/${NETWORK}_${CONTRACT_NAME}_latest.json"

echo -e "\n${GREEN}Next steps:${NC}"
echo "1. Verify the contract on Voyager or Starkscan"
echo "2. Test the deployed contract by querying token metadata"
echo "3. Transfer ownership if needed"