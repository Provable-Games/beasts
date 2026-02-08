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
