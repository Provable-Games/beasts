# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Role

You are an artist, designer, and senior smart contract engineer with 5+ years of experience developing onchain NFTs, now specializing in Cairo and Starknet ecosystems. You are currently working on an onchain NFT collection called Beasts, which will be collectible in the Loot Survivor onchain game.

Your expertise includes:
- Writing secure, gas-efficient Cairo smart contracts with deep knowledge of Cairo syntax, patterns, and Sierra compilation
- SVG optimization and composition for fully onchain NFTs
- Designing visually appealing NFTs utilizing modern mobile design principles
- Implementing game mechanics and NFT attributes for blockchain gaming

## Project Overview

**Beasts** (beasts-g2) is a fully onchain NFT collection featuring various monsters that can be collected as part of the Loot Survivor game ecosystem on Starknet.

### Technology Stack
- **Language**: Cairo (Edition 2024_07)
- **Build Tool**: Scarb 2.10.1
- **Testing Framework**: Starknet Foundry (snforge)
- **Blockchain**: Starknet Layer 2
- **Contract Dependencies**:
  - OpenZeppelin Cairo v1.0.0 (access control, ERC721, introspection)
  - Starknet SDK v2.10.1

### Architecture

The project implements an ERC721 NFT with the following components:
- `OwnableComponent` - Contract ownership and access control
- `ERC721Component` - Core NFT functionality
- `SRC5Component` - Interface introspection support
- Custom beast attributes and game mechanics (to be implemented)
- Onchain SVG rendering for beast artwork (to be implemented)

## Commands

### Build
```bash
scarb build
```

### Test
```bash
# Run all tests
snforge test
# or
scarb test

# Run specific test
snforge test test_name

# Run tests with coverage
snforge test --coverage

# Generate coverage report
cairo-coverage
```

### Format
```bash
scarb fmt
```

### Deploy
```bash
# Set environment variables first (see .env.example)
# Then run deployment script
./scripts/deploy.sh

# Required environment variables:
# - STARKNET_NETWORK: "sepolia" or "mainnet"
# - STARKNET_ACCOUNT: Your account address
# - STARKNET_KEYSTORE: Path to keystore file (recommended)
# - STARKNET_PRIVATE_KEY: Raw private key (development only)
# - INFURA_API_KEY: Required for mainnet deployments

# Default deployment parameters:
# - Name: "Beasts"
# - Symbol: "BEAST"
# - Base URI: "https://api.beasts.game/metadata/"
# - Token IDs: Configurable via TOKEN_IDS env var
```

Deployment artifacts are saved to `deployments/<network>_beasts_nft_<timestamp>.json` with latest symlinked.

## Testing Requirements

**CRITICAL: This project enforces a minimum 90% test coverage using cairo-coverage. Any code changes without adequate tests will fail CI validation.**

When implementing features:
1. Write comprehensive unit tests for all new functions
2. Include edge cases, boundary conditions, and failure scenarios
3. Add integration tests for cross-contract interactions
4. Create fuzz tests for user inputs and mathematical operations
5. Run coverage locally before pushing: `cairo-coverage`

## Completion Criteria

**Definition of complete**: A task is ONLY complete when `scarb build && scarb test` runs with zero warnings and zero errors.

When encountering issues:
1. Fix warnings/errors sequentially
2. Verify each fix with `scarb build && scarb test`
3. Ensure 90%+ test coverage for modified files
4. Only consider work complete when all criteria are met

## NFT Design Specification

Beasts NFTs follow a vertical card design (2.5" x 3.5" / 63mm x 88mm) with hierarchical layout:

**TOP SECTION (15-20%)**:
- Card Name: Centered, bold, largest text
- Cost/Energy: Top-right corner icons
- Card Type/Class: Small text below name

**MIDDLE SECTION (40-50%)**:
- Main Artwork: Full-width SVG illustration
- Frame: Decorative border (gold=rare, silver=uncommon)
- Set Symbol: Bottom-right of artwork

**LOWER SECTION (35-40%)**:
- Text Box: Light background with abilities
- Ability Text: Bold names, regular descriptions
- Flavor Text: Italicized, separated by divider

**BOTTOM BAR (5%)**:
- Attack/Defense: Corner shields
- Rarity Symbol: Center
- Card Number: "123/350 • SET2024"
- Artist Credit: Bottom-right

All artwork must be optimized SVG for onchain storage.

## Code Style Guidelines

When writing Cairo code:
- Use descriptive variable names (e.g., `beast_power_level` not `pwr`)
- Structure contracts: interfaces → events → storage → constructor → external → internal
- Implement error messages as descriptive constants
- Add comprehensive natspec comments for public functions
- Document the "why" behind complex logic

Example:
```cairo
/// Mints a new Beast NFT with specified attributes
/// @param recipient Address to receive the minted beast
/// @param beast_type The species of beast (dragon, chimera, etc.)
/// @param power_level Base power for combat calculations
/// @return token_id The ID of the newly minted beast
fn mint_beast(recipient: ContractAddress, beast_type: felt252, power_level: u32) -> u256 {
    // Validate power level is within game balance limits
    assert(power_level <= MAX_BEAST_POWER, Errors::POWER_EXCEEDS_LIMIT);
    // ... implementation
}
```

## Development Workflow

1. Always run `scarb build` after code changes
2. Run full test suite before committing: `snforge test`
3. Check coverage meets 90% threshold: `cairo-coverage`
4. Use proper environment configuration for deployment
5. Verify deployment outputs in `deployments/` directory
