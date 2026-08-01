/**
 * Beast SDK Utility Functions
 *
 * Pure utility functions extracted to avoid circular dependencies.
 */

/**
 * Calculate a beast's power based on tier and level
 * Power = (6 - tier) * level
 */
export function calculatePower(tier: number, level: number): number {
  return (6 - tier) * level;
}

/**
 * Calculate a beast's power with on-chain u16 clamping.
 * On-chain: if level > 65535 / multiplier, power = 65535.
 */
export function calculatePowerClamped(tier: number, level: number): number {
  const multiplier = 6 - tier;
  if (multiplier <= 0) {
    return 0;
  }
  const maxLevel = Math.floor(65535 / multiplier);
  if (level > maxLevel) {
    return 65535;
  }
  return level * multiplier;
}

/**
 * Compare two beasts for ranking: power desc, then health desc.
 * Returns true if A should rank above B.
 */
export function isHigherRank(
  powerA: number,
  healthA: number,
  powerB: number,
  healthB: number
): boolean {
  return powerA > powerB || (powerA === powerB && healthA > healthB);
}
