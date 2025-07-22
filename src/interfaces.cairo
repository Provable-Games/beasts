use starknet::ContractAddress;
use super::pack::PackableBeast;

/// Interface for the Beasts NFT contract
#[starknet::interface]
pub trait IBeasts<TContractState> {
    // Minter management
    fn set_minter(ref self: TContractState, minter: ContractAddress);
    fn get_minter(self: @TContractState) -> ContractAddress;

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
        timeline: u8,
    );
    fn mint_genesis_beasts(ref self: TContractState, to: ContractAddress);

    // Beast queries
    fn get_beast(self: @TContractState, token_id: u256) -> PackableBeast;
    fn is_minted(self: @TContractState, beast_id: u8, prefix: u8, suffix: u8) -> bool;
    fn total_supply(self: @TContractState) -> u256;

    // Beast ranking queries
    fn get_beast_rank(self: @TContractState, token_id: u256) -> u16;
}
