# Beasts NFT Collection

<div align="center">

![Beasts Banner](https://img.shields.io/badge/Beasts-Fully%20Onchain%20NFTs-8B0000?style=for-the-badge)
[![Cairo](https://img.shields.io/badge/Cairo-2.11.4-orange?style=flat-square)](https://github.com/starkware-libs/cairo)
[![Starknet](https://img.shields.io/badge/Starknet-Mainnet-blue?style=flat-square)](https://starknet.io)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Coverage](https://img.shields.io/badge/coverage-84.3%25-brightgreen?style=flat-square)](https://codecov.io/gh/Provable-Games/beasts-g2)

</div>

**Beasts** is a fully onchain NFT collection featuring 75 unique monster species that integrate with the [Loot Survivor](https://survivor.realms.world) game ecosystem on Starknet. Each beast is dynamically generated with unique attributes, names, and stunning SVG artwork—all stored and rendered directly from the blockchain.

## 🎨 Example Beasts

<div align="center">
<table>
<tr>
<td align="center">

### Magical Beast
```svg
<svg xmlns='http://www.w3.org/2000/svg' width='250' height='350' viewBox='0 0 250 350'>
  <defs>
    <linearGradient id='bg1' x1='0%' y1='0%' x2='0%' y2='100%'>
      <stop offset='0%' style='stop-color:#2d1b69;stop-opacity:1' />
      <stop offset='100%' style='stop-color:#0f0c29;stop-opacity:1' />
    </linearGradient>
  </defs>
  <rect width='250' height='350' fill='url(#bg1)'/>
  <rect x='10' y='10' width='230' height='330' fill='none' stroke='#FFD700' stroke-width='3' rx='10'/>
  <text x='125' y='35' font-family='Arial' font-size='18' font-weight='bold' text-anchor='middle' fill='#FFD700'>Doom Shadow Warlock</text>
  <circle cx='125' cy='150' r='60' fill='#4B0082' opacity='0.8'/>
  <path d='M 125 90 L 105 130 L 145 130 Z' fill='#8B008B'/>
  <circle cx='110' cy='140' r='8' fill='#FF00FF'/>
  <circle cx='140' cy='140' r='8' fill='#FF00FF'/>
  <path d='M 115 160 Q 125 170 135 160' stroke='#DDA0DD' stroke-width='2' fill='none'/>
  <text x='125' y='240' font-family='Arial' font-size='14' text-anchor='middle' fill='#ffffff'>🔮 Magical • Tier 5</text>
  <text x='125' y='260' font-family='Arial' font-size='12' text-anchor='middle' fill='#ffffff'>Level: 99 | Health: 512</text>
</svg>
```

</td>
<td align="center">

### Hunter Beast
```svg
<svg xmlns='http://www.w3.org/2000/svg' width='250' height='350' viewBox='0 0 250 350'>
  <defs>
    <linearGradient id='bg2' x1='0%' y1='0%' x2='0%' y2='100%'>
      <stop offset='0%' style='stop-color:#1e3c26;stop-opacity:1' />
      <stop offset='100%' style='stop-color:#0a1f10;stop-opacity:1' />
    </linearGradient>
  </defs>
  <rect width='250' height='350' fill='url(#bg2)'/>
  <rect x='10' y='10' width='230' height='330' fill='none' stroke='#C0C0C0' stroke-width='3' rx='10'/>
  <text x='125' y='35' font-family='Arial' font-size='18' font-weight='bold' text-anchor='middle' fill='#C0C0C0'>Rage Claw Griffin</text>
  <ellipse cx='125' cy='150' rx='70' ry='50' fill='#228B22' opacity='0.8'/>
  <path d='M 85 150 L 65 130 M 85 150 L 65 170' stroke='#32CD32' stroke-width='4' stroke-linecap='round'/>
  <path d='M 165 150 L 185 130 M 165 150 L 185 170' stroke='#32CD32' stroke-width='4' stroke-linecap='round'/>
  <circle cx='105' cy='140' r='6' fill='#00FF00'/>
  <circle cx='145' cy='140' r='6' fill='#00FF00'/>
  <path d='M 125 160 L 115 170 L 135 170 Z' fill='#006400'/>
  <text x='125' y='240' font-family='Arial' font-size='14' text-anchor='middle' fill='#ffffff'>🏹 Hunter • Tier 3</text>
  <text x='125' y='260' font-family='Arial' font-size='12' text-anchor='middle' fill='#ffffff'>Level: 45 | Health: 256</text>
</svg>
```

</td>
<td align="center">

### Brute Beast
```svg
<svg xmlns='http://www.w3.org/2000/svg' width='250' height='350' viewBox='0 0 250 350'>
  <defs>
    <linearGradient id='bg3' x1='0%' y1='0%' x2='0%' y2='100%'>
      <stop offset='0%' style='stop-color:#4a0e0e;stop-opacity:1' />
      <stop offset='100%' style='stop-color:#1a0505;stop-opacity:1' />
    </linearGradient>
  </defs>
  <rect width='250' height='350' fill='url(#bg3)'/>
  <rect x='10' y='10' width='230' height='330' fill='none' stroke='#CD853F' stroke-width='3' rx='10'/>
  <text x='125' y='35' font-family='Arial' font-size='18' font-weight='bold' text-anchor='middle' fill='#CD853F'>Blood Iron Minotaur</text>
  <rect x='75' y='100' width='100' height='100' rx='20' fill='#8B0000' opacity='0.8'/>
  <path d='M 95 120 L 85 90 M 155 120 L 165 90' stroke='#DC143C' stroke-width='6' stroke-linecap='round'/>
  <circle cx='105' cy='140' r='10' fill='#FF0000'/>
  <circle cx='145' cy='140' r='10' fill='#FF0000'/>
  <rect x='115' y='165' width='20' height='15' fill='#8B0000'/>
  <text x='125' y='240' font-family='Arial' font-size='14' text-anchor='middle' fill='#ffffff'>⚔️ Brute • Tier 1</text>
  <text x='125' y='260' font-family='Arial' font-size='12' text-anchor='middle' fill='#ffffff'>Level: 12 | Health: 128</text>
</svg>
```

</td>
</tr>
</table>
</div>

## 🚀 Features

- **🎨 Fully Onchain Artwork**: Every beast's SVG is dynamically generated and stored entirely onchain
- **🎮 Game Integration**: Seamlessly integrates with Loot Survivor gameplay mechanics
- **🔮 Dynamic Metadata**: Each NFT has unique attributes including name prefixes, suffixes, levels, and health
- **⛽ Gas Optimized**: Efficient bit-packing reduces storage costs to just 51 bits per beast
- **🏛️ 75 Unique Species**: From mystical Warlocks to fierce Minotaurs, each with distinct visual traits
- **📊 Tiered Rarity System**: 5 tiers with visual indicators through border colors and effects

## 📦 Installation

### Prerequisites

- [Scarb](https://docs.swmansion.com/scarb/) 2.11.4
- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/) 0.46.0
- [Cairo Coverage](https://github.com/software-mansion/cairo-coverage) 0.5.0 (for test coverage)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/Provable-Games/beasts-g2.git
cd beasts-g2
```

2. Install dependencies:
```bash
scarb build
```

3. Run tests:
```bash
scarb test
```

## 🏗️ Architecture

### Smart Contract Structure

```
src/
├── beasts_nft.cairo          # Main ERC721 contract
├── pack.cairo                # Efficient attribute packing (51 bits)
├── beast_definitions.cairo   # 75 beast species definitions
├── beast_manager.cairo       # Beast validation and management
├── metadata_generator.cairo  # Onchain JSON metadata generation
├── beast_svg.cairo          # Dynamic SVG artwork generation
├── minting_coordinator.cairo # Single and batch minting logic
└── interfaces.cairo         # External contract interfaces
```

### Beast Data Model

Each beast is efficiently packed into 51 bits:

```cairo
PackableBeast {
    id: u8,      // 7 bits - beast species (1-75)
    prefix: u8,  // 7 bits - name prefix (0-69)
    suffix: u8,  // 5 bits - name suffix (0-18)
    level: u16,  // 16 bits - beast level
    health: u16, // 16 bits - beast health
}
```

## 🎮 Beast Types & Tiers

### Beast Types
- **🔮 Magical**: Mystical creatures with arcane powers
- **🏹 Hunter**: Swift and agile predators
- **⚔️ Brute**: Raw strength and physical dominance

### Tier System
- **Tier 1**: Bronze borders (Common)
- **Tier 2**: Silver borders (Uncommon)
- **Tier 3**: Gold borders (Rare)
- **Tier 4**: Platinum borders (Epic)
- **Tier 5**: Prismatic borders (Legendary)

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
scarb test

# Run with coverage
snforge test --coverage
cairo-coverage

# Check coverage percentage (must be ≥84.3%)
lcov --summary coverage/coverage.lcov
```

## 🚢 Deployment

1. Configure environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

2. Deploy to Starknet:
```bash
./scripts/deploy.sh
```

Deployment artifacts are saved to `deployments/` with the latest deployment symlinked.

## 🛠️ Development

### Code Style

- Run formatter before committing:
```bash
scarb fmt
```

### Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-beast`)
3. Ensure tests pass and coverage is maintained (≥84.3%)
4. Commit your changes
5. Push to the branch
6. Open a Pull Request

### CI/CD

The project uses GitHub Actions for:
- Linting (scarb fmt --check)
- Testing with fuzzing
- Coverage verification (≥84.3% required)
- Automatic deployment on merge to main

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Acknowledgments

- [Loot Survivor](https://github.com/Provable-Games/loot-survivor) - The game that Beasts integrates with
- [OpenZeppelin Cairo](https://github.com/OpenZeppelin/cairo-contracts) - Security-audited contract components
- [Starknet](https://starknet.io) - The L2 scaling solution powering Beasts

## 🔗 Links

- [Play Loot Survivor](https://survivor.realms.world)
- [Documentation](https://docs.beasts.game)
- [Discord Community](https://discord.gg/realmsworld)
- [Twitter](https://twitter.com/LootRealms)

---

<div align="center">
  <strong>Built with ❤️ on Starknet</strong>
</div>