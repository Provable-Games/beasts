use starknet::ContractAddress;
use super::pack::PackableBeast;

/// Interface for the Beasts NFT contract
#[starknet::interface]
pub trait IBeasts<TContractState> {
    // Minter management
    fn set_dungeon_address(ref self: TContractState, address: ContractAddress);
    fn get_dungeon_address(self: @TContractState) -> ContractAddress;
    fn set_death_mountain_address(ref self: TContractState, death_mountain: ContractAddress);
    fn get_death_mountain_address(self: @TContractState) -> ContractAddress;

    // Minting functions
    fn mint(
        ref self: TContractState,
        to: ContractAddress,
        beast_id: u8,
        prefix: u8,
        suffix: u8,
        level: u16,
        health: u16,
        shiny: u8,
        animated: u8,
    ) -> u256;

    // Beast queries
    fn get_beast(self: @TContractState, token_id: u256) -> PackableBeast;
    fn is_minted(self: @TContractState, beast_id: u8, prefix: u8, suffix: u8) -> bool;
    fn total_supply(self: @TContractState) -> u256;

    // Beast ranking queries
    fn get_beast_rank(self: @TContractState, token_id: u256) -> u16;
    fn get_kill_count(self: @TContractState, token_id: u256) -> u64;
    fn get_adventurer_killed(self: @TContractState, token_id: u256, index: u64) -> u64;
    fn get_last_killed_timestamp(self: @TContractState, token_id: u256) -> u64;
    fn get_last_killed_by(self: @TContractState, token_id: u256) -> u64;
    fn get_adventurers_killed(self: @TContractState, token_id: u256) -> u64;
}


#[starknet::interface]
pub trait IBeastImageDataProvider<TContractState> {
    fn get_data_uri(self: @TContractState, beast_id: u8) -> ByteArray;
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
