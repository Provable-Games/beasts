# Beasts NFT Deployment Scripts

## Prerequisites

1. Install starkli:
```bash
curl https://get.starkli.sh | sh
starkliup
```

2. Set up your account and keystore:
```bash
# Create a new keystore
starkli signer keystore new ~/.starkli-wallets/deployer/keystore.json

# Deploy a new account (if needed)
starkli account oz init ~/.starkli-wallets/deployer/account.json
starkli account deploy ~/.starkli-wallets/deployer/account.json
```

## Usage

### Basic deployment (Sepolia testnet)

```bash
./scripts/deploy.sh \
  --recipient 0x123...abc \
  --owner 0x456...def
```

### Custom deployment with all options

```bash
./scripts/deploy.sh \
  --network sepolia \
  --name "My Beasts Collection" \
  --symbol "MYBEAST" \
  --base-uri "https://api.myproject.com/beasts/" \
  --recipient 0x123...abc \
  --token-ids "1,2,3,10,20,30" \
  --owner 0x456...def
```

### Mainnet deployment

```bash
# Set your Infura API key
export INFURA_API_KEY=your_api_key_here

./scripts/deploy.sh \
  --network mainnet \
  --recipient 0x123...abc \
  --owner 0x456...def
```

## Environment Variables

- `STARKNET_NETWORK`: Network to deploy to (mainnet/sepolia)
- `STARKNET_ACCOUNT`: Path to account JSON file
- `STARKNET_KEYSTORE`: Path to keystore JSON file
- `INFURA_API_KEY`: Required for mainnet deployments

## Deployment Parameters

- `--name`: NFT collection name (default: "Beasts")
- `--symbol`: NFT collection symbol (default: "BEAST")
- `--base-uri`: Base URI for token metadata (default: "https://api.beasts.game/metadata/")
- `--owner`: Contract owner address (required)

## Deployment Output

Deployment information is saved to:
- `deployments/<network>_beasts_nft_<timestamp>.json`
- `deployments/<network>_beasts_nft_latest.json` (symlink to latest)

## Troubleshooting

1. **Account not found**: Make sure your account JSON file exists at the specified path
2. **Keystore error**: Ensure you've created a keystore and it's accessible
3. **Insufficient funds**: Fund your account with ETH for gas fees
4. **Network errors**: Check your RPC endpoint is accessible