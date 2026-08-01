//! End-to-end tests across the real NFT and the real registry.
//!
//! `beast_registry_tests` exercises the registry against a mock NFT; this
//! file wires the two production contracts together, which is the only place
//! the round trip is proven: register -> provenance mint -> species mint ->
//! render.

/// Community art provider that returns whatever it was constructed with,
/// including deliberately malformed payloads. Stands in for the arbitrary
/// artist-controlled contract that `register_beast` accepts.
#[starknet::contract]
pub mod mock_art_provider {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::super::interfaces::IBeastArtProvider;
    use super::super::pack::PackableBeast;

    #[storage]
    struct Storage {
        uri: ByteArray,
    }

    #[constructor]
    fn constructor(ref self: ContractState, uri: ByteArray) {
        self.uri.write(uri);
    }

    #[abi(embed_v0)]
    impl BeastArtProviderImpl of IBeastArtProvider<ContractState> {
        fn get_data_uri(self: @ContractState, beast: PackableBeast) -> ByteArray {
            self.uri.read()
        }
    }
}

/// SRC5-compliant stats source with settable values, so a refresh can be
/// observed changing and then going stale.
#[starknet::contract]
pub mod mock_stats_feed {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::super::interfaces::{BeastLiveStats, IBEAST_STATS_ID, IBeastStats};

    #[starknet::interface]
    pub trait IMockStatsAdmin<TContractState> {
        fn set_stats(ref self: TContractState, killed: u64, by: u64, ts: u64);
        fn supports_interface(self: @TContractState, interface_id: felt252) -> bool;
    }

    #[storage]
    struct Storage {
        killed: u64,
        by: u64,
        ts: u64,
    }

    #[abi(embed_v0)]
    impl BeastStatsImpl of IBeastStats<ContractState> {
        fn get_beast_stats(self: @ContractState, entity_hash: felt252) -> BeastLiveStats {
            BeastLiveStats {
                adventurers_killed: self.killed.read(),
                last_killed_by: self.by.read(),
                last_killed_timestamp: self.ts.read(),
            }
        }
    }

    #[abi(embed_v0)]
    impl MockStatsAdminImpl of IMockStatsAdmin<ContractState> {
        fn set_stats(ref self: ContractState, killed: u64, by: u64, ts: u64) {
            self.killed.write(killed);
            self.by.write(by);
            self.ts.write(ts);
        }

        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            interface_id == IBEAST_STATS_ID
        }
    }
}

#[cfg(test)]
mod tests {
    use beasts_nft::interfaces::{
        BeastType, IBeastRegistryDispatcher, IBeastRegistryDispatcherTrait, IBeastsDispatcher,
        IBeastsDispatcherTrait, IBeastsOwnerEnumerableDispatcher,
        IBeastsOwnerEnumerableDispatcherTrait, IBeastsProvenanceDispatcher,
        IBeastsProvenanceDispatcherTrait,
    };
    use openzeppelin_interfaces::erc721::{
        IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher,
        IERC721MetadataDispatcherTrait,
    };
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, EventSpyTrait, EventsFilterTrait, declare,
        spy_events, start_cheat_caller_address, start_mock_call, stop_cheat_caller_address,
    };
    use starknet::ContractAddress;
    use super::mock_stats_feed::{IMockStatsAdminDispatcher, IMockStatsAdminDispatcherTrait};

    const FIRST_COMMUNITY_ID: u64 = 76;

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    fn zero_address() -> ContractAddress {
        0.try_into().unwrap()
    }

    fn sample_art() -> (ByteArray, ByteArray, ByteArray, ByteArray) {
        (
            "data:image/png;base64,iVBORw0KGgoAAAA1",
            "data:image/png;base64,iVBORw0KGgoAAAA2",
            "data:image/gif;base64,R0lGODdhAAA1",
            "data:image/gif;base64,R0lGODdhAAA2",
        )
    }

    #[derive(Drop, Copy)]
    struct Stack {
        nft: IBeastsDispatcher,
        registry: IBeastRegistryDispatcher,
        owner: ContractAddress,
    }

    /// Deploys the real registry and the real NFT and wires the two one-way
    /// pointers that make registration possible.
    fn setup() -> Stack {
        let owner = test_address('owner');

        // The four genesis art contracts are out of scope here; one mocked
        // address serves all of them.
        let legacy_provider = test_address('legacy_art');
        let legacy_uri: ByteArray = "data:image/png;base64,iVBORw0KGgoAAAA1";
        start_mock_call(legacy_provider, selector!("get_data_uri"), legacy_uri);

        let provider_class = declare("stored_art_provider").unwrap().contract_class();
        let registry_class = declare("beast_registry").unwrap().contract_class();
        let nft_class = declare("beasts_nft").unwrap().contract_class();

        let mut registry_calldata: Array<felt252> = array![];
        owner.serialize(ref registry_calldata);
        provider_class.class_hash.serialize(ref registry_calldata);
        let (registry_address, _) = registry_class.deploy(@registry_calldata).unwrap();

        let name: ByteArray = "Beasts";
        let symbol: ByteArray = "BEAST";
        let mut nft_calldata: Array<felt252> = array![];
        name.serialize(ref nft_calldata);
        symbol.serialize(ref nft_calldata);
        owner.serialize(ref nft_calldata);
        owner.serialize(ref nft_calldata);
        500_u128.serialize(ref nft_calldata);
        legacy_provider.serialize(ref nft_calldata);
        legacy_provider.serialize(ref nft_calldata);
        legacy_provider.serialize(ref nft_calldata);
        legacy_provider.serialize(ref nft_calldata);
        zero_address().serialize(ref nft_calldata);
        let (nft_address, _) = nft_class.deploy(@nft_calldata).unwrap();

        let registry = IBeastRegistryDispatcher { contract_address: registry_address };
        let nft = IBeastsDispatcher { contract_address: nft_address };

        start_cheat_caller_address(registry_address, owner);
        registry.set_nft_address(nft_address);
        stop_cheat_caller_address(registry_address);

        start_cheat_caller_address(nft_address, owner);
        nft.set_registry_address(registry_address);
        stop_cheat_caller_address(nft_address);

        Stack { nft, registry, owner }
    }

    fn register_with_factory_art(
        stack: @Stack, artist: ContractAddress, minter: ContractAddress,
    ) -> u64 {
        let (png_regular, png_shiny, gif_regular, gif_shiny) = sample_art();
        start_cheat_caller_address(*stack.registry.contract_address, artist);
        let beast_id = (*stack.registry)
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
        stop_cheat_caller_address(*stack.registry.contract_address);
        beast_id
    }

    fn deploy_art_provider(uri: ByteArray) -> ContractAddress {
        let class = declare("mock_art_provider").unwrap().contract_class();
        let mut calldata: Array<felt252> = array![];
        uri.serialize(ref calldata);
        let (address, _) = class.deploy(@calldata).unwrap();
        address
    }

    fn register_with_custom_provider(
        stack: @Stack, artist: ContractAddress, minter: ContractAddress, provider: ContractAddress,
    ) -> u64 {
        start_cheat_caller_address(*stack.registry.contract_address, artist);
        let beast_id = (*stack.registry)
            .register_beast('Gloomfang', BeastType::Hunter, 3, minter, provider);
        stop_cheat_caller_address(*stack.registry.contract_address);
        beast_id
    }

    fn mint_community(
        stack: @Stack, minter: ContractAddress, to: ContractAddress, beast_id: u64, prefix: u8,
    ) -> u256 {
        start_cheat_caller_address(*stack.nft.contract_address, minter);
        let (token_id, _, _) = (*stack.nft).mint(to, beast_id, prefix, 1, 10, 100, 0, 0);
        stop_cheat_caller_address(*stack.nft.contract_address);
        token_id
    }

    // ---------------- wiring ----------------

    #[test]
    fn test_registry_wiring_is_visible_both_ways() {
        let stack = setup();
        assert(
            stack.nft.get_registry_address() == stack.registry.contract_address,
            'NFT points at registry',
        );
        assert(
            stack.registry.get_nft_address() == stack.nft.contract_address,
            'Registry points at NFT',
        );
    }

    #[test]
    #[should_panic(expected: ('Registry already set',))]
    fn test_set_registry_address_is_one_time() {
        let stack = setup();
        start_cheat_caller_address(stack.nft.contract_address, stack.owner);
        stack.nft.set_registry_address(test_address('other_registry'));
        stop_cheat_caller_address(stack.nft.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_set_registry_address_only_owner() {
        let stack = setup();
        start_cheat_caller_address(stack.nft.contract_address, test_address('intruder'));
        stack.nft.set_registry_address(test_address('other_registry'));
        stop_cheat_caller_address(stack.nft.contract_address);
    }

    // ---------------- registration -> provenance mint ----------------

    #[test]
    fn test_registration_mints_genesis_to_artist() {
        let stack = setup();
        let artist = test_address('artist');
        let beast_id = register_with_factory_art(@stack, artist, test_address('dungeon'));

        assert(beast_id == FIRST_COMMUNITY_ID, 'First community ID is 76');
        // 75 genesis species from the constructor plus this one.
        assert(stack.nft.total_supply() == 76, 'Supply grew by one');
        assert(stack.nft.is_minted(beast_id, 0, 0), 'Genesis slot reserved');

        // The Genesis Beast is the artist's provenance token.
        let genesis_token = stack.nft.get_token_id_at_rank(beast_id, 0);
        assert(genesis_token == 0, 'Genesis is not ranked');

        let erc721 = IERC721Dispatcher { contract_address: stack.nft.contract_address };
        assert(erc721.balance_of(artist) == 1, 'Artist holds provenance token');
    }

    #[test]
    fn test_registered_species_renders_through_registry_art() {
        let stack = setup();
        let artist = test_address('artist');
        let minter = test_address('dungeon');
        let beast_id = register_with_factory_art(@stack, artist, minter);

        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);

        let metadata = IERC721MetadataDispatcher { contract_address: stack.nft.contract_address };
        let uri = metadata.token_uri(token_id);
        assert(uri.len() > 0, 'Renders non-empty metadata');

        // Rendering must go through the base64 JSON envelope like any token.
        let prefix: ByteArray = "data:application/json;base64,";
        let mut i = 0;
        while i < prefix.len() {
            assert(uri.at(i).unwrap() == prefix.at(i).unwrap(), 'JSON data URI prefix');
            i += 1;
        }
    }

    #[test]
    #[should_panic(expected: ('Only registry', 'ENTRYPOINT_FAILED'))]
    fn test_mint_provenance_only_callable_by_registry() {
        let stack = setup();
        let provenance = IBeastsProvenanceDispatcher {
            contract_address: stack.nft.contract_address,
        };
        start_cheat_caller_address(stack.nft.contract_address, test_address('intruder'));
        provenance.mint_provenance(test_address('intruder'), 76);
        stop_cheat_caller_address(stack.nft.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Only registry', 'ENTRYPOINT_FAILED'))]
    fn test_emit_species_metadata_update_only_callable_by_registry() {
        let stack = setup();
        let provenance = IBeastsProvenanceDispatcher {
            contract_address: stack.nft.contract_address,
        };
        start_cheat_caller_address(stack.nft.contract_address, test_address('intruder'));
        provenance.emit_species_metadata_update(76);
        stop_cheat_caller_address(stack.nft.contract_address);
    }

    // ---------------- the Genesis Beast is the artist role ----------------

    #[test]
    fn test_selling_the_genesis_beast_hands_over_the_species() {
        // Against the real NFT, not a mock: the registry asks it who holds
        // the creator token, so an ordinary ERC721 transfer — a marketplace
        // sale — has to move control of the species with it.
        let stack = setup();
        let artist = test_address('artist');
        let buyer = test_address('buyer');
        let beast_id = register_with_factory_art(@stack, artist, test_address('dungeon'));

        let genesis = stack.registry.get_genesis_token_id(beast_id);
        assert(stack.registry.get_artist(beast_id) == artist, 'Registrant is the artist');

        let erc721 = IERC721Dispatcher { contract_address: stack.nft.contract_address };
        start_cheat_caller_address(erc721.contract_address, artist);
        erc721.transfer_from(artist, buyer, genesis);
        stop_cheat_caller_address(erc721.contract_address);

        assert(stack.registry.get_artist(beast_id) == buyer, 'Buyer is now the artist');

        start_cheat_caller_address(stack.registry.contract_address, buyer);
        stack.registry.set_minter(beast_id, test_address('their_dungeon'));
        stop_cheat_caller_address(stack.registry.contract_address);
        assert(
            stack.registry.get_minter(beast_id) == test_address('their_dungeon'),
            'Buyer can administer',
        );
    }

    #[test]
    #[should_panic(expected: ('Registry: not artist', 'ENTRYPOINT_FAILED'))]
    fn test_seller_loses_control_with_the_token() {
        let stack = setup();
        let artist = test_address('artist');
        let beast_id = register_with_factory_art(@stack, artist, test_address('dungeon'));

        let erc721 = IERC721Dispatcher { contract_address: stack.nft.contract_address };
        start_cheat_caller_address(erc721.contract_address, artist);
        erc721
            .transfer_from(
                artist, test_address('buyer'), stack.registry.get_genesis_token_id(beast_id),
            );
        stop_cheat_caller_address(erc721.contract_address);

        start_cheat_caller_address(stack.registry.contract_address, artist);
        stack.registry.set_minter(beast_id, test_address('their_dungeon'));
    }

    #[test]
    fn test_enumeration_finds_the_species_a_wallet_controls() {
        // The whole point of pairing enumeration with the derived role: a
        // client can list a wallet's tokens, decode each one locally, and
        // know which species it administers — no registry reads, no events.
        let stack = setup();
        let artist = test_address('artist');
        let first = register_with_factory_art(@stack, artist, test_address('dungeon'));

        let enumerable = IBeastsOwnerEnumerableDispatcher {
            contract_address: stack.nft.contract_address,
        };
        let erc721 = IERC721Dispatcher { contract_address: stack.nft.contract_address };

        assert(erc721.balance_of(artist) == 1, 'Artist holds one token');
        let token = enumerable.token_of_owner_by_index(artist, 0);
        assert(token == stack.registry.get_genesis_token_id(first), 'Enumerates the genesis');

        // Decoding it locally recovers the species with no further reads.
        let beast = stack.nft.get_beast(token);
        assert(beast.id == first, 'Species recovered from token');
        assert(beast.prefix == 0 && beast.suffix == 0, 'It is the Genesis Beast');
        assert(stack.registry.get_artist(beast.id) == artist, 'And the wallet controls it');
    }

    // ---------------- per-species mint authorization ----------------

    #[test]
    fn test_species_minter_can_mint() {
        let stack = setup();
        let minter = test_address('dungeon');
        let player = test_address('player');
        let beast_id = register_with_factory_art(@stack, test_address('artist'), minter);

        let token_id = mint_community(@stack, minter, player, beast_id, 1);

        let erc721 = IERC721Dispatcher { contract_address: stack.nft.contract_address };
        assert(erc721.owner_of(token_id) == player, 'Player owns the mint');

        let beast = stack.nft.get_beast(token_id);
        assert(beast.id == beast_id, 'Species encoded in token');
        assert(beast.tier == 3, 'Registry tier encoded');
        assert(beast.beast_type == 1, 'Registry type encoded');
    }

    #[test]
    #[should_panic(expected: ('Not authorized to mint',))]
    fn test_dungeon_address_cannot_mint_community_species() {
        // The global dungeon address governs genesis species only. Community
        // species answer to their own registered minter.
        let stack = setup();
        let dungeon = test_address('global_dungeon');
        start_cheat_caller_address(stack.nft.contract_address, stack.owner);
        stack.nft.set_dungeon_address(dungeon);
        stop_cheat_caller_address(stack.nft.contract_address);

        let beast_id = register_with_factory_art(
            @stack, test_address('artist'), test_address('species_minter'),
        );

        mint_community(@stack, dungeon, test_address('player'), beast_id, 1);
    }

    #[test]
    #[should_panic(expected: ('Species minting paused',))]
    fn test_zero_minter_species_cannot_be_minted() {
        let stack = setup();
        let beast_id = register_with_factory_art(@stack, test_address('artist'), zero_address());

        mint_community(@stack, zero_address(), test_address('player'), beast_id, 1);
    }

    #[test]
    #[should_panic(
        expected: ('Registry: not registered', 'ENTRYPOINT_FAILED', 'ENTRYPOINT_FAILED'),
    )]
    fn test_unregistered_species_cannot_be_minted() {
        let stack = setup();
        mint_community(@stack, test_address('anyone'), test_address('player'), 9_999, 1);
    }

    #[test]
    fn test_minter_change_moves_authorization() {
        let stack = setup();
        let artist = test_address('artist');
        let first_minter = test_address('first');
        let second_minter = test_address('second');
        let beast_id = register_with_factory_art(@stack, artist, first_minter);

        start_cheat_caller_address(stack.registry.contract_address, artist);
        stack.registry.set_minter(beast_id, second_minter);
        stop_cheat_caller_address(stack.registry.contract_address);

        let token_id = mint_community(@stack, second_minter, test_address('player'), beast_id, 1);
        assert(token_id != 0, 'New minter can mint');
    }

    // ---------------- untrusted art provider output ----------------

    #[test]
    #[should_panic(expected: ('Art: bad payload',))]
    fn test_provider_attribute_escape_rejected_at_render() {
        // A custom provider is an arbitrary contract; the payload below would
        // close the SVG's src='...' attribute if it were embedded verbatim.
        let stack = setup();
        let minter = test_address('dungeon');
        let provider = deploy_art_provider("data:image/png;base64,AAAA'AAA");
        let beast_id = register_with_custom_provider(
            @stack, test_address('artist'), minter, provider,
        );

        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);
        let metadata = IERC721MetadataDispatcher { contract_address: stack.nft.contract_address };
        metadata.token_uri(token_id);
    }

    #[test]
    #[should_panic(expected: ('Art: bad media type',))]
    fn test_provider_non_image_media_type_rejected_at_render() {
        let stack = setup();
        let minter = test_address('dungeon');
        let provider = deploy_art_provider("data:text/html;base64,PHNjcmlwdD4=");
        let beast_id = register_with_custom_provider(
            @stack, test_address('artist'), minter, provider,
        );

        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);
        let metadata = IERC721MetadataDispatcher { contract_address: stack.nft.contract_address };
        metadata.token_uri(token_id);
    }

    #[test]
    fn test_provider_svg_output_accepted_at_render() {
        let stack = setup();
        let minter = test_address('dungeon');
        let provider = deploy_art_provider("data:image/svg+xml;base64,PHN2Zy8+");
        let beast_id = register_with_custom_provider(
            @stack, test_address('artist'), minter, provider,
        );

        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);
        let metadata = IERC721MetadataDispatcher { contract_address: stack.nft.contract_address };
        assert(metadata.token_uri(token_id).len() > 0, 'SVG art renders');
    }

    // ---------------- cached stats ----------------

    fn deploy_stats_source() -> IMockStatsAdminDispatcher {
        let class = declare("mock_stats_feed").unwrap().contract_class();
        let (address, _) = class.deploy(@array![]).unwrap();
        IMockStatsAdminDispatcher { contract_address: address }
    }

    #[test]
    fn test_refresh_stats_caches_values() {
        let stack = setup();
        let artist = test_address('artist');
        let minter = test_address('dungeon');
        let beast_id = register_with_factory_art(@stack, artist, minter);
        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);

        let source = deploy_stats_source();
        source.set_stats(7, 1234, 1_700_000_000);

        start_cheat_caller_address(stack.registry.contract_address, artist);
        stack.registry.set_stats_source(beast_id, source.contract_address);
        stop_cheat_caller_address(stack.registry.contract_address);

        let before = stack.nft.get_cached_stats(token_id);
        assert(before.adventurers_killed == 0, 'Cache starts empty');

        stack.nft.refresh_stats(token_id);

        let after = stack.nft.get_cached_stats(token_id);
        assert(after.adventurers_killed == 7, 'Kills cached');
        assert(after.last_killed_by == 1234, 'Killer cached');
        assert(after.last_killed_timestamp == 1_700_000_000, 'Timestamp cached');
    }

    #[test]
    #[should_panic(expected: ('Stats up to date',))]
    fn test_refresh_stats_rejects_unchanged_values() {
        // Without this guard the entrypoint is a free ERC-4906 spam faucet.
        let stack = setup();
        let artist = test_address('artist');
        let minter = test_address('dungeon');
        let beast_id = register_with_factory_art(@stack, artist, minter);
        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);

        let source = deploy_stats_source();
        source.set_stats(7, 1234, 1_700_000_000);
        start_cheat_caller_address(stack.registry.contract_address, artist);
        stack.registry.set_stats_source(beast_id, source.contract_address);
        stop_cheat_caller_address(stack.registry.contract_address);

        stack.nft.refresh_stats(token_id);
        stack.nft.refresh_stats(token_id);
    }

    #[test]
    #[should_panic(expected: ('No stats source',))]
    fn test_refresh_stats_requires_a_source() {
        let stack = setup();
        let minter = test_address('dungeon');
        let beast_id = register_with_factory_art(@stack, test_address('artist'), minter);
        let token_id = mint_community(@stack, minter, test_address('player'), beast_id, 1);

        stack.nft.refresh_stats(token_id);
    }

    #[test]
    #[should_panic(expected: ('Genesis stats are live',))]
    fn test_refresh_stats_rejects_genesis_species() {
        // Species 1-75 read Death Mountain live; there is no cache to fill.
        let stack = setup();
        let dungeon = test_address('dungeon');
        start_cheat_caller_address(stack.nft.contract_address, stack.owner);
        stack.nft.set_dungeon_address(dungeon);
        stop_cheat_caller_address(stack.nft.contract_address);

        start_cheat_caller_address(stack.nft.contract_address, dungeon);
        let (token_id, _, _) = stack.nft.mint(test_address('player'), 3, 1, 1, 10, 100, 0, 0);
        stop_cheat_caller_address(stack.nft.contract_address);

        stack.nft.refresh_stats(token_id);
    }

    // ---------------- metadata fan-out ----------------

    #[test]
    fn test_fan_out_covers_genesis_token_and_every_mint() {
        let stack = setup();
        let artist = test_address('artist');
        let minter = test_address('dungeon');
        // A custom provider keeps the refresh path open after registration
        // without needing to re-upload art.
        let provider = deploy_art_provider("data:image/png;base64,iVBORw0KGgoAAAA1");
        let beast_id = register_with_custom_provider(@stack, artist, minter, provider);

        mint_community(@stack, minter, test_address('player1'), beast_id, 1);
        mint_community(@stack, minter, test_address('player2'), beast_id, 2);
        mint_community(@stack, minter, test_address('player3'), beast_id, 3);

        let mut spy = spy_events();
        start_cheat_caller_address(stack.registry.contract_address, artist);
        stack.registry.notify_art_updated(beast_id);
        stop_cheat_caller_address(stack.registry.contract_address);

        // The Genesis Beast holds rank 0 and lives outside the species list;
        // a list-only walk would leave the artist's own token stale.
        let emitted = spy.get_events().emitted_by(stack.nft.contract_address);
        assert(emitted.events.len() == 4, 'Genesis plus three mints');
    }

    #[test]
    fn test_fan_out_before_any_mint_covers_genesis_only() {
        let stack = setup();
        let artist = test_address('artist');
        let provider = deploy_art_provider("data:image/png;base64,iVBORw0KGgoAAAA1");
        let beast_id = register_with_custom_provider(
            @stack, artist, test_address('dungeon'), provider,
        );

        let mut spy = spy_events();
        start_cheat_caller_address(stack.registry.contract_address, artist);
        stack.registry.notify_art_updated(beast_id);
        stop_cheat_caller_address(stack.registry.contract_address);

        let emitted = spy.get_events().emitted_by(stack.nft.contract_address);
        assert(emitted.events.len() == 1, 'Genesis token only');
    }
}
