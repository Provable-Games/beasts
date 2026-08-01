use starknet::ContractAddress;
use super::pack::PackableBeast;

/// Beasts-specific owner-only enumeration.
///
/// Deliberately not the standard `IERC721Enumerable` ID: this implements only
/// the owner half of that interface, and claiming the full one would tell
/// callers `token_by_index` exists when it does not.
/// EFS: token_of_owner_by_index(ContractAddress,(u128,u128))->(u128,u128)
pub const IBEASTS_OWNER_ENUMERABLE_ID: felt252 =
    0x312c74a3a4f7aaf9aa3e80ddea171f958139ef0c3dbea524e0763682b7d57dd;

#[starknet::interface]
pub trait IBeastsOwnerEnumerable<TContractState> {
    /// Token held by `owner` at `index`, where index runs 0..balance_of(owner).
    /// Order is not stable across transfers: removal swaps the last entry into
    /// the vacated slot.
    fn token_of_owner_by_index(self: @TContractState, owner: ContractAddress, index: u256) -> u256;
}

/// Interface for the Beasts NFT contract
#[starknet::interface]
pub trait IBeasts<TContractState> {
    // Minter management
    fn set_dungeon_address(ref self: TContractState, address: ContractAddress);
    fn get_dungeon_address(self: @TContractState) -> ContractAddress;
    fn set_death_mountain_address(ref self: TContractState, death_mountain: ContractAddress);
    fn get_death_mountain_address(self: @TContractState) -> ContractAddress;
    fn set_registry_address(ref self: TContractState, registry: ContractAddress);
    fn get_registry_address(self: @TContractState) -> ContractAddress;

    // Minting functions
    fn mint(
        ref self: TContractState,
        to: ContractAddress,
        beast_id: u64,
        prefix: u8,
        suffix: u8,
        level: u16,
        health: u16,
        shiny: u8,
        animated: u8,
    ) -> (u256, u16, bool);

    // Metadata functions
    fn refresh_metadata(ref self: TContractState, beast_id: u64);
    fn refresh_dungeon_stats(ref self: TContractState, token_id: u256);
    /// Permissionless pull of a community species token's live stats into the
    /// on-chain cache that `token_uri` reads. Genesis species keep their live
    /// Death Mountain reads and are rejected here.
    fn refresh_stats(ref self: TContractState, token_id: u256);
    fn get_cached_stats(self: @TContractState, token_id: u256) -> BeastLiveStats;

    // Beast queries
    fn get_beast(self: @TContractState, token_id: u256) -> PackableBeast;
    fn is_minted(self: @TContractState, beast_id: u64, prefix: u8, suffix: u8) -> bool;
    fn total_supply(self: @TContractState) -> u256;

    // Beast ranking queries
    fn get_beast_rank(self: @TContractState, token_id: u256) -> u16;
    fn get_token_id_at_rank(self: @TContractState, beast_id: u64, rank: u16) -> u256;
    fn get_species_count(self: @TContractState, beast_id: u64) -> u16;
    fn get_kill_count(self: @TContractState, token_id: u256) -> u64;
    fn get_beast_metadata_bookmark(self: @TContractState, beast_id: u64) -> u16;
    fn get_last_manual_metadata_refresh(self: @TContractState, token_id: u256) -> u64;
    fn get_adventurer_killed(self: @TContractState, token_id: u256, index: u64) -> u64;
    fn get_last_killed_timestamp(self: @TContractState, token_id: u256) -> u64;
    fn get_last_killed_by(self: @TContractState, token_id: u256) -> u64;
    fn get_adventurers_killed(self: @TContractState, token_id: u256) -> u64;
    fn get_regular_png_provider(self: @TContractState) -> ContractAddress;
    fn get_regular_gif_provider(self: @TContractState) -> ContractAddress;
    fn get_shiny_png_provider(self: @TContractState) -> ContractAddress;
    fn get_shiny_gif_provider(self: @TContractState) -> ContractAddress;
}


/// Legacy image data provider interface, keyed by u8 genesis species IDs.
/// Used by the four deployed art data contracts for species 1-75.
#[starknet::interface]
pub trait IBeastImageDataProvider<TContractState> {
    fn get_data_uri(self: @TContractState, beast_id: u8) -> ByteArray;
}

/// Art provider interface for community species. Receives the full decoded
/// beast so providers can select variants (shiny/animated are in the struct)
/// and customize rendering by prefix, suffix, tier, or level.
#[starknet::interface]
pub trait IBeastArtProvider<TContractState> {
    fn get_data_uri(self: @TContractState, beast: PackableBeast) -> ByteArray;
}

/// Management interface of the canonical factory-deployed art provider.
#[starknet::interface]
pub trait IStoredArtProvider<TContractState> {
    fn set_art(
        ref self: TContractState,
        beast_id: u64,
        png_regular: ByteArray,
        png_shiny: ByteArray,
        gif_regular: ByteArray,
        gif_shiny: ByteArray,
    );
    fn get_registry(self: @TContractState) -> ContractAddress;
    fn get_species_id(self: @TContractState) -> u64;
}

/// Beast type codes as encoded in token IDs: Magic = 0, Hunter = 1, Brute = 2.
#[derive(Drop, Copy, Serde, PartialEq)]
pub enum BeastType {
    Magic,
    Hunter,
    Brute,
}

pub impl BeastTypeIntoU8 of Into<BeastType, u8> {
    fn into(self: BeastType) -> u8 {
        match self {
            BeastType::Magic => 0,
            BeastType::Hunter => 1,
            BeastType::Brute => 2,
        }
    }
}

/// Full definition of a registered community species.
#[derive(Drop, Serde)]
pub struct BeastDefinition {
    pub name: felt252,
    pub beast_type: u8, // type code: 0 = Magic, 1 = Hunter, 2 = Brute
    pub tier: u8, // 1..=5
    pub minter: ContractAddress, // dungeon allowed to mint this species; 0 = paused
    pub artist: ContractAddress, // holder of the Genesis Beast; per-species admin
    pub art_provider: ContractAddress,
    pub stats_source: ContractAddress, // 0 = no kill stats
    pub factory_provider: bool,
    pub art_locked: bool,
    pub minter_locked: bool,
}

/// Permissionless registry for community Beast species.
#[starknet::interface]
pub trait IBeastRegistry<TContractState> {
    // -------- permissionless registration --------

    /// Simple path: the registry deploys the canonical StoredArtProvider
    /// holding the four supplied data URIs. One transaction, no contract
    /// knowledge needed.
    fn register_beast_with_art(
        ref self: TContractState,
        name: felt252,
        beast_type: BeastType,
        tier: u8,
        minter: ContractAddress,
        png_regular: ByteArray,
        png_shiny: ByteArray,
        gif_regular: ByteArray,
        gif_shiny: ByteArray,
    ) -> u64;

    /// Advanced path: artist supplies their own IBeastArtProvider (non-zero).
    fn register_beast(
        ref self: TContractState,
        name: felt252,
        beast_type: BeastType,
        tier: u8,
        minter: ContractAddress,
        art_provider: ContractAddress,
    ) -> u64;

    // -------- per-species admin (artist only) --------
    fn set_minter(ref self: TContractState, beast_id: u64, minter: ContractAddress);
    fn lock_minter(ref self: TContractState, beast_id: u64);
    fn update_art(
        ref self: TContractState,
        beast_id: u64,
        png_regular: ByteArray,
        png_shiny: ByteArray,
        gif_regular: ByteArray,
        gif_shiny: ByteArray,
    );
    fn set_art_provider(ref self: TContractState, beast_id: u64, provider: ContractAddress);
    fn notify_art_updated(ref self: TContractState, beast_id: u64);
    fn lock_art(ref self: TContractState, beast_id: u64);
    fn set_stats_source(ref self: TContractState, beast_id: u64, source: ContractAddress);

    // -------- reads --------
    fn get_definition(self: @TContractState, beast_id: u64) -> BeastDefinition;
    fn get_minter(self: @TContractState, beast_id: u64) -> ContractAddress;
    /// Whoever currently holds the species' Genesis Beast. The artist role is
    /// not stored: the creator token *is* the role, so transferring it on any
    /// marketplace transfers control of the species.
    fn get_artist(self: @TContractState, beast_id: u64) -> ContractAddress;
    /// Token ID of the species' Genesis Beast. Derived from the species and
    /// its traits, so clients can compute it offline too.
    fn get_genesis_token_id(self: @TContractState, beast_id: u64) -> u256;
    fn get_art_provider(self: @TContractState, beast_id: u64) -> ContractAddress;
    fn get_stats_source(self: @TContractState, beast_id: u64) -> ContractAddress;
    fn get_species_traits(self: @TContractState, beast_id: u64) -> (u8, u8); // (tier, type)
    fn get_species_name(self: @TContractState, beast_id: u64) -> felt252;
    fn is_registered(self: @TContractState, beast_id: u64) -> bool;
    fn is_art_locked(self: @TContractState, beast_id: u64) -> bool;
    fn is_minter_locked(self: @TContractState, beast_id: u64) -> bool;
    fn species_count(self: @TContractState) -> u64;
    fn get_nft_address(self: @TContractState) -> ContractAddress;
    fn get_stored_art_class_hash(self: @TContractState) -> starknet::ClassHash;

    // -------- owner levers --------
    fn set_nft_address(ref self: TContractState, nft: ContractAddress);
    fn set_stored_art_class_hash(ref self: TContractState, class_hash: starknet::ClassHash);
}

/// Live combat stats served by an opt-in per-species stats source.
#[derive(Drop, Copy, Serde)]
pub struct BeastLiveStats {
    pub adventurers_killed: u64,
    pub last_killed_by: u64,
    pub last_killed_timestamp: u64,
}

/// SRC5 interface ID a compliant stats source must register. The registry
/// verifies it once, at `set_stats_source` time. Ecosystem-defined ID:
/// sn_keccak("beast_stats_v1").
pub const IBEAST_STATS_ID: felt252 = selector!("beast_stats_v1");

/// Opt-in per-species kill-stats source (implemented by Death Mountain v2 or
/// any community dungeon). Stats are consumed by the NFT's cached
/// refresh-stats flow, never live from `token_uri`.
#[starknet::interface]
pub trait IBeastStats<TContractState> {
    fn get_beast_stats(self: @TContractState, entity_hash: felt252) -> BeastLiveStats;
}

/// Registry-facing entrypoints implemented by the Beasts NFT contract.
#[starknet::interface]
pub trait IBeastsProvenance<TContractState> {
    /// Mints the species' Genesis Beast (id, 0, 0) to the artist.
    fn mint_provenance(ref self: TContractState, artist: ContractAddress, beast_id: u64);
    /// Fans out MetadataUpdate events for a species after an art change.
    fn emit_species_metadata_update(ref self: TContractState, beast_id: u64);
}

#[starknet::interface]
pub trait IBeastSystems<T> {
    fn add_collectable(
        ref self: T,
        seed: u64,
        entity_id: u8,
        level: u16,
        health: u16,
        prefix: u8,
        suffix: u8,
        adventurer_id: u64,
    );
    fn add_kill(ref self: T, entity_hash: felt252, adventurer_id: u64);
    fn premint_collectable(
        ref self: T, seed: u64, entity_id: u8, prefix: u8, suffix: u8, level: u16, health: u16,
    ) -> u64;
    fn get_valid_collectable(
        self: @T, dungeon: ContractAddress, adventurer_id: u64, entity_hash: felt252,
    ) -> DataResult<(u64, u16, u16)>;
    fn get_collectable(
        self: @T, dungeon: ContractAddress, entity_hash: felt252, index: u64,
    ) -> CollectableEntity;
    fn get_collectable_count(self: @T, dungeon: ContractAddress, entity_hash: felt252) -> u64;
    fn is_beast_collectable(self: @T, adventurer_id: u64, entity_hash: felt252) -> bool;
    fn get_entity_stats(self: @T, dungeon: ContractAddress, entity_hash: felt252) -> EntityStats;
    fn get_adventurer_killed(
        self: @T, dungeon: ContractAddress, entity_hash: felt252, kill_index: u64,
    ) -> AdventurerKilled;
    fn get_starter_beast(self: @T, starter_weapon_type: Type) -> Beast;
    fn get_beast(
        self: @T,
        adventurer_level: u8,
        weapon_type: Type,
        seed: u32,
        health_rnd: u16,
        level_rnd: u16,
        special2_rnd: u8,
        special3_rnd: u8,
    ) -> Beast;
    fn get_beast_hash(self: @T, id: u8, prefix: u8, suffix: u8) -> felt252;
}

#[starknet::interface]
pub trait IBeastsAnimation<TContractState> {
    fn animation_url(self: @TContractState, token_id: u256) -> ByteArray;
}

#[derive(Drop, Copy, Serde, PartialEq)]
pub enum DataResult<T> {
    Ok: T,
    Err: felt252,
}

#[derive(Copy, Drop, PartialEq, Serde)]
pub enum Type {
    None,
    Magic_or_Cloth,
    Blade_or_Hide,
    Bludgeon_or_Metal,
    Necklace,
    Ring,
}

#[derive(Copy, Drop, Serde)]
pub struct AdventurerKilled {
    pub dungeon: ContractAddress,
    pub entity_hash: felt252,
    pub kill_index: u64,
    pub adventurer_id: u64,
    pub timestamp: u64,
}

#[derive(Copy, Drop, Serde)]
pub struct CollectableEntity {
    pub dungeon: ContractAddress,
    pub entity_hash: felt252,
    pub index: u64,
    pub seed: u64,
    pub id: u8,
    pub level: u16,
    pub health: u16,
    pub prefix: u8,
    pub suffix: u8,
    pub killed_by: u64,
    pub timestamp: u64,
}

#[derive(Copy, Drop, Serde)]
pub struct EntityStats {
    pub dungeon: ContractAddress,
    pub entity_hash: felt252,
    pub adventurers_killed: u64,
}

#[derive(Drop, Copy, Serde)]
pub struct Beast {
    pub id: u8, // beast id 1 - 75
    pub starting_health: u16, // health of the beast (stored on adventurer)
    pub combat_spec: CombatSpec // Combat Spec
}

#[derive(Drop, Copy, Serde)]
pub struct CombatSpec {
    pub tier: Tier,
    pub item_type: Type,
    pub level: u16,
    pub specials: SpecialPowers,
}

#[derive(Drop, Copy, Serde)]
pub enum Tier {
    None,
    T1,
    T2,
    T3,
    T4,
    T5,
}

#[derive(Drop, Copy, Serde)]
pub struct SpecialPowers {
    pub special1: u8,
    pub special2: u8,
    pub special3: u8,
}
