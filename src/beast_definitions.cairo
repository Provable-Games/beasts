// Beast definitions - All 75 beasts for Loot Survivor

// Tiers
pub const TIER_1: felt252 = '1';
pub const TIER_2: felt252 = '2';
pub const TIER_3: felt252 = '3';
pub const TIER_4: felt252 = '4';
pub const TIER_5: felt252 = '5';

// Types
pub const TYPE_MAGICAL: felt252 = 'Magical';
pub const TYPE_HUNTER: felt252 = 'Hunter';
pub const TYPE_BRUTE: felt252 = 'Brute';

// Magical T1s (1-5)
pub const WARLOCK: u8 = 1;
pub const TYPHON: u8 = 2;
pub const JIANGSHI: u8 = 3;
pub const ANANSI: u8 = 4;
pub const BASILISK: u8 = 5;

// Magical T2s (6-10)
pub const GORGON: u8 = 6;
pub const KITSUNE: u8 = 7;
pub const LICH: u8 = 8;
pub const CHIMERA: u8 = 9;
pub const WENDIGO: u8 = 10;

// Magical T3s (11-15)
pub const RAKSHASA: u8 = 11;
pub const WEREWOLF: u8 = 12;
pub const BANSHEE: u8 = 13;
pub const DRAUGR: u8 = 14;
pub const VAMPIRE: u8 = 15;

// Magical T4s (16-20)
pub const GOBLIN: u8 = 16;
pub const GHOUL: u8 = 17;
pub const WRAITH: u8 = 18;
pub const SPRITE: u8 = 19;
pub const KAPPA: u8 = 20;

// Magical T5s (21-25)
pub const FAIRY: u8 = 21;
pub const LEPRECHAUN: u8 = 22;
pub const KELPIE: u8 = 23;
pub const PIXIE: u8 = 24;
pub const GNOME: u8 = 25;

// Hunter T1s (26-30)
pub const GRIFFIN: u8 = 26;
pub const MANTICORE: u8 = 27;
pub const PHOENIX: u8 = 28;
pub const DRAGON: u8 = 29;
pub const MINOTAUR: u8 = 30;

// Hunter T2s (31-35)
pub const QILIN: u8 = 31;
pub const AMMIT: u8 = 32;
pub const NUE: u8 = 33;
pub const SKINWALKER: u8 = 34;
pub const CHUPACABRA: u8 = 35;

// Hunter T3s (36-40)
pub const WERETIGER: u8 = 36;
pub const WYVERN: u8 = 37;
pub const ROC: u8 = 38;
pub const HARPY: u8 = 39;
pub const PEGASUS: u8 = 40;

// Hunter T4s (41-45)
pub const HIPPOGRIFF: u8 = 41;
pub const FENRIR: u8 = 42;
pub const JAGUAR: u8 = 43;
pub const SATORI: u8 = 44;
pub const DIREWOLF: u8 = 45;

// Hunter T5s (46-50)
pub const BEAR: u8 = 46;
pub const WOLF: u8 = 47;
pub const MANTIS: u8 = 48;
pub const SPIDER: u8 = 49;
pub const RAT: u8 = 50;

// Brute T1s (51-55)
pub const KRAKEN: u8 = 51;
pub const COLOSSUS: u8 = 52;
pub const BALROG: u8 = 53;
pub const LEVIATHAN: u8 = 54;
pub const TARRASQUE: u8 = 55;

// Brute T2s (56-60)
pub const TITAN: u8 = 56;
pub const NEPHILIM: u8 = 57;
pub const BEHEMOTH: u8 = 58;
pub const HYDRA: u8 = 59;
pub const JUGGERNAUT: u8 = 60;

// Brute T3s (61-65)
pub const ONI: u8 = 61;
pub const JOTUNN: u8 = 62;
pub const ETTIN: u8 = 63;
pub const CYCLOPS: u8 = 64;
pub const GIANT: u8 = 65;

// Brute T4s (66-70)
pub const NEMEANLION: u8 = 66;
pub const BERSERKER: u8 = 67;
pub const YETI: u8 = 68;
pub const GOLEM: u8 = 69;
pub const ENT: u8 = 70;

// Brute T5s (71-75)
pub const TROLL: u8 = 71;
pub const BIGFOOT: u8 = 72;
pub const OGRE: u8 = 73;
pub const ORC: u8 = 74;
pub const SKELETON: u8 = 75;

// Beast name prefixes
pub const PREFIX_AGONY: u8 = 1;
pub const PREFIX_APOCALYPSE: u8 = 2;
pub const PREFIX_ARMAGEDDON: u8 = 3;
pub const PREFIX_BEAST: u8 = 4;
pub const PREFIX_BEHEMOTH: u8 = 5;
pub const PREFIX_BLIGHT: u8 = 6;
pub const PREFIX_BLOOD: u8 = 7;
pub const PREFIX_BRAMBLE: u8 = 8;
pub const PREFIX_BRIMSTONE: u8 = 9;
pub const PREFIX_BROOD: u8 = 10;
pub const PREFIX_CARRION: u8 = 11;
pub const PREFIX_CATACLYSM: u8 = 12;
pub const PREFIX_CHIMERIC: u8 = 13;
pub const PREFIX_CORPSE: u8 = 14;
pub const PREFIX_CORRUPTION: u8 = 15;
pub const PREFIX_DAMNATION: u8 = 16;
pub const PREFIX_DEATH: u8 = 17;
pub const PREFIX_DEMON: u8 = 18;
pub const PREFIX_DIRE: u8 = 19;
pub const PREFIX_DRAGON: u8 = 20;
pub const PREFIX_DREAD: u8 = 21;
pub const PREFIX_DOOM: u8 = 22;
pub const PREFIX_DUSK: u8 = 23;
pub const PREFIX_EAGLE: u8 = 24;
pub const PREFIX_EMPYREAN: u8 = 25;
pub const PREFIX_FATE: u8 = 26;
pub const PREFIX_FOE: u8 = 27;
pub const PREFIX_GALE: u8 = 28;
pub const PREFIX_GHOUL: u8 = 29;
pub const PREFIX_GLOOM: u8 = 30;
pub const PREFIX_GLYPH: u8 = 31;
pub const PREFIX_GOLEM: u8 = 32;
pub const PREFIX_GRIM: u8 = 33;
pub const PREFIX_HATE: u8 = 34;
pub const PREFIX_HAVOC: u8 = 35;
pub const PREFIX_HONOUR: u8 = 36;
pub const PREFIX_HORROR: u8 = 37;
pub const PREFIX_HYPNOTIC: u8 = 38;
pub const PREFIX_KRAKEN: u8 = 39;
pub const PREFIX_LOATH: u8 = 40;
pub const PREFIX_MAELSTROM: u8 = 41;
pub const PREFIX_MIND: u8 = 42;
pub const PREFIX_MIRACLE: u8 = 43;
pub const PREFIX_MORBID: u8 = 44;
pub const PREFIX_OBLIVION: u8 = 45;
pub const PREFIX_ONSLAUGHT: u8 = 46;
pub const PREFIX_PAIN: u8 = 47;
pub const PREFIX_PANDEMONIUM: u8 = 48;
pub const PREFIX_PHOENIX: u8 = 49;
pub const PREFIX_PLAGUE: u8 = 50;
pub const PREFIX_RAGE: u8 = 51;
pub const PREFIX_RAPTURE: u8 = 52;
pub const PREFIX_RUNE: u8 = 53;
pub const PREFIX_SKULL: u8 = 54;
pub const PREFIX_SOL: u8 = 55;
pub const PREFIX_SOUL: u8 = 56;
pub const PREFIX_SORROW: u8 = 57;
pub const PREFIX_SPIRIT: u8 = 58;
pub const PREFIX_STORM: u8 = 59;
pub const PREFIX_TEMPEST: u8 = 60;
pub const PREFIX_TORMENT: u8 = 61;
pub const PREFIX_VENGEANCE: u8 = 62;
pub const PREFIX_VICTORY: u8 = 63;
pub const PREFIX_VIPER: u8 = 64;
pub const PREFIX_VORTEX: u8 = 65;
pub const PREFIX_WOE: u8 = 66;
pub const PREFIX_WRATH: u8 = 67;
pub const PREFIX_LIGHTS: u8 = 68;
pub const PREFIX_SHIMMERING: u8 = 69;

// Beast name suffixes
pub const SUFFIX_BANE: u8 = 1;
pub const SUFFIX_ROOT: u8 = 2;
pub const SUFFIX_BITE: u8 = 3;
pub const SUFFIX_SONG: u8 = 4;
pub const SUFFIX_ROAR: u8 = 5;
pub const SUFFIX_GRASP: u8 = 6;
pub const SUFFIX_INSTRUMENT: u8 = 7;
pub const SUFFIX_GLOW: u8 = 8;
pub const SUFFIX_BENDER: u8 = 9;
pub const SUFFIX_SHADOW: u8 = 10;
pub const SUFFIX_WHISPER: u8 = 11;
pub const SUFFIX_SHOUT: u8 = 12;
pub const SUFFIX_GROWL: u8 = 13;
pub const SUFFIX_TEAR: u8 = 14;
pub const SUFFIX_PEAK: u8 = 15;
pub const SUFFIX_FORM: u8 = 16;
pub const SUFFIX_SUN: u8 = 17;
pub const SUFFIX_MOON: u8 = 18;

pub fn get_beast_name(beast: u8) -> felt252 {
    if beast == WARLOCK {
        'Warlock'
    } else if beast == TYPHON {
        'Typhon'
    } else if beast == JIANGSHI {
        'Jiangshi'
    } else if beast == ANANSI {
        'Anansi'
    } else if beast == BASILISK {
        'Basilisk'
    } else if beast == GORGON {
        'Gorgon'
    } else if beast == KITSUNE {
        'Kitsune'
    } else if beast == LICH {
        'Lich'
    } else if beast == CHIMERA {
        'Chimera'
    } else if beast == WENDIGO {
        'Wendigo'
    } else if beast == RAKSHASA {
        'Rakshasa'
    } else if beast == WEREWOLF {
        'Werewolf'
    } else if beast == BANSHEE {
        'Banshee'
    } else if beast == DRAUGR {
        'Draugr'
    } else if beast == VAMPIRE {
        'Vampire'
    } else if beast == GOBLIN {
        'Goblin'
    } else if beast == GHOUL {
        'Ghoul'
    } else if beast == WRAITH {
        'Wraith'
    } else if beast == SPRITE {
        'Sprite'
    } else if beast == KAPPA {
        'Kappa'
    } else if beast == FAIRY {
        'Fairy'
    } else if beast == LEPRECHAUN {
        'Leprechaun'
    } else if beast == KELPIE {
        'Kelpie'
    } else if beast == PIXIE {
        'Pixie'
    } else if beast == GNOME {
        'Gnome'
    } else if beast == GRIFFIN {
        'Griffin'
    } else if beast == MANTICORE {
        'Manticore'
    } else if beast == PHOENIX {
        'Phoenix'
    } else if beast == DRAGON {
        'Dragon'
    } else if beast == MINOTAUR {
        'Minotaur'
    } else if beast == QILIN {
        'Qilin'
    } else if beast == AMMIT {
        'Ammit'
    } else if beast == NUE {
        'Nue'
    } else if beast == SKINWALKER {
        'Skinwalker'
    } else if beast == CHUPACABRA {
        'Chupacabra'
    } else if beast == WERETIGER {
        'Weretiger'
    } else if beast == WYVERN {
        'Wyvern'
    } else if beast == ROC {
        'Roc'
    } else if beast == HARPY {
        'Harpy'
    } else if beast == PEGASUS {
        'Pegasus'
    } else if beast == HIPPOGRIFF {
        'Hippogriff'
    } else if beast == FENRIR {
        'Fenrir'
    } else if beast == JAGUAR {
        'Jaguar'
    } else if beast == SATORI {
        'Satori'
    } else if beast == DIREWOLF {
        'Direwolf'
    } else if beast == BEAR {
        'Bear'
    } else if beast == WOLF {
        'Wolf'
    } else if beast == MANTIS {
        'Mantis'
    } else if beast == SPIDER {
        'Spider'
    } else if beast == RAT {
        'Rat'
    } else if beast == KRAKEN {
        'Kraken'
    } else if beast == COLOSSUS {
        'Colossus'
    } else if beast == BALROG {
        'Balrog'
    } else if beast == LEVIATHAN {
        'Leviathan'
    } else if beast == TARRASQUE {
        'Tarrasque'
    } else if beast == TITAN {
        'Titan'
    } else if beast == NEPHILIM {
        'Nephilim'
    } else if beast == BEHEMOTH {
        'Behemoth'
    } else if beast == HYDRA {
        'Hydra'
    } else if beast == JUGGERNAUT {
        'Juggernaut'
    } else if beast == ONI {
        'Oni'
    } else if beast == JOTUNN {
        'Jotunn'
    } else if beast == ETTIN {
        'Ettin'
    } else if beast == CYCLOPS {
        'Cyclops'
    } else if beast == GIANT {
        'Giant'
    } else if beast == NEMEANLION {
        'Nemean Lion'
    } else if beast == BERSERKER {
        'Berserker'
    } else if beast == YETI {
        'Yeti'
    } else if beast == GOLEM {
        'Golem'
    } else if beast == ENT {
        'Ent'
    } else if beast == TROLL {
        'Troll'
    } else if beast == BIGFOOT {
        'Bigfoot'
    } else if beast == OGRE {
        'Ogre'
    } else if beast == ORC {
        'Orc'
    } else if beast == SKELETON {
        'Skeleton'
    } else {
        'Unknown'
    }
}

pub fn get_tier(beast: u8) -> felt252 {
    if ((beast != 0 && beast <= 5)
        || (beast >= 26 && beast <= 30)
        || (beast >= 51 && beast <= 55)) {
        TIER_1
    } else if ((beast >= 6 && beast <= 10)
        || (beast >= 31 && beast <= 35)
        || (beast >= 56 && beast <= 60)) {
        TIER_2
    } else if ((beast >= 11 && beast <= 15)
        || (beast >= 36 && beast <= 40)
        || (beast >= 61 && beast <= 65)) {
        TIER_3
    } else if ((beast >= 16 && beast <= 20)
        || (beast >= 41 && beast <= 45)
        || (beast >= 66 && beast <= 70)) {
        TIER_4
    } else if ((beast >= 21 && beast <= 25)
        || (beast >= 46 && beast <= 50)
        || (beast >= 71 && beast <= 75)) {
        TIER_5
    } else {
        panic!("Invalid beast")
    }
}

pub fn get_type(beast: u8) -> felt252 {
    assert(beast != 0, 'Invalid beast');
    if (beast <= 25) {
        TYPE_MAGICAL
    } else if beast <= 50 {
        TYPE_HUNTER
    } else if beast <= 75 {
        TYPE_BRUTE
    } else {
        panic!("Invalid beast")
    }
}

pub fn get_prefix(prefix: u8) -> felt252 {
    if prefix == PREFIX_AGONY {
        'Agony'
    } else if prefix == PREFIX_APOCALYPSE {
        'Apocalypse'
    } else if prefix == PREFIX_ARMAGEDDON {
        'Armageddon'
    } else if prefix == PREFIX_BEAST {
        'Beast'
    } else if prefix == PREFIX_BEHEMOTH {
        'Behemoth'
    } else if prefix == PREFIX_BLIGHT {
        'Blight'
    } else if prefix == PREFIX_BLOOD {
        'Blood'
    } else if prefix == PREFIX_BRAMBLE {
        'Bramble'
    } else if prefix == PREFIX_BRIMSTONE {
        'Brimstone'
    } else if prefix == PREFIX_BROOD {
        'Brood'
    } else if prefix == PREFIX_CARRION {
        'Carrion'
    } else if prefix == PREFIX_CATACLYSM {
        'Cataclysm'
    } else if prefix == PREFIX_CHIMERIC {
        'Chimeric'
    } else if prefix == PREFIX_CORPSE {
        'Corpse'
    } else if prefix == PREFIX_CORRUPTION {
        'Corruption'
    } else if prefix == PREFIX_DAMNATION {
        'Damnation'
    } else if prefix == PREFIX_DEATH {
        'Death'
    } else if prefix == PREFIX_DEMON {
        'Demon'
    } else if prefix == PREFIX_DIRE {
        'Dire'
    } else if prefix == PREFIX_DRAGON {
        'Dragon'
    } else if prefix == PREFIX_DREAD {
        'Dread'
    } else if prefix == PREFIX_DOOM {
        'Doom'
    } else if prefix == PREFIX_DUSK {
        'Dusk'
    } else if prefix == PREFIX_EAGLE {
        'Eagle'
    } else if prefix == PREFIX_EMPYREAN {
        'Empyrean'
    } else if prefix == PREFIX_FATE {
        'Fate'
    } else if prefix == PREFIX_FOE {
        'Foe'
    } else if prefix == PREFIX_GALE {
        'Gale'
    } else if prefix == PREFIX_GHOUL {
        'Ghoul'
    } else if prefix == PREFIX_GLOOM {
        'Gloom'
    } else if prefix == PREFIX_GLYPH {
        'Glyph'
    } else if prefix == PREFIX_GOLEM {
        'Golem'
    } else if prefix == PREFIX_GRIM {
        'Grim'
    } else if prefix == PREFIX_HATE {
        'Hate'
    } else if prefix == PREFIX_HAVOC {
        'Havoc'
    } else if prefix == PREFIX_HONOUR {
        'Honour'
    } else if prefix == PREFIX_HORROR {
        'Horror'
    } else if prefix == PREFIX_HYPNOTIC {
        'Hypnotic'
    } else if prefix == PREFIX_KRAKEN {
        'Kraken'
    } else if prefix == PREFIX_LOATH {
        'Loath'
    } else if prefix == PREFIX_MAELSTROM {
        'Maelstrom'
    } else if prefix == PREFIX_MIND {
        'Mind'
    } else if prefix == PREFIX_MIRACLE {
        'Miracle'
    } else if prefix == PREFIX_MORBID {
        'Morbid'
    } else if prefix == PREFIX_OBLIVION {
        'Oblivion'
    } else if prefix == PREFIX_ONSLAUGHT {
        'Onslaught'
    } else if prefix == PREFIX_PAIN {
        'Pain'
    } else if prefix == PREFIX_PANDEMONIUM {
        'Pandemonium'
    } else if prefix == PREFIX_PHOENIX {
        'Phoenix'
    } else if prefix == PREFIX_PLAGUE {
        'Plague'
    } else if prefix == PREFIX_RAGE {
        'Rage'
    } else if prefix == PREFIX_RAPTURE {
        'Rapture'
    } else if prefix == PREFIX_RUNE {
        'Rune'
    } else if prefix == PREFIX_SKULL {
        'Skull'
    } else if prefix == PREFIX_SOL {
        'Sol'
    } else if prefix == PREFIX_SOUL {
        'Soul'
    } else if prefix == PREFIX_SORROW {
        'Sorrow'
    } else if prefix == PREFIX_SPIRIT {
        'Spirit'
    } else if prefix == PREFIX_STORM {
        'Storm'
    } else if prefix == PREFIX_TEMPEST {
        'Tempest'
    } else if prefix == PREFIX_TORMENT {
        'Torment'
    } else if prefix == PREFIX_VENGEANCE {
        'Vengeance'
    } else if prefix == PREFIX_VICTORY {
        'Victory'
    } else if prefix == PREFIX_VIPER {
        'Viper'
    } else if prefix == PREFIX_VORTEX {
        'Vortex'
    } else if prefix == PREFIX_WOE {
        'Woe'
    } else if prefix == PREFIX_WRATH {
        'Wrath'
    } else if prefix == PREFIX_LIGHTS {
        'Lights'
    } else if prefix == PREFIX_SHIMMERING {
        'Shimmering'
    } else {
        ''
    }
}

pub fn get_suffix(suffix: u8) -> felt252 {
    if suffix == SUFFIX_BANE {
        'Bane'
    } else if suffix == SUFFIX_ROOT {
        'Root'
    } else if suffix == SUFFIX_BITE {
        'Bite'
    } else if suffix == SUFFIX_SONG {
        'Song'
    } else if suffix == SUFFIX_ROAR {
        'Roar'
    } else if suffix == SUFFIX_GRASP {
        'Grasp'
    } else if suffix == SUFFIX_INSTRUMENT {
        'Instrument'
    } else if suffix == SUFFIX_GLOW {
        'Glow'
    } else if suffix == SUFFIX_BENDER {
        'Bender'
    } else if suffix == SUFFIX_SHADOW {
        'Shadow'
    } else if suffix == SUFFIX_WHISPER {
        'Whisper'
    } else if suffix == SUFFIX_SHOUT {
        'Shout'
    } else if suffix == SUFFIX_GROWL {
        'Growl'
    } else if suffix == SUFFIX_TEAR {
        'Tear'
    } else if suffix == SUFFIX_PEAK {
        'Peak'
    } else if suffix == SUFFIX_FORM {
        'Form'
    } else if suffix == SUFFIX_SUN {
        'Sun'
    } else if suffix == SUFFIX_MOON {
        'Moon'
    } else {
        ''
    }
}
