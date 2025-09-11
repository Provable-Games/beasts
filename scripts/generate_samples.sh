#!/usr/bin/env bash
set -euo pipefail

# Generates sample outputs for all beasts and variants.
# - Deploys contracts with OWNER set to STARKNET_ACCOUNT
# - Sets minter to STARKNET_ACCOUNT
# - Mints 4 variants for each of the 75 beasts
# - Calls token_uri for each token (75 genesis + 300 minted = 375)
# - Decodes the image data URI to SVG and writes files to sample_outputs/

# Load environment
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
else
  echo "Error: .env file not found. Copy .env.example to .env and fill required fields." >&2
  exit 1
fi

# Check required tools
command -v starkli >/dev/null 2>&1 || { echo >&2 "Error: starkli is required."; exit 1; }
command -v scarb >/dev/null 2>&1 || { echo >&2 "Error: scarb is required."; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo >&2 "Error: python3 is required."; exit 1; }

# Required env vars
: "${STARKNET_ACCOUNT:?STARKNET_ACCOUNT is required in .env}"
: "${STARKNET_PRIVATE_KEY:?STARKNET_PRIVATE_KEY is required in .env}"
: "${RPC_URL:?RPC_URL is required in .env}"
: "${NAME:?NAME is required in .env}"
: "${SYMBOL:?SYMBOL is required in .env}"
: "${ROYALTY_RECEIVER:?ROYALTY_RECEIVER is required in .env}"
: "${ROYALTY_FRACTION:?ROYALTY_FRACTION is required in .env}"

echo "Generating samples on RPC=$RPC_URL"

# Deploy using deploy.sh (OWNER should be configured in .env as your account address)
#bash scripts/deploy.sh

# Fetch NFT address from latest log
LOG_FILE=$(ls -1 deployments/log-*.txt | sort | tail -1)
if [ -z "${LOG_FILE:-}" ] || [ ! -f "$LOG_FILE" ]; then
  echo "Error: deployment log not found. Did deploy.sh run successfully?" >&2
  exit 1
fi

#NFT_ADDRESS=$(grep '^nft_address=' "$LOG_FILE" | cut -d= -f2)
NFT_ADDRESS=0x07febf3012ae53c13baa780dd1f90a139fadd1a264d2acd340f6114e02d0b2d6

if [ -z "${NFT_ADDRESS:-}" ]; then
  echo "Error: nft_address not found in $LOG_FILE" >&2
  exit 1
fi
echo "Using NFT at $NFT_ADDRESS"

# Determine minter/recipient address: default to OWNER if MINTER_ADDRESS not set
MINTER_ADDRESS=${MINTER_ADDRESS:-$OWNER}
if ! [[ "$MINTER_ADDRESS" =~ ^0x[0-9a-fA-F]+$ ]]; then
  echo "Error: MINTER_ADDRESS must be a 0x-prefixed hex address (set MINTER_ADDRESS or ensure OWNER is set to an address). Got: '$MINTER_ADDRESS'" >&2
  exit 1
fi

# Set minter to our account address (not the path used by --account)
echo "Setting minter to $MINTER_ADDRESS..."
starkli invoke --watch --account "$STARKNET_ACCOUNT" --private-key "$STARKNET_PRIVATE_KEY" --rpc "$RPC_URL" "$NFT_ADDRESS" set_minter "$MINTER_ADDRESS" >/dev/null

# Helper: check if (beast_id, prefix, suffix) is already minted
is_minted() {
  local bid=$1 pre=$2 suf=$3
  local out
  out=$(starkli call --rpc "$RPC_URL" "$NFT_ADDRESS" is_minted "$bid" "$pre" "$suf" 2>&1 || true)
  if echo "$out" | grep -qiE '\btrue\b|\b0x1\b|\b1\b'; then
    return 0
  fi
  return 1
}

# Mint 4 variants for each beast id 1..75
echo "Minting 4 variants for each beast..."
for bid in $(seq 1 75); do
  # Variants: (shiny, animated) in [(1,1),(0,1),(1,0),(0,0)]
  for variant in 11 01 10 00; do
    shiny=${variant:0:1}
    animated=${variant:1:1}

    # Derive starting prefix/suffix and vary if taken
    prefix=$(( (bid + (10 * shiny) + (3 * animated)) % 70 ))
    suffix=$(( (bid + (7 * shiny) + (5 * animated)) % 19 ))
    tries=0
    while is_minted "$bid" "$prefix" "$suffix"; do
      prefix=$(( (prefix + 1) % 70 ))
      if [ $((++tries)) -gt 100 ]; then
        echo "Warning: too many attempts to find unique prefix/suffix for beast_id=$bid; skipping" >&2
        break
      fi
    done

    # Varied level/health; avoid bash ternary by precomputing
    add_anim=0; if [ "$animated" -eq 1 ]; then add_anim=1; fi
    level=$(( 1 + (bid % 20) + add_anim ))
    health=$(( 10 + ((bid * (shiny + 1) + 7 + (animated * 3)) % 100) ))

    echo "mint -> beast=$bid prefix=$prefix suffix=$suffix level=$level health=$health shiny=$shiny animated=$animated"
    starkli invoke --watch --account "$STARKNET_ACCOUNT" --private-key "$STARKNET_PRIVATE_KEY" --rpc "$RPC_URL" \
      "$NFT_ADDRESS" mint "$MINTER_ADDRESS" "$bid" "$prefix" "$suffix" "$level" "$health" "$shiny" "$animated" >/dev/null
  done
done

# Determine total supply (u256 -> assume small, use low limb only)
# raw_total=$(starkli call --rpc "$RPC_URL" "$NFT_ADDRESS" total_supply || true)
# # Extract first 0x-hex token from output without using a pipe (avoid pipefail issues)
# low_hex=$(awk '{ for (i=1;i<=NF;i++) if ($i ~ /^0x[0-9a-fA-F]+$/) { print $i; exit } }' <<< "$raw_total")
# if [ -z "$low_hex" ]; then
#   TOTAL_SUPPLY=0
# else
#   TOTAL_SUPPLY=$((16#${low_hex#0x}))
# fi
# echo "Total supply: $TOTAL_SUPPLY"

TOTAL_SUPPLY=375
mkdir -p sample_outputs

echo "Fetching token_uri and writing SVGs to sample_outputs/ ..."
for ((tid=1; tid<=TOTAL_SUPPLY; tid++)); do
  out=$(starkli call --rpc "$RPC_URL" "$NFT_ADDRESS" token_uri "$tid" 0 || true)
  python3 - "$tid" <<'PY' <<< "$out"
import sys, re, json, base64, os

tid = int(sys.argv[1])
raw = sys.stdin.read().strip()

# Reconstruct the data URI from Cairo's hex array response
uri = ''
try:
    arr = json.loads(raw)
    if isinstance(arr, list) and len(arr) >= 2:
        total_len = int(str(arr[0]), 16)
        buf = bytearray()
        for h in arr[1:]:
            hs = str(h)
            if hs.startswith('0x'):
                hs = hs[2:]
            if len(hs) % 2 == 1:
                hs = '0' + hs
            # Pad each limb to 32 bytes (64 hex chars), then append; trim at total_len later
            hs = hs.rjust(64, '0')
            buf.extend(bytes.fromhex(hs))
        uri = bytes(buf[:total_len]).decode('utf-8', errors='ignore')
    else:
        uri = raw
except Exception:
    uri = raw

# Extract metadata from data URI
m = re.search(r'data:application/json;base64,([A-Za-z0-9A-Za-z_\-/+=]+)', uri)
if not m:
    sys.exit(0)
meta_b64 = m.group(1)
# Normalize potential URL-safe base64 and add padding if missing
meta_b64 = meta_b64.replace('-', '+').replace('_', '/')
meta_b64 += '=' * ((4 - (len(meta_b64) % 4)) % 4)
meta_json = base64.b64decode(meta_b64).decode('utf-8', errors='ignore')
try:
    meta = json.loads(meta_json)
except Exception:
    sys.exit(0)

image = meta.get('image','')
am = re.search(r'data:image/svg\+xml;base64,([A-Za-z0-9A-Za-z_\-/+=]+)', image)
if not am:
    sys.exit(0)
svg_b64 = am.group(1)
svg_b64 = svg_b64.replace('-', '+').replace('_', '/')
svg_b64 += '=' * ((4 - (len(svg_b64) % 4)) % 4)
svg_bytes = base64.b64decode(svg_b64)

# Infer beast name and variant flags from attributes
beast_name = f"beast_{tid}"
shiny_flag = 'not_shiny'
animated_flag = 'not_animated'
for attr in meta.get('attributes', []):
    if str(attr.get('trait_type','')).lower() == 'beast':
        beast_name = str(attr.get('value','beast')).lower().replace(' ', '_')
    if str(attr.get('trait_type','')).lower() == 'shiny':
        shiny_flag = 'shiny' if str(attr.get('value','0')) in ('1','true','True') else 'not_shiny'
    if str(attr.get('trait_type','')).lower() == 'animated':
        animated_flag = 'animated' if str(attr.get('value','0')) in ('1','true','True') else 'not_animated'

fname = f"sample_outputs/{beast_name}_{shiny_flag}_{animated_flag}.svg"
with open(fname,'wb') as f:
    f.write(svg_bytes)
print(f"wrote {fname}")
PY
done

echo "Done. See sample_outputs/ for generated SVGs."
