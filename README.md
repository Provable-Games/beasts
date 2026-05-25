# Beasts NFT Collection

<div align="center">

</div>

**Beasts** is a fully onchain NFT collection featuring 75 unique monster species that integrate with the [Loot Survivor](https://lootsurvivor.io) game ecosystem on Starknet. Each Beast is dynamically generated with unique attributes, names, and artwork—all stored and rendered directly from the blockchain.

## Overview

The Beasts are a collection of digital-native creatures, born onchain and built for battle. Across 75 species, each Beast combines naming, visual, and combat attributes to balance abundance and scarcity. Beasts carry two sets of traits: visual and combat.

- Visual traits power collecting: Shiny and Animated forms activate pixel-perfect effects. Non-genesis Beasts receive live ranking within their species based on power and health, and those rankings update as new Beasts are minted.
- Combat traits power play: On mint, a Beast includes level and health. Together with its type and tier, this defines a combat profile compatible with the Loot Survivor system that first brought Beasts into the world.
- Live, credibly neutral traits such as Adventurers slain, last Adventurer who defeated a Beast, and timestamp of that defeat enable long-term growth systems without hardcoding game logic.
- Beasts are earned by worthy Adventurers in the dungeons of Loot Survivor using verifiable randomness. Every step is etched onchain for permanent provenance. For collectors, Beasts offer verifiable scarcity and provenance; for players, they unlock endless onchain fun.

## 🎨 Example Beasts

<div align="center">
<table>
<tr>
<td align="center">
<!-- Not Shiny, Not Animated -->
<img src="assets/examples/warlock_regular_static.svg" width="250" height="350">

</td>
<td align="center">
<!-- Not Shiny, Animated -->
<img src="assets/examples/warlock_regular_animated.svg" width="250" height="350">

</td>
<td align="center">
<!-- Shiny, Not Animated -->
<img src="assets/examples/warlock_shiny_static.svg" width="250" height="350">

</td>
<td align="center">
<!-- Shiny, Animated -->
<img src="assets/examples/warlock_shiny_animated.svg" width="250" height="350">

</td>

</tr>
</table>
</div>

## 🚀 Features

- **🎨 Fully Onchain Artwork**: Every Beast’s image data and metadata are generated onchain
- **🎮 Born Onchain**: Beasts emerge from the dungeons of Loot Survivor
- **⚔️ Battle-Ready**: Each Beast is minted with level and health and is compatible with the Loot Survivor combat system
- **🏛️ 75 Unique Species**: From mystical Warlocks to fierce Minotaurs, each with distinct visual traits
- **📊 Tiered Rarity System**: 5 tiers with visual indicators through border colors and effects
- **🔐 Deterministic Token IDs**: A Beast’s ERC721 token ID is the packed representation of its species, name parts, combat stats, and visual flags

## 📦 Installation

### Prerequisites

- [Scarb](https://docs.swmansion.com/scarb/) 2.18.0
- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/) 0.60.0
- [Starkli](https://book.starkli.rs/) for deployment
- [Cairo Coverage](https://github.com/software-mansion/cairo-coverage) and [lcov](https://github.com/linux-test-project/lcov) for local coverage reports

Tool versions used by CI are pinned in `.tool-versions`.

### Setup

1. Clone the repository:

```bash
git clone https://github.com/Provable-Games/beasts.git
cd beasts
```

2. Build contracts:

```bash
scarb build
```

3. Run tests:

```bash
snforge test
```

## 🏗️ Architecture

### Smart Contract Structure

```
src/
├── lib.cairo                  # Entry point; exposes modules and ERC721 contract (beasts_nft)
├── beast_definitions.cairo    # 75 species definitions and names
├── beast_manager.cairo        # Validation and uniqueness hashing
├── minting_coordinator.cairo  # Single and batch mint prep
├── beast_ranking.cairo        # Per-species live ranking
├── pack.cairo                 # Attribute packing (id, name parts, level, health, shiny, animated)
├── metadata_generator.cairo   # Onchain JSON metadata generation
├── beast_svg.cairo            # Dynamic SVG artwork generation
├── beast_images.cairo         # Shared image helpers
├── beast_png_*_data.cairo     # PNG image data provider contracts
├── beast_gif_*_data.cairo     # GIF image data provider contracts
├── encoding.cairo             # Encoding helpers
├── utils.cairo                # Shared utilities
└── interfaces.cairo           # External interfaces (image data providers, systems)
```

### Beast Data Model

Each Beast is efficiently packed into 53 bits. The packed value is also the ERC721 `token_id`:

```cairo
PackableBeast {
    id: u8,       // 7 bits - species (1–75)
    prefix: u8,   // 7 bits - name prefix
    suffix: u8,   // 5 bits - name suffix
    level: u16,   // 16 bits - level
    health: u16,  // 16 bits - health
    shiny: u8,    // 1 bit  - visual trait
    animated: u8, // 1 bit  - visual trait
}
```

### Beast Token ID Design

Beasts do not use sequential token IDs. For fresh deployments, every token ID is deterministic:

```text
token_id = encode_token_id(PackableBeast)
```

The bit layout is:

```text
id
+ prefix   * 2^7
+ suffix   * 2^14
+ level    * 2^19
+ health   * 2^35
+ shiny    * 2^51
+ animated * 2^52
```

This keeps every valid Beast token ID below `2^53`, so it fits comfortably in `u256`. The same format is used for genesis and non-genesis Beasts.

Because the token ID is the source of the Beast attributes, contract reads such as `get_beast(token_id)`, `token_uri(token_id)`, and ranking comparisons decode the token ID after verifying ERC721 ownership/existence. There is no separate onchain map from `token_id` to `PackableBeast`.

Genesis Beasts are minted in the constructor to the owner with `prefix = 0`, `suffix = 0`, `level = 1`, `health = 100`, `shiny = 1`, and `animated = 1`. Genesis Beasts have rank `0` and are not entered into the non-genesis uniqueness map. Non-genesis Beast uniqueness is tracked by `(beast_id, prefix, suffix)`, while ranking and metadata refresh state continue to index by packed token ID.

`total_supply()` is a count of minted NFTs, not the largest token ID.

## 🎮 Beast Types & Tiers

### Beast Types

- **🔮 Magical**: Mystical creatures with arcane powers
- **🏹 Hunter**: Swift and agile predators
- **⚔️ Brute**: Raw strength and physical dominance

### Tier System

- **Tier 1**: Orange borders (Legendary) - Most powerful beasts
- **Tier 2**: Purple borders (Epic)
- **Tier 3**: Blue borders (Rare)
- **Tier 4**: Green borders (Uncommon)
- **Tier 5**: White borders (Common) - Entry level beasts

## 🧪 Testing

Run the test suite:

```bash
# Default local run
snforge test

# Match the CI test command
snforge test --max-n-steps 4294967295

# Generate local coverage
snforge test --coverage

# Summarize coverage locally
lcov --summary coverage/coverage.lcov
```

For a longer local pass, use `snforge test --fuzzer-runs 500 --coverage`. CI currently enforces formatting and tests, but not coverage thresholds; aim for >=80% overall coverage when feasible.

## 🚢 Deployment

1. Configure environment variables:

```bash
cp .env.example .env
# Edit .env with your configuration
```

Required in `.env` (no defaults are assumed):

- `STARKNET_ACCOUNT`, `STARKNET_PRIVATE_KEY`
- `RPC_URL` (e.g., Sepolia or Mainnet endpoint)
- `NAME`, `SYMBOL`
- `OWNER`, `ROYALTY_RECEIVER`, `ROYALTY_FRACTION` (u128, denominator 10,000)
- `TERMINAL_TIMESTAMP` (u64): UNIX timestamp in seconds after which `token_uri` is disabled and calls revert. Use `0` to keep `token_uri` active indefinitely.

Optional in `.env`:

- `DEATH_MOUNTAIN_ADDRESS` (ContractAddress, default `0`): external systems integration address; set to `0` to disable.

2. Deploy to Starknet:

```bash
bash scripts/deploy.sh
```

Notes:

- The script declares and deploys the four image data provider contracts, then deploys the core NFT with their addresses passed to the constructor.
- The script fails with a descriptive error if any required `.env` value is missing.
- The deploy script reads `TERMINAL_TIMESTAMP` and `DEATH_MOUNTAIN_ADDRESS` and appends them to the constructor. If `TERMINAL_TIMESTAMP > 0`, after that time, `token_uri` calls revert with `Terminal: token_uri disabled`.

## 🛠️ Development

### Code Style

- Run formatter before committing:

```bash
scarb fmt
scarb fmt --check --workspace
```

### CI/CD

The project uses GitHub Actions for:

- Linting (`scarb fmt --check --workspace`)
- Contract tests (`snforge test --max-n-steps 4294967295`)
- Caching/installing coverage tools for local parity; coverage thresholds are not currently enforced in CI

## 🤝 Acknowledgments

- Beast pixels from the legends at [1337 Skulls](https://1337skulls.xyz)

## 🔗 Links

- [Play Loot Survivor](https://lootsurvivor.io)
- [Discord Community](https://discord.gg/lootsurvivor)
- [Twitter](https://x.com/lootsurvivor)
- [Tiddy Mun NFT](https://voyager.online/contract/0x0202d78ebda24bde4e44434bcfd2b329d6c0dde25eb2b713a8e7c3e8f4e1a8bb)
- [Beast NFT](https://voyager.online/contract/0x046da8955829adf2bda310099a0063451923f02e648cf25a1203aac6335cf0e4)
- [Regular PNG URI](https://voyager.online/contract/0x07bcd91940f5a2640437c764815b6a8a173f09fff991420b691713bebd82f7bf)
- [Shiny PNG URI](https://voyager.online/contract/0x03bdFdEeA997CA7C7b1d66590a541FC559cE5A742e0162fE98Fe371E70709444)
- [Regular GIF URI](https://voyager.online/contract/0x012F11AD850839d27351Bbf49858A3180AdB1C30d9942423FD089F5740776293)
- [Shiny GIF URI](https://voyager.online/contract/0x0700f224e6fcb344c27f29e62687333b589b3be39a2c026ede5968bf53b6bb2a)

## Tiddy Mun Mainnet

- Contract: `0x0202d78ebda24bde4e44434bcfd2b329d6c0dde25eb2b713a8e7c3e8f4e1a8bb`
- Class hash: `0x078d71aeb3bc7d2d4df98b0f11b7a4004a4e22f44a724f47e1c7aed92ba3046e`
- Owner: `0x0245939b4a0a2a05b3721ca530342c61e4291ccd6d71ab829ee7dbe8b6e23bca`
- Minter: `0x0` until the owner enables live minting.
- ABI: `abis/tiddy_mun_nft.json`
- Address manifest: `addresses/tiddy_mun_mainnet.json`
