/**
 * Beast SDK Lookup Tables
 *
 * Static lookup tables for beast names, tiers, types, prefixes, and suffixes.
 * Based on Loot Survivor beast data.
 */

/**
 * 75 Beast Names by ID (1-75)
 * Order: Magic (1-25), Hunter (26-50), Brute (51-75)
 * Within each type: T1 (1-5), T2 (6-10), T3 (11-15), T4 (16-20), T5 (21-25)
 */
export const BEAST_NAMES: Record<number, string> = {
  // Magic Beasts (1-25)
  // T1 Magic
  1: "Warlock",
  2: "Typhon",
  3: "Jiangshi",
  4: "Anansi",
  5: "Basilisk",
  // T2 Magic
  6: "Gorgon",
  7: "Kitsune",
  8: "Lich",
  9: "Chimera",
  10: "Wendigo",
  // T3 Magic
  11: "Rakshasa",
  12: "Werewolf",
  13: "Banshee",
  14: "Draugr",
  15: "Vampire",
  // T4 Magic
  16: "Goblin",
  17: "Ghoul",
  18: "Wraith",
  19: "Sprite",
  20: "Kappa",
  // T5 Magic
  21: "Fairy",
  22: "Leprechaun",
  23: "Kelpie",
  24: "Pixie",
  25: "Gnome",

  // Hunter Beasts (26-50)
  // T1 Hunter
  26: "Griffin",
  27: "Manticore",
  28: "Phoenix",
  29: "Dragon",
  30: "Minotaur",
  // T2 Hunter
  31: "Qilin",
  32: "Ammit",
  33: "Nue",
  34: "Skinwalker",
  35: "Chupacabra",
  // T3 Hunter
  36: "Weretiger",
  37: "Wyvern",
  38: "Roc",
  39: "Harpy",
  40: "Pegasus",
  // T4 Hunter
  41: "Hippogriff",
  42: "Fenrir",
  43: "Jaguar",
  44: "Satori",
  45: "Direwolf",
  // T5 Hunter
  46: "Bear",
  47: "Wolf",
  48: "Mantis",
  49: "Spider",
  50: "Rat",

  // Brute Beasts (51-75)
  // T1 Brute
  51: "Kraken",
  52: "Colossus",
  53: "Balrog",
  54: "Leviathan",
  55: "Tarrasque",
  // T2 Brute
  56: "Titan",
  57: "Nephilim",
  58: "Behemoth",
  59: "Hydra",
  60: "Juggernaut",
  // T3 Brute
  61: "Oni",
  62: "Jotunn",
  63: "Ettin",
  64: "Cyclops",
  65: "Giant",
  // T4 Brute
  66: "Nemean Lion",
  67: "Berserker",
  68: "Yeti",
  69: "Golem",
  70: "Ent",
  // T5 Brute
  71: "Troll",
  72: "Bigfoot",
  73: "Ogre",
  74: "Orc",
  75: "Skeleton",
};

/**
 * Beast tiers by ID (1-5, where 1 is strongest)
 */
export const BEAST_TIERS: Record<number, number> = {};

// Generate tiers programmatically
// Pattern: Within each type (25 beasts), IDs 1-5 = T1, 6-10 = T2, etc.
for (let id = 1; id <= 75; id++) {
  const positionInType = ((id - 1) % 25) + 1; // 1-25 within each type
  const tier = Math.ceil(positionInType / 5); // 1-5 based on position
  BEAST_TIERS[id] = tier;
}

/**
 * Beast combat types by ID
 * IDs 1-25: Magic, 26-50: Hunter, 51-75: Brute
 */
export const BEAST_TYPES: Record<number, string> = {};

for (let id = 1; id <= 25; id++) {
  BEAST_TYPES[id] = "Magic";
}
for (let id = 26; id <= 50; id++) {
  BEAST_TYPES[id] = "Hunter";
}
for (let id = 51; id <= 75; id++) {
  BEAST_TYPES[id] = "Brute";
}

/**
 * 69 Item Name Prefixes by ID (1-69)
 * Used in beast names like "Apocalypse Bane Dragon"
 */
export const ITEM_NAME_PREFIXES: Record<number, string> = {
  1: "Agony",
  2: "Apocalypse",
  3: "Armageddon",
  4: "Beast",
  5: "Behemoth",
  6: "Blight",
  7: "Blood",
  8: "Bramble",
  9: "Brimstone",
  10: "Brood",
  11: "Carrion",
  12: "Cataclysm",
  13: "Chimeric",
  14: "Corpse",
  15: "Corruption",
  16: "Damnation",
  17: "Death",
  18: "Demon",
  19: "Dire",
  20: "Dragon",
  21: "Dread",
  22: "Doom",
  23: "Dusk",
  24: "Eagle",
  25: "Empyrean",
  26: "Fate",
  27: "Foe",
  28: "Gale",
  29: "Ghoul",
  30: "Gloom",
  31: "Glyph",
  32: "Golem",
  33: "Grim",
  34: "Hate",
  35: "Havoc",
  36: "Honour",
  37: "Horror",
  38: "Hypnotic",
  39: "Kraken",
  40: "Loath",
  41: "Maelstrom",
  42: "Mind",
  43: "Miracle",
  44: "Morbid",
  45: "Oblivion",
  46: "Onslaught",
  47: "Pain",
  48: "Pandemonium",
  49: "Phoenix",
  50: "Plague",
  51: "Rage",
  52: "Rapture",
  53: "Rune",
  54: "Skull",
  55: "Sol",
  56: "Soul",
  57: "Sorrow",
  58: "Spirit",
  59: "Storm",
  60: "Tempest",
  61: "Torment",
  62: "Vengeance",
  63: "Victory",
  64: "Viper",
  65: "Vortex",
  66: "Woe",
  67: "Wrath",
  68: "Lights",
  69: "Shimmering",
};

/**
 * 18 Item Name Suffixes by ID (1-18)
 * Used in beast names like "Apocalypse Bane Dragon"
 */
export const ITEM_NAME_SUFFIXES: Record<number, string> = {
  1: "Bane",
  2: "Root",
  3: "Bite",
  4: "Song",
  5: "Roar",
  6: "Grasp",
  7: "Instrument",
  8: "Glow",
  9: "Bender",
  10: "Shadow",
  11: "Whisper",
  12: "Shout",
  13: "Growl",
  14: "Tear",
  15: "Peak",
  16: "Form",
  17: "Sun",
  18: "Moon",
};

/**
 * Reverse lookup maps for name -> ID.
 */
export const BEAST_NAME_IDS = new Map<string, number>();
export const ITEM_NAME_PREFIX_IDS = new Map<string, number>();
export const ITEM_NAME_SUFFIX_IDS = new Map<string, number>();

for (const [id, name] of Object.entries(BEAST_NAMES)) {
  BEAST_NAME_IDS.set(name.toLowerCase(), Number(id));
}

for (const [id, name] of Object.entries(ITEM_NAME_PREFIXES)) {
  ITEM_NAME_PREFIX_IDS.set(name.toLowerCase(), Number(id));
}

for (const [id, name] of Object.entries(ITEM_NAME_SUFFIXES)) {
  ITEM_NAME_SUFFIX_IDS.set(name.toLowerCase(), Number(id));
}

/**
 * Look up a beast name by ID
 */
export function getBeastName(beastId: number): string {
  return BEAST_NAMES[beastId] ?? "Unknown";
}

/**
 * Look up a beast tier by ID
 */
export function getBeastTier(beastId: number): number {
  return BEAST_TIERS[beastId] ?? 5;
}

/**
 * Look up a beast combat type by ID
 */
export function getBeastType(beastId: number): string {
  return BEAST_TYPES[beastId] ?? "Unknown";
}

/**
 * Look up a prefix name by ID
 */
export function getPrefix(prefixId: number): string {
  return ITEM_NAME_PREFIXES[prefixId] ?? "";
}

/**
 * Look up a suffix name by ID
 */
export function getSuffix(suffixId: number): string {
  return ITEM_NAME_SUFFIXES[suffixId] ?? "";
}

/**
 * Reverse lookup a beast ID by name (case-insensitive).
 */
export function getBeastIdByName(name: string | null): number | null {
  if (!name) return null;
  return BEAST_NAME_IDS.get(name.trim().toLowerCase()) ?? null;
}

/**
 * Reverse lookup a prefix ID by name (case-insensitive).
 */
export function getPrefixIdByName(prefix: string | null): number | null {
  if (!prefix) return null;
  return ITEM_NAME_PREFIX_IDS.get(prefix.trim().toLowerCase()) ?? null;
}

/**
 * Reverse lookup a suffix ID by name (case-insensitive).
 */
export function getSuffixIdByName(suffix: string | null): number | null {
  if (!suffix) return null;
  return ITEM_NAME_SUFFIX_IDS.get(suffix.trim().toLowerCase()) ?? null;
}
