/// Minimal mock of the Beasts NFT registry-facing surface. Records the last
/// provenance mint and fan-out call so tests can verify the registry drives
/// the NFT correctly (the real implementation lands with the NFT
/// integration).
#[starknet::contract]
pub mod mock_beasts_nft {
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::super::interfaces::IBeastsProvenance;

    #[starknet::interface]
    pub trait IMockCounters<TContractState> {
        fn last_provenance(self: @TContractState) -> (ContractAddress, u64);
        fn provenance_count(self: @TContractState) -> u64;
        fn last_fan_out(self: @TContractState) -> u64;
        fn fan_out_count(self: @TContractState) -> u64;
    }

    #[storage]
    struct Storage {
        last_provenance_artist: ContractAddress,
        last_provenance_id: u64,
        provenance_count: u64,
        last_fan_out_id: u64,
        fan_out_count: u64,
    }

    #[abi(embed_v0)]
    impl ProvenanceImpl of IBeastsProvenance<ContractState> {
        fn mint_provenance(ref self: ContractState, artist: ContractAddress, beast_id: u64) {
            self.last_provenance_artist.write(artist);
            self.last_provenance_id.write(beast_id);
            self.provenance_count.write(self.provenance_count.read() + 1);
        }

        fn emit_species_metadata_update(ref self: ContractState, beast_id: u64) {
            self.last_fan_out_id.write(beast_id);
            self.fan_out_count.write(self.fan_out_count.read() + 1);
        }
    }

    #[abi(embed_v0)]
    impl MockCountersImpl of IMockCounters<ContractState> {
        fn last_provenance(self: @ContractState) -> (ContractAddress, u64) {
            (self.last_provenance_artist.read(), self.last_provenance_id.read())
        }

        fn provenance_count(self: @ContractState) -> u64 {
            self.provenance_count.read()
        }

        fn last_fan_out(self: @ContractState) -> u64 {
            self.last_fan_out_id.read()
        }

        fn fan_out_count(self: @ContractState) -> u64 {
            self.fan_out_count.read()
        }
    }
}

/// Mock kill-stats source with a configurable SRC5 answer, for testing the
/// registry's set-time interface verification.
#[starknet::contract]
pub mod mock_stats_source {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::super::interfaces::IBEAST_STATS_ID;

    #[starknet::interface]
    pub trait ISRC5Like<TContractState> {
        fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
    }

    #[storage]
    struct Storage {
        compliant: bool,
    }

    #[constructor]
    fn constructor(ref self: ContractState, compliant: bool) {
        self.compliant.write(compliant);
    }

    #[abi(embed_v0)]
    impl SRC5Impl of ISRC5Like<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            interface_id == IBEAST_STATS_ID && self.compliant.read()
        }
    }
}

#[cfg(test)]
mod tests {
    use beasts_nft::beast_registry::beast_registry::ART_REFRESH_COOLDOWN_SECONDS;
    use beasts_nft::interfaces::{
        BeastType, IBeastArtProviderDispatcher, IBeastArtProviderDispatcherTrait,
        IBeastRegistryDispatcher, IBeastRegistryDispatcherTrait, IStoredArtProviderDispatcher,
        IStoredArtProviderDispatcherTrait,
    };
    use beasts_nft::pack::PackableBeast;
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_block_timestamp,
        start_cheat_caller_address, stop_cheat_caller_address,
    };
    use starknet::ContractAddress;
    use super::mock_beasts_nft::{IMockCountersDispatcher, IMockCountersDispatcherTrait};

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    // Payloads carry the encoded PNG ("iVBORw0KGgo") / GIF ("R0lGOD") magic
    // bytes and valid base64 structure, as the provider now enforces.
    fn sample_art() -> (ByteArray, ByteArray, ByteArray, ByteArray) {
        (
            "data:image/png;base64,iVBORw0KGgoAAAA1",
            "data:image/png;base64,iVBORw0KGgoAAAA2",
            "data:image/gif;base64,R0lGODdhAAA1",
            "data:image/gif;base64,R0lGODdhAAA2",
        )
    }

    fn community_beast(beast_id: u64, shiny: u8, animated: u8) -> PackableBeast {
        PackableBeast {
            id: beast_id,
            prefix: 1,
            suffix: 1,
            level: 10,
            health: 100,
            shiny,
            animated,
            tier: 3,
            beast_type: 1,
        }
    }

    /// Deploys registry + mock NFT, wires them, returns dispatchers.
    fn setup() -> (IBeastRegistryDispatcher, IMockCountersDispatcher, ContractAddress) {
        let owner = test_address('owner');

        let provider_class = declare("stored_art_provider").unwrap().contract_class();
        let registry_class = declare("beast_registry").unwrap().contract_class();
        let mock_nft_class = declare("mock_beasts_nft").unwrap().contract_class();

        let mut registry_calldata: Array<felt252> = array![];
        owner.serialize(ref registry_calldata);
        provider_class.class_hash.serialize(ref registry_calldata);
        let (registry_address, _) = registry_class.deploy(@registry_calldata).unwrap();

        let (nft_address, _) = mock_nft_class.deploy(@array![]).unwrap();

        let registry = IBeastRegistryDispatcher { contract_address: registry_address };

        start_cheat_caller_address(registry_address, owner);
        registry.set_nft_address(nft_address);
        stop_cheat_caller_address(registry_address);

        (registry, IMockCountersDispatcher { contract_address: nft_address }, owner)
    }

    fn register_default(
        registry: IBeastRegistryDispatcher, artist: ContractAddress, minter: ContractAddress,
    ) -> u64 {
        let (png_regular, png_shiny, gif_regular, gif_shiny) = sample_art();
        start_cheat_caller_address(registry.contract_address, artist);
        let beast_id = registry
            .register_beast_with_art(
                'Gloomfang',
                BeastType::Hunter,
                3,
                minter,
                png_regular,
                png_shiny,
                gif_regular,
                gif_shiny,
            );
        stop_cheat_caller_address(registry.contract_address);
        beast_id
    }

    // ---------------- registration ----------------

    #[test]
    fn test_register_with_art_full_flow() {
        let (registry, nft, _) = setup();
        let artist = test_address('artist');
        let minter = test_address('dungeon');

        let beast_id = register_default(registry, artist, minter);

        assert(beast_id == 76, 'First community id is 76');
        assert(registry.is_registered(76), 'Should be registered');
        assert(!registry.is_registered(77), '77 not yet registered');
        assert(!registry.is_registered(75), 'Genesis not in registry');
        assert(registry.species_count() == 76, '75 genesis + 1 community');

        let def = registry.get_definition(beast_id);
        assert(def.name == 'Gloomfang', 'Name mismatch');
        assert(def.beast_type == 1, 'Type mismatch');
        assert(def.tier == 3, 'Tier mismatch');
        assert(def.minter == minter, 'Minter mismatch');
        assert(def.artist == artist, 'Artist mismatch');
        assert(def.factory_provider, 'Should be factory provider');
        assert(!def.art_locked, 'Art starts unlocked');
        assert(!def.minter_locked, 'Minter starts unlocked');

        let (tier, beast_type) = registry.get_species_traits(beast_id);
        assert(tier == 3 && beast_type == 1, 'Traits mismatch');

        // Provenance mint executed against the NFT with the right args.
        let (prov_artist, prov_id) = nft.last_provenance();
        assert(prov_artist == artist, 'Provenance artist mismatch');
        assert(prov_id == beast_id, 'Provenance id mismatch');
        assert(nft.provenance_count() == 1, 'One provenance mint');

        // Factory provider wired and serving the right variants.
        let provider_addr = registry.get_art_provider(beast_id);
        let stored = IStoredArtProviderDispatcher { contract_address: provider_addr };
        assert(stored.get_registry() == registry.contract_address, 'Provider registry');
        assert(stored.get_species_id() == beast_id, 'Provider species');

        let art = IBeastArtProviderDispatcher { contract_address: provider_addr };
        let (png_regular, png_shiny, gif_regular, gif_shiny) = sample_art();
        assert(
            art.get_data_uri(community_beast(beast_id, 0, 0)) == png_regular, 'regular png variant',
        );
        assert(art.get_data_uri(community_beast(beast_id, 1, 0)) == png_shiny, 'shiny png variant');
        assert(
            art.get_data_uri(community_beast(beast_id, 0, 1)) == gif_regular, 'regular gif variant',
        );
        assert(art.get_data_uri(community_beast(beast_id, 1, 1)) == gif_shiny, 'shiny gif variant');
    }

    #[test]
    fn test_sequential_ids_and_duplicate_names_allowed() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let minter = test_address('dungeon');

        let first = register_default(registry, artist, minter);
        // Same name again: uniqueness is deliberately not enforced.
        let second = register_default(registry, test_address('artist2'), minter);

        assert(first == 76 && second == 77, 'Sequential ids');
        assert(registry.get_species_name(76) == registry.get_species_name(77), 'Same name ok');
    }

    #[test]
    fn test_register_custom_provider() {
        let (registry, nft, _) = setup();
        let artist = test_address('artist');
        let custom_provider = test_address('custom_provider');

        start_cheat_caller_address(registry.contract_address, artist);
        let beast_id = registry
            .register_beast(
                'Voidling', BeastType::Magic, 1, test_address('dungeon'), custom_provider,
            );
        stop_cheat_caller_address(registry.contract_address);

        let def = registry.get_definition(beast_id);
        assert(def.art_provider == custom_provider, 'Provider mismatch');
        assert(!def.factory_provider, 'Not factory provider');
        assert(nft.provenance_count() == 1, 'Provenance minted');
    }

    #[test]
    fn test_register_with_zero_minter_is_paused_state() {
        let (registry, _, _) = setup();
        let beast_id = register_default(registry, test_address('artist'), 0.try_into().unwrap());
        assert(registry.get_minter(beast_id) == 0.try_into().unwrap(), 'Zero minter = paused');
    }

    #[test]
    #[should_panic(expected: 'Registry: zero art provider')]
    fn test_register_custom_zero_provider_rejected() {
        let (registry, _, _) = setup();
        registry
            .register_beast(
                'Voidling', BeastType::Magic, 1, test_address('dungeon'), 0.try_into().unwrap(),
            );
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid tier')]
    fn test_register_tier_zero_rejected() {
        let (registry, _, _) = setup();
        registry
            .register_beast(
                'Voidling', BeastType::Magic, 0, test_address('dungeon'), test_address('p'),
            );
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid tier')]
    fn test_register_tier_six_rejected() {
        let (registry, _, _) = setup();
        registry
            .register_beast(
                'Voidling', BeastType::Magic, 6, test_address('dungeon'), test_address('p'),
            );
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid name char')]
    fn test_register_injection_name_rejected() {
        let (registry, _, _) = setup();
        registry
            .register_beast(
                'x","evil":"1', BeastType::Magic, 1, test_address('dungeon'), test_address('p'),
            );
    }

    #[test]
    #[should_panic(expected: 'Registry: nft not set')]
    fn test_register_before_nft_wired_rejected() {
        let owner = test_address('owner');
        let provider_class = declare("stored_art_provider").unwrap().contract_class();
        let registry_class = declare("beast_registry").unwrap().contract_class();

        let mut calldata: Array<felt252> = array![];
        owner.serialize(ref calldata);
        provider_class.class_hash.serialize(ref calldata);
        let (registry_address, _) = registry_class.deploy(@calldata).unwrap();
        let registry = IBeastRegistryDispatcher { contract_address: registry_address };

        registry
            .register_beast(
                'Voidling', BeastType::Magic, 1, test_address('dungeon'), test_address('p'),
            );
    }

    #[test]
    #[should_panic(expected: 'Registry: nft already set')]
    fn test_set_nft_address_is_one_time() {
        let (registry, _, owner) = setup();
        start_cheat_caller_address(registry.contract_address, owner);
        registry.set_nft_address(test_address('other'));
    }

    #[test]
    #[should_panic(expected: 'Registry: not registered')]
    fn test_get_definition_unregistered_reverts() {
        let (registry, _, _) = setup();
        registry.get_definition(76);
    }

    #[test]
    #[should_panic(expected: 'Registry: not registered')]
    fn test_get_species_traits_genesis_id_reverts() {
        // Genesis species traits come from beast_definitions, not the registry.
        let (registry, _, _) = setup();
        registry.get_species_traits(42);
    }

    // ---------------- artist admin ----------------

    #[test]
    fn test_set_minter_and_lock() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.set_minter(beast_id, test_address('new_dungeon'));
        assert(registry.get_minter(beast_id) == test_address('new_dungeon'), 'Minter rotated');

        // Pause via zero minter.
        registry.set_minter(beast_id, 0.try_into().unwrap());
        assert(registry.get_minter(beast_id) == 0.try_into().unwrap(), 'Minter paused');

        registry.set_minter(beast_id, test_address('final_dungeon'));
        registry.lock_minter(beast_id);
        stop_cheat_caller_address(registry.contract_address);

        assert(registry.is_minter_locked(beast_id), 'Minter locked');
    }

    #[test]
    #[should_panic(expected: 'Registry: minter locked')]
    fn test_set_minter_after_lock_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.lock_minter(beast_id);
        registry.set_minter(beast_id, test_address('new_dungeon'));
    }

    #[test]
    #[should_panic(expected: 'Registry: not artist')]
    fn test_set_minter_not_artist_rejected() {
        let (registry, _, _) = setup();
        let beast_id = register_default(registry, test_address('artist'), test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, test_address('rando'));
        registry.set_minter(beast_id, test_address('evil_dungeon'));
    }

    #[test]
    fn test_update_art_and_fan_out() {
        let (registry, nft, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));
        let provider_addr = registry.get_art_provider(beast_id);

        start_cheat_caller_address(registry.contract_address, artist);
        registry
            .update_art(
                beast_id,
                "data:image/png;base64,iVBORw0KGgoBBBB1",
                "data:image/png;base64,iVBORw0KGgoBBBB2",
                "data:image/gif;base64,R0lGODdhBBB1",
                "data:image/gif;base64,R0lGODdhBBB2",
            );
        stop_cheat_caller_address(registry.contract_address);

        let art = IBeastArtProviderDispatcher { contract_address: provider_addr };
        assert(
            art
                .get_data_uri(
                    community_beast(beast_id, 0, 0),
                ) == "data:image/png;base64,iVBORw0KGgoBBBB1",
            'Art updated',
        );
        assert(nft.fan_out_count() == 1, 'Fan-out triggered');
        assert(nft.last_fan_out() == beast_id, 'Fan-out species');
    }

    #[test]
    #[should_panic(expected: 'Registry: refresh cooldown')]
    fn test_art_refresh_cooldown_shared_across_mutators() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        let (png_regular, png_shiny, gif_regular, gif_shiny) = sample_art();
        start_cheat_block_timestamp(registry.contract_address, 1000);
        start_cheat_caller_address(registry.contract_address, artist);
        registry.update_art(beast_id, png_regular, png_shiny, gif_regular, gif_shiny);
        // notify shares the same per-species cooldown as update_art.
        registry.notify_art_updated(beast_id);
    }

    #[test]
    fn test_art_refresh_allowed_after_cooldown() {
        let (registry, nft, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_block_timestamp(registry.contract_address, 1000);
        start_cheat_caller_address(registry.contract_address, artist);
        registry.notify_art_updated(beast_id);

        start_cheat_block_timestamp(registry.contract_address, 1000 + ART_REFRESH_COOLDOWN_SECONDS);
        registry.notify_art_updated(beast_id);
        stop_cheat_caller_address(registry.contract_address);

        assert(nft.fan_out_count() == 2, 'Two fan-outs');
    }

    #[test]
    #[should_panic(expected: 'Registry: not factory provider')]
    fn test_update_art_custom_provider_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');

        start_cheat_caller_address(registry.contract_address, artist);
        let beast_id = registry
            .register_beast(
                'Voidling', BeastType::Magic, 1, test_address('dungeon'), test_address('custom'),
            );
        registry.update_art(beast_id, "a", "b", "c", "d");
    }

    #[test]
    fn test_set_art_provider_recomputes_factory_flag() {
        let (registry, nft, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));
        let factory_addr = registry.get_art_provider(beast_id);

        start_cheat_block_timestamp(registry.contract_address, 1000);
        start_cheat_caller_address(registry.contract_address, artist);

        // Swap to a custom provider: factory flag drops, marketplaces are
        // refreshed atomically with the pointer change.
        registry.set_art_provider(beast_id, test_address('custom'));
        let def = registry.get_definition(beast_id);
        assert(def.art_provider == test_address('custom'), 'Swapped to custom');
        assert(!def.factory_provider, 'Factory flag cleared');
        assert(nft.fan_out_count() == 1, 'Swap fans out');

        // Swap back to the canonical factory deploy: flag restored. Swaps
        // share the art refresh cooldown, so advance past it first.
        start_cheat_block_timestamp(registry.contract_address, 1000 + ART_REFRESH_COOLDOWN_SECONDS);
        registry.set_art_provider(beast_id, factory_addr);
        let def = registry.get_definition(beast_id);
        assert(def.art_provider == factory_addr, 'Swapped back');
        assert(def.factory_provider, 'Factory flag restored');
        assert(nft.fan_out_count() == 2, 'Second swap fans out');

        stop_cheat_caller_address(registry.contract_address);
    }

    #[test]
    #[should_panic(expected: 'Registry: refresh cooldown')]
    fn test_provider_swap_shares_refresh_cooldown() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_block_timestamp(registry.contract_address, 1000);
        start_cheat_caller_address(registry.contract_address, artist);
        registry.notify_art_updated(beast_id);
        // A provider swap inside the cooldown window is rejected.
        registry.set_art_provider(beast_id, test_address('custom'));
    }

    #[test]
    #[should_panic(expected: 'Registry: art locked')]
    fn test_lock_art_blocks_update() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.lock_art(beast_id);
        registry.update_art(beast_id, "a", "b", "c", "d");
    }

    #[test]
    #[should_panic(expected: 'Registry: art locked')]
    fn test_lock_art_blocks_provider_swap() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.lock_art(beast_id);
        registry.set_art_provider(beast_id, test_address('custom'));
    }

    #[test]
    fn test_transfer_artist_role() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let new_artist = test_address('new_artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.transfer_artist_role(beast_id, new_artist);
        stop_cheat_caller_address(registry.contract_address);

        assert(registry.get_artist(beast_id) == new_artist, 'Artist transferred');

        // New artist has admin rights.
        start_cheat_caller_address(registry.contract_address, new_artist);
        registry.set_minter(beast_id, test_address('their_dungeon'));
        stop_cheat_caller_address(registry.contract_address);
    }

    #[test]
    #[should_panic(expected: 'Registry: not artist')]
    fn test_old_artist_loses_rights_after_transfer() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.transfer_artist_role(beast_id, test_address('new_artist'));
        registry.set_minter(beast_id, test_address('their_dungeon'));
    }

    #[test]
    #[should_panic(expected: 'Registry: zero artist')]
    fn test_transfer_artist_to_zero_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry.transfer_artist_role(beast_id, 0.try_into().unwrap());
    }

    #[test]
    fn test_set_stats_source_src5_verified() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        assert(registry.get_stats_source(beast_id) == 0.try_into().unwrap(), 'Stats default off');

        let stats_class = declare("mock_stats_source").unwrap().contract_class();
        let (stats_addr, _) = stats_class.deploy(@array![1]).unwrap(); // compliant = true

        start_cheat_caller_address(registry.contract_address, artist);
        registry.set_stats_source(beast_id, stats_addr);
        assert(registry.get_stats_source(beast_id) == stats_addr, 'Stats source set');

        // Zero clears without any external call.
        registry.set_stats_source(beast_id, 0.try_into().unwrap());
        stop_cheat_caller_address(registry.contract_address);
        assert(registry.get_stats_source(beast_id) == 0.try_into().unwrap(), 'Stats cleared');
    }

    #[test]
    #[should_panic(expected: 'Registry: bad stats source')]
    fn test_set_stats_source_non_compliant_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        let stats_class = declare("mock_stats_source").unwrap().contract_class();
        let (stats_addr, _) = stats_class.deploy(@array![0]).unwrap(); // compliant = false

        start_cheat_caller_address(registry.contract_address, artist);
        registry.set_stats_source(beast_id, stats_addr);
    }

    // Note: setting an undeployed address as stats source reverts on-network
    // (the SRC5 probe is a call to a non-existent contract). snforge surfaces
    // that as a runner-level error rather than a catchable panic, so it is
    // not expressible as a #[should_panic] test.

    // ---------------- art content validation ----------------

    #[test]
    #[should_panic(expected: 'Provider: bad art payload')]
    fn test_update_art_quote_payload_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        // A single quote would escape the SVG src attribute the renderer
        // embeds this URI into.
        registry
            .update_art(
                beast_id,
                "data:image/png;base64,iVBORw0KGgo'AAAA",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    #[test]
    #[should_panic(expected: 'Provider: bad art length')]
    fn test_update_art_bad_base64_length_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        // 13-character payload: not a multiple of 4.
        registry
            .update_art(
                beast_id,
                "data:image/png;base64,iVBORw0KGgoAA",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    #[test]
    #[should_panic(expected: 'Provider: bad art payload')]
    fn test_update_art_mid_padding_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        // '=' before the final two positions is structurally invalid base64.
        registry
            .update_art(
                beast_id,
                "data:image/png;base64,iVBORw0KGgo=AAAA",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    #[test]
    #[should_panic(expected: 'Provider: bad art magic')]
    fn test_update_art_wrong_magic_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        // Valid base64, but not a PNG: missing the encoded PNG signature.
        registry
            .update_art(
                beast_id,
                "data:image/png;base64,QUJDREVGR0hJSks=",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    #[test]
    #[should_panic(expected: 'Provider: bad art prefix')]
    fn test_update_art_wrong_prefix_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        // A GIF data URI in a PNG slot fails the exact-prefix check.
        registry
            .update_art(
                beast_id,
                "data:image/gif;base64,AA==",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    #[test]
    #[should_panic(expected: 'Provider: bad art prefix')]
    fn test_update_art_empty_payload_rejected() {
        let (registry, _, _) = setup();
        let artist = test_address('artist');
        let beast_id = register_default(registry, artist, test_address('dungeon'));

        start_cheat_caller_address(registry.contract_address, artist);
        registry
            .update_art(
                beast_id,
                "data:image/png;base64,",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    #[test]
    #[should_panic]
    fn test_register_with_markup_art_rejected() {
        let (registry, _, _) = setup();
        // Validation also runs in the factory provider's constructor, so a
        // registration carrying active content fails outright.
        start_cheat_caller_address(registry.contract_address, test_address('artist'));
        registry
            .register_beast_with_art(
                'Gloomfang',
                BeastType::Hunter,
                3,
                test_address('dungeon'),
                "data:image/svg+xml,<svg onload=evil>",
                "data:image/png;base64,AA==",
                "data:image/gif;base64,AA==",
                "data:image/gif;base64,AA==",
            );
    }

    // ---------------- stored art provider gating ----------------

    #[test]
    #[should_panic(expected: 'Provider: not registry')]
    fn test_provider_set_art_not_registry_rejected() {
        let (registry, _, _) = setup();
        let beast_id = register_default(registry, test_address('artist'), test_address('dungeon'));
        let provider = IStoredArtProviderDispatcher {
            contract_address: registry.get_art_provider(beast_id),
        };

        // Direct call bypassing the registry must fail, even from the artist.
        start_cheat_caller_address(provider.contract_address, test_address('artist'));
        provider.set_art(beast_id, "a", "b", "c", "d");
    }

    #[test]
    #[should_panic(expected: 'Provider: wrong species')]
    fn test_provider_rejects_wrong_species_render() {
        let (registry, _, _) = setup();
        let beast_id = register_default(registry, test_address('artist'), test_address('dungeon'));
        let art = IBeastArtProviderDispatcher {
            contract_address: registry.get_art_provider(beast_id),
        };

        art.get_data_uri(community_beast(beast_id + 1, 0, 0));
    }
}
