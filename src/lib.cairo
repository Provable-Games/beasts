pub mod art_validation;
pub mod beast_definitions;
pub mod beast_gif_regular_data;
pub mod beast_gif_shiny_data;
pub mod beast_images;
pub mod beast_manager;
pub mod beast_png_regular_data;
pub mod beast_png_shiny_data;
pub mod beast_ranking;
pub mod beast_registry;
#[cfg(test)]
mod beast_registry_tests;
pub mod beast_svg;
pub mod encoding;
pub mod enumerable;
#[cfg(test)]
mod enumerable_tests;
pub mod interfaces;
pub mod metadata_generator;
#[cfg(test)]
mod mint_tests;
pub mod minting_coordinator;
pub mod pack;
#[cfg(test)]
mod registry_integration_tests;
pub mod stats_cache;
pub mod stored_art_provider;
#[cfg(test)]
mod tests;
pub mod utils;

// Minimal view interface to expose `animation_url` alongside `token_uri`.
// This mirrors the output of `token_uri` so marketplaces can use it for rich views.
#[starknet::interface]
pub trait IBeastsAnimation<TContractState> {
    fn animation_url(self: @TContractState, token_id: u256) -> ByteArray;
}

#[starknet::contract]
pub mod beasts_nft {
    use core::num::traits::Zero;
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_interfaces::erc721::IERC721Metadata;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::common::erc2981::ERC2981Component;
    use openzeppelin_token::erc721::ERC721Component;
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use super::art_validation::assert_valid_render_uri;
    use super::beast_manager::{BeastManagerTrait, BeastResult, GENESIS_SPECIES_MAX};
    use super::beast_ranking::BeastRankingManagerTrait;
    use super::enumerable::EnumerableComponent;
    use super::interfaces::{
        BeastLiveStats, IBeastArtProviderDispatcher, IBeastArtProviderDispatcherTrait,
        IBeastImageDataProviderDispatcher, IBeastImageDataProviderDispatcherTrait,
        IBeastRegistryDispatcher, IBeastRegistryDispatcherTrait, IBeastStatsDispatcher,
        IBeastStatsDispatcherTrait, IBeastSystemsDispatcher, IBeastSystemsDispatcherTrait, IBeasts,
        IBeastsAnimation, IBeastsProvenance,
    };
    use super::metadata_generator::MetadataGeneratorTrait;
    use super::minting_coordinator::{MintRequest, MintingCoordinatorTrait};
    use super::pack::{PackableBeast, decode_token_id};
    use super::stats_cache::CachedStats;

    /// Per-transaction cap on ERC-4906 fan-out. A species tops out at 1,243
    /// tokens, so a full refresh can exceed one block's budget; the overflow
    /// is bookmarked and drained by `refresh_metadata`.
    const FAN_OUT_LIMIT: u16 = 650;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: ERC2981Component, storage: erc2981, event: ERC2981Event);
    component!(path: EnumerableComponent, storage: erc721_enumerable, event: EnumerableEvent);

    // Ownable Mixin
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // ERC721 Implementation
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnlyImpl = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    // Owner enumeration
    #[abi(embed_v0)]
    impl EnumerableImpl = EnumerableComponent::EnumerableImpl<ContractState>;
    impl EnumerableInternalImpl = EnumerableComponent::InternalImpl<ContractState>;

    /// Keeps the owner index in step with every mint and transfer. The
    /// component reads pre-update balances, so it must run in `before_update`
    /// and not `after_update`.
    impl ERC721EnumerableHooks of ERC721Component::ERC721HooksTrait<ContractState> {
        fn before_update(
            ref self: ERC721Component::ComponentState<ContractState>,
            to: ContractAddress,
            token_id: u256,
            auth: ContractAddress,
        ) {
            let mut contract_state = self.get_contract_mut();
            contract_state.erc721_enumerable.before_update(to, token_id);
        }
    }

    // SRC5 Implementation
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl SRC5InternalImpl = SRC5Component::InternalImpl<ContractState>;

    // ERC2981 Implementation
    #[abi(embed_v0)]
    impl ERC2981Impl = ERC2981Component::ERC2981Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC2981AdminOwnableImpl =
        ERC2981Component::ERC2981AdminOwnableImpl<ContractState>;
    impl ERC2981InternalImpl = ERC2981Component::InternalImpl<ContractState>;

    impl ERC2981ImmutableConfig of ERC2981Component::ImmutableConfig {
        const FEE_DENOMINATOR: u128 = 10_000; // 10,000 = 100% (so 500 = 5%)
    }

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        pub erc721: ERC721Component::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage,
        #[substorage(v0)]
        pub erc2981: ERC2981Component::Storage,
        #[substorage(v0)]
        pub erc721_enumerable: EnumerableComponent::Storage,
        // Beast-specific storage
        pub beast_token_ranks: Map<u256, u16>, // token_id -> current rank (for tokenURI)
        pub beast_species_lists: Map<
            u64, Map<u16, u256>,
        >, // beast_id -> rank -> token_id (nested map)
        pub beast_counts: Map<u64, u16>, // beast_id -> count of beasts
        pub beast_metadata_refresh_bookmark: Map<u64, u16>, // beast_id -> count of updates
        pub last_manual_metadata_refresh: Map<u256, u64>, // token_id -> timestamp of last update
        pub minted: Map<felt252, bool>,
        pub dungeon_address: ContractAddress,
        pub supply_count: u256,
        /// Permissionless species registry. Community species (76+) resolve
        /// their minter, traits, name, art provider, and stats source here.
        pub registry: IBeastRegistryDispatcher,
        /// Community-species stats, pulled by `refresh_stats` rather than read
        /// live, so an artist-nominated stats source can never brick
        /// `token_uri`. See `stats_cache`.
        pub cached_stats: Map<u256, CachedStats>,
        // External data providers
        pub regular_png_provider: IBeastImageDataProviderDispatcher,
        pub shiny_png_provider: IBeastImageDataProviderDispatcher,
        pub regular_gif_provider: IBeastImageDataProviderDispatcher,
        pub shiny_gif_provider: IBeastImageDataProviderDispatcher,
        pub death_mountain_dispatcher: IBeastSystemsDispatcher,
    }

    #[derive(Drop, starknet::Event)]
    pub struct MetadataUpdate {
        #[key]
        pub token_id: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        ERC2981Event: ERC2981Component::Event,
        #[flat]
        EnumerableEvent: EnumerableComponent::Event,
        MetadataUpdate: MetadataUpdate,
    }

    /// Assigns `owner` as the contract owner.
    /// Sets the token `name` and `symbol`.
    /// Sets the base URI.
    /// Sets default royalty info.
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        owner: ContractAddress,
        royalty_receiver: ContractAddress,
        royalty_fraction: u128,
        regular_png_provider: ContractAddress,
        shiny_png_provider: ContractAddress,
        regular_gif_provider: ContractAddress,
        shiny_gif_provider: ContractAddress,
        death_mountain_address: ContractAddress,
    ) {
        self.ownable.initializer(owner);
        self.erc721.initializer(name, symbol, "");
        self.erc721_enumerable.initializer();
        self.erc2981.initializer(royalty_receiver, royalty_fraction);

        // Store external image data dispatchers
        let regular_png_provider = IBeastImageDataProviderDispatcher {
            contract_address: regular_png_provider,
        };
        let shiny_png_provider = IBeastImageDataProviderDispatcher {
            contract_address: shiny_png_provider,
        };
        let regular_gif_provider = IBeastImageDataProviderDispatcher {
            contract_address: regular_gif_provider,
        };
        let shiny_gif_provider = IBeastImageDataProviderDispatcher {
            contract_address: shiny_gif_provider,
        };

        self.regular_png_provider.write(regular_png_provider);
        self.shiny_png_provider.write(shiny_png_provider);
        self.regular_gif_provider.write(regular_gif_provider);
        self.shiny_gif_provider.write(shiny_gif_provider);

        if death_mountain_address != Zero::zero() {
            self
                .death_mountain_dispatcher
                .write(IBeastSystemsDispatcher { contract_address: death_mountain_address });
        }

        InternalTrait::mint_genesis_beasts(ref self, owner);
    }

    // IBeasts Implementation
    #[abi(embed_v0)]
    impl BeastsImpl of IBeasts<ContractState> {
        fn set_dungeon_address(ref self: ContractState, address: ContractAddress) {
            self.ownable.assert_only_owner();
            self.dungeon_address.write(address);
        }

        fn get_dungeon_address(self: @ContractState) -> ContractAddress {
            self.dungeon_address.read()
        }

        fn set_death_mountain_address(ref self: ContractState, death_mountain: ContractAddress) {
            self.ownable.assert_only_owner();
            self
                .death_mountain_dispatcher
                .write(IBeastSystemsDispatcher { contract_address: death_mountain });
        }

        fn get_death_mountain_address(self: @ContractState) -> ContractAddress {
            self.death_mountain_dispatcher.read().contract_address
        }

        /// Wires the permissionless species registry. Write-once: the
        /// registry is the sole authority over who may mint every community
        /// species, and it holds a matching one-way pointer back here, so a
        /// later swap would orphan every registered species and let a new
        /// registry mint into their reserved affix slots.
        fn set_registry_address(ref self: ContractState, registry: ContractAddress) {
            self.ownable.assert_only_owner();
            assert(self.registry.read().contract_address.is_zero(), 'Registry already set');
            assert(registry.is_non_zero(), 'Zero registry');
            self.registry.write(IBeastRegistryDispatcher { contract_address: registry });
        }

        fn get_registry_address(self: @ContractState) -> ContractAddress {
            self.registry.read().contract_address
        }

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast_id: u64,
            prefix: u8,
            suffix: u8,
            level: u16,
            health: u16,
            shiny: u8,
            animated: u8,
        ) -> (u256, u16, bool) {
            // Authorize the caller and resolve the species' static traits.
            // Genesis species answer to the single dungeon address; every
            // community species has its own minter in the registry.
            let (tier, beast_type) = InternalTrait::assert_can_mint(@self, beast_id);

            // Prepare mint request
            let request = MintRequest { beast_id, prefix, suffix, level, health, shiny, animated };

            // Validate and prepare mint data
            let (token_id, insertion_rank) =
                match MintingCoordinatorTrait::prepare_mint_with_traits(request, tier, beast_type) {
                BeastResult::Ok(mint_data) => {
                    // Check for duplicates
                    assert(!self.minted.entry(mint_data.hash).read(), 'Beast already minted');

                    // Mark as minted
                    self.minted.entry(mint_data.hash).write(true);

                    // Calculate and store beast rank for tokenURI
                    let insertion_rank = BeastRankingManagerTrait::calculate_and_store_rank(
                        ref self, mint_data.beast, mint_data.token_id,
                    );

                    // Mint NFT
                    self.erc721.mint(to, mint_data.token_id);
                    self.supply_count.write(self.supply_count.read() + 1);
                    (mint_data.token_id, insertion_rank)
                },
                BeastResult::Err(e) => { core::panic_with_felt252(e); },
            };

            let bookmark_set = InternalTrait::generate_metadata_update_events(
                ref self, beast_id, insertion_rank,
            );

            (token_id, insertion_rank, bookmark_set)
        }

        fn refresh_metadata(ref self: ContractState, beast_id: u64) {
            let mut bookmark_number = self.beast_metadata_refresh_bookmark.entry(beast_id).read();

            assert(bookmark_number > 0, 'No stale beasts');

            let total_beasts = self.beast_counts.entry(beast_id).read();
            loop {
                if bookmark_number > total_beasts {
                    break;
                }

                let token_id = self
                    .beast_species_lists
                    .entry(beast_id)
                    .entry(bookmark_number)
                    .read();

                self.emit(MetadataUpdate { token_id });
                bookmark_number += 1;
            }

            self.beast_metadata_refresh_bookmark.entry(beast_id).write(0);
        }

        fn refresh_dungeon_stats(ref self: ContractState, token_id: u256) {
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            assert(
                death_mountain_dispatcher.contract_address != Zero::zero(),
                'Death mountain not set',
            );

            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);

            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );

            let num_deaths = death_mountain_dispatcher
                .get_collectable_count(death_mountain_dispatcher.contract_address, beast_hash);
            let collectable_entity_timestamp = death_mountain_dispatcher
                .get_collectable(
                    death_mountain_dispatcher.contract_address, beast_hash, num_deaths - 1,
                )
                .timestamp;

            let kill_count = death_mountain_dispatcher
                .get_entity_stats(death_mountain_dispatcher.contract_address, beast_hash)
                .adventurers_killed;
            let adventurer_killed_timestamp = if kill_count > 0 {
                death_mountain_dispatcher
                    .get_adventurer_killed(
                        death_mountain_dispatcher.contract_address, beast_hash, kill_count - 1,
                    )
                    .timestamp
            } else {
                0
            };

            let last_updated = self.last_manual_metadata_refresh.entry(token_id).read();
            assert(
                collectable_entity_timestamp > last_updated
                    || adventurer_killed_timestamp > last_updated,
                'Beast up to date',
            );
            self.emit(MetadataUpdate { token_id });
            self
                .last_manual_metadata_refresh
                .entry(token_id)
                .write(starknet::get_block_timestamp());
        }

        /// Pulls a community species token's live stats into the cache that
        /// `token_uri` reads. Permissionless — anyone may keep a token fresh
        /// — but it is the *only* place the artist-nominated stats source is
        /// called. If that source reverts, this transaction fails and
        /// rendering carries on with the last cached values.
        fn refresh_stats(ref self: ContractState, token_id: u256) {
            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);
            assert(beast.id > GENESIS_SPECIES_MAX, 'Genesis stats are live');

            let registry = self.registry.read();
            assert(registry.contract_address.is_non_zero(), 'Registry not set');
            let source = registry.get_stats_source(beast.id);
            assert(source.is_non_zero(), 'No stats source');

            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );
            let live = IBeastStatsDispatcher { contract_address: source }
                .get_beast_stats(beast_hash);
            let fresh = CachedStats {
                adventurers_killed: live.adventurers_killed,
                last_killed_by: live.last_killed_by,
                last_killed_timestamp: live.last_killed_timestamp,
            };

            // Only announce a change that actually happened; without this the
            // call is a free ERC-4906 spam faucet against every indexer.
            let cached = self.cached_stats.entry(token_id).read();
            assert(fresh != cached, 'Stats up to date');

            self.cached_stats.entry(token_id).write(fresh);
            self.emit(MetadataUpdate { token_id });
        }

        fn get_cached_stats(self: @ContractState, token_id: u256) -> BeastLiveStats {
            let cached = self.cached_stats.entry(token_id).read();
            BeastLiveStats {
                adventurers_killed: cached.adventurers_killed,
                last_killed_by: cached.last_killed_by,
                last_killed_timestamp: cached.last_killed_timestamp,
            }
        }

        fn get_beast(self: @ContractState, token_id: u256) -> PackableBeast {
            self.erc721._require_owned(token_id);
            decode_token_id(token_id)
        }

        fn is_minted(self: @ContractState, beast_id: u64, prefix: u8, suffix: u8) -> bool {
            let hash = BeastManagerTrait::get_beast_hash(beast_id, prefix, suffix);
            self.minted.entry(hash).read()
        }

        fn total_supply(self: @ContractState) -> u256 {
            self.supply_count.read()
        }

        fn get_beast_rank(self: @ContractState, token_id: u256) -> u16 {
            BeastRankingManagerTrait::get_beast_rank(self, token_id)
        }

        fn get_kill_count(self: @ContractState, token_id: u256) -> u64 {
            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);
            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            if death_mountain_dispatcher.contract_address != Zero::zero() {
                let entity_stats = death_mountain_dispatcher
                    .get_entity_stats(death_mountain_dispatcher.contract_address, beast_hash);
                entity_stats.adventurers_killed
            } else {
                0
            }
        }

        fn get_adventurer_killed(self: @ContractState, token_id: u256, index: u64) -> u64 {
            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);
            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            if death_mountain_dispatcher.contract_address != Zero::zero() {
                let adventurer_killed = death_mountain_dispatcher
                    .get_adventurer_killed(
                        death_mountain_dispatcher.contract_address, beast_hash, index,
                    );
                adventurer_killed.adventurer_id
            } else {
                0
            }
        }

        fn get_last_killed_timestamp(self: @ContractState, token_id: u256) -> u64 {
            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);
            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            if death_mountain_dispatcher.contract_address != Zero::zero() {
                let num_deaths = death_mountain_dispatcher
                    .get_collectable_count(death_mountain_dispatcher.contract_address, beast_hash);
                if num_deaths > 0 {
                    let collectable_entity = death_mountain_dispatcher
                        .get_collectable(
                            death_mountain_dispatcher.contract_address, beast_hash, num_deaths - 1,
                        );
                    return collectable_entity.timestamp;
                }
            }
            return 0;
        }

        fn get_last_killed_by(self: @ContractState, token_id: u256) -> u64 {
            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);
            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            if death_mountain_dispatcher.contract_address != Zero::zero() {
                let num_deaths = death_mountain_dispatcher
                    .get_collectable_count(death_mountain_dispatcher.contract_address, beast_hash);
                if num_deaths > 0 {
                    let collectable_entity = death_mountain_dispatcher
                        .get_collectable(
                            death_mountain_dispatcher.contract_address, beast_hash, num_deaths - 1,
                        );
                    return collectable_entity.killed_by;
                }
            }
            return 0;
        }

        fn get_adventurers_killed(self: @ContractState, token_id: u256) -> u64 {
            self.erc721._require_owned(token_id);
            let beast = decode_token_id(token_id);
            let beast_hash = BeastManagerTrait::get_beast_hash(
                beast.id, beast.prefix, beast.suffix,
            );
            let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
            if death_mountain_dispatcher.contract_address != Zero::zero() {
                death_mountain_dispatcher
                    .get_entity_stats(death_mountain_dispatcher.contract_address, beast_hash)
                    .adventurers_killed
            } else {
                0
            }
        }

        fn get_regular_png_provider(self: @ContractState) -> ContractAddress {
            self.regular_png_provider.read().contract_address
        }

        fn get_regular_gif_provider(self: @ContractState) -> ContractAddress {
            self.regular_gif_provider.read().contract_address
        }

        fn get_shiny_png_provider(self: @ContractState) -> ContractAddress {
            self.shiny_png_provider.read().contract_address
        }

        fn get_shiny_gif_provider(self: @ContractState) -> ContractAddress {
            self.shiny_gif_provider.read().contract_address
        }

        fn get_token_id_at_rank(self: @ContractState, beast_id: u64, rank: u16) -> u256 {
            self.beast_species_lists.entry(beast_id).entry(rank).read()
        }

        fn get_species_count(self: @ContractState, beast_id: u64) -> u16 {
            self.beast_counts.entry(beast_id).read()
        }

        fn get_beast_metadata_bookmark(self: @ContractState, beast_id: u64) -> u16 {
            self.beast_metadata_refresh_bookmark.entry(beast_id).read()
        }

        fn get_last_manual_metadata_refresh(self: @ContractState, token_id: u256) -> u64 {
            self.last_manual_metadata_refresh.entry(token_id).read()
        }
    }

    // Registry-only entrypoints. The registry is the permissionless surface;
    // these are the two things it needs the NFT to do on a registrant's
    // behalf.
    #[abi(embed_v0)]
    impl BeastsProvenanceImpl of IBeastsProvenance<ContractState> {
        /// Mints the species' Genesis Beast — the (id, 0, 0) affix slot,
        /// permanently reserved as the artist/creator token — as the final
        /// step of registration.
        ///
        /// Uses `erc721.mint`, not `safe_mint`: `safe_mint` calls back into
        /// the recipient, which would hand a contract artist a reentry point
        /// into the registry mid-registration, while its definition is
        /// written but before `next_id` has settled.
        fn mint_provenance(ref self: ContractState, artist: ContractAddress, beast_id: u64) {
            let registry = self.registry.read();
            assert(registry.contract_address.is_non_zero(), 'Registry not set');
            assert(starknet::get_caller_address() == registry.contract_address, 'Only registry');
            // Genesis species were minted in the constructor; the registry
            // must never be able to re-issue one.
            assert(beast_id > GENESIS_SPECIES_MAX, 'Not a community species');

            let (tier, beast_type) = registry.get_species_traits(beast_id);

            match MintingCoordinatorTrait::prepare_genesis_mint_with_traits(
                beast_id, tier, beast_type,
            ) {
                BeastResult::Ok(mint_data) => {
                    assert(!self.minted.entry(mint_data.hash).read(), 'Beast already minted');
                    self.minted.entry(mint_data.hash).write(true);

                    self.erc721.mint(artist, mint_data.token_id);
                    self.supply_count.write(self.supply_count.read() + 1);
                },
                BeastResult::Err(e) => { core::panic_with_felt252(e); },
            }
        }

        /// Fans out ERC-4906 events for a species after its art changed.
        fn emit_species_metadata_update(ref self: ContractState, beast_id: u64) {
            let registry = self.registry.read();
            assert(registry.contract_address.is_non_zero(), 'Registry not set');
            assert(starknet::get_caller_address() == registry.contract_address, 'Only registry');

            InternalTrait::emit_species_fan_out(ref self, beast_id);
        }
    }

    // Internal implementations
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Authorizes the caller to mint `beast_id` and returns the species'
        /// static (tier, type).
        ///
        /// Genesis species answer to the single owner-set dungeon address.
        /// Community species each name their own minter in the registry — a
        /// zero minter means the species is paused, and is rejected rather
        /// than matched against a zero caller.
        fn assert_can_mint(self: @ContractState, beast_id: u64) -> (u8, u8) {
            // Structural check first: zero is never a species, and without
            // this it would fall through to the registry branch and report a
            // misleading wiring error.
            match BeastManagerTrait::validate_beast_id(beast_id) {
                BeastResult::Ok(_) => {},
                BeastResult::Err(e) => { core::panic_with_felt252(e); },
            }

            let caller = starknet::get_caller_address();

            if BeastManagerTrait::is_genesis_species(beast_id) {
                assert(caller == self.dungeon_address.read(), 'Not authorized to mint');
                return BeastManagerTrait::resolve_species_traits(beast_id);
            }

            let registry = self.registry.read();
            assert(registry.contract_address.is_non_zero(), 'Registry not set');
            // Reverts for an unregistered species, so an unknown ID can never
            // be minted with attacker-chosen traits.
            let (tier, beast_type) = registry.get_species_traits(beast_id);

            let minter = registry.get_minter(beast_id);
            assert(minter.is_non_zero(), 'Species minting paused');
            assert(caller == minter, 'Not authorized to mint');

            (tier, beast_type)
        }

        /// Species display name: baked-in tables for genesis species, the
        /// registry for community species.
        fn resolve_species_name(self: @ContractState, beast_id: u64) -> felt252 {
            if BeastManagerTrait::is_genesis_species(beast_id) {
                return BeastManagerTrait::resolve_species_name(beast_id);
            }

            let registry = self.registry.read();
            assert(registry.contract_address.is_non_zero(), 'Registry not set');
            registry.get_species_name(beast_id)
        }

        /// Resolves a beast's image data URI.
        ///
        /// Genesis species read from the four art data contracts wired at
        /// construction. Community species call their registered
        /// `IBeastArtProvider` with the full decoded beast, so a provider can
        /// vary art by affix, tier, or level — and whatever it returns is
        /// validated before it reaches the SVG, because that provider is an
        /// arbitrary artist-controlled contract.
        fn resolve_art(self: @ContractState, beast: PackableBeast) -> ByteArray {
            if BeastManagerTrait::is_genesis_species(beast.id) {
                let provider = if beast.animated == 0 {
                    if beast.shiny == 1 {
                        self.shiny_png_provider.read()
                    } else {
                        self.regular_png_provider.read()
                    }
                } else {
                    if beast.shiny == 1 {
                        self.shiny_gif_provider.read()
                    } else {
                        self.regular_gif_provider.read()
                    }
                };
                let legacy_species: u8 = beast.id.try_into().expect('not a genesis species');
                return provider.get_data_uri(legacy_species);
            }

            let registry = self.registry.read();
            assert(registry.contract_address.is_non_zero(), 'Registry not set');
            let art_provider = registry.get_art_provider(beast.id);
            assert(art_provider.is_non_zero(), 'No art provider');

            let uri = IBeastArtProviderDispatcher { contract_address: art_provider }
                .get_data_uri(beast);
            assert_valid_render_uri(@uri);
            uri
        }

        /// Emits `MetadataUpdate` for every token of a species, bookmarking
        /// the overflow past `FAN_OUT_LIMIT` for `refresh_metadata` to drain.
        fn emit_species_fan_out(ref self: ContractState, beast_id: u64) {
            // The Genesis Beast holds rank 0 and is deliberately absent from
            // `beast_species_lists`, so a list walk alone would leave the
            // artist's own token stale after every art change.
            let genesis_hash = BeastManagerTrait::get_beast_hash(beast_id, 0, 0);
            if self.minted.entry(genesis_hash).read() {
                // Tier and type are part of the token ID, so they must be the
                // species' real ones — resolve rather than assume.
                let (tier, beast_type) = Self::resolve_traits_for_fan_out(@self, beast_id);
                match MintingCoordinatorTrait::prepare_genesis_mint_with_traits(
                    beast_id, tier, beast_type,
                ) {
                    BeastResult::Ok(mint_data) => {
                        self.emit(MetadataUpdate { token_id: mint_data.token_id });
                    },
                    BeastResult::Err(e) => { core::panic_with_felt252(e); },
                }
            }

            let total_beasts = self.beast_counts.entry(beast_id).read();
            let last = if total_beasts > FAN_OUT_LIMIT {
                self.beast_metadata_refresh_bookmark.entry(beast_id).write(FAN_OUT_LIMIT + 1);
                FAN_OUT_LIMIT
            } else {
                total_beasts
            };

            let mut rank: u16 = 1;
            while rank <= last {
                let token_id = self.beast_species_lists.entry(beast_id).entry(rank).read();
                self.emit(MetadataUpdate { token_id });
                rank += 1;
            }
        }

        fn resolve_traits_for_fan_out(self: @ContractState, beast_id: u64) -> (u8, u8) {
            if BeastManagerTrait::is_genesis_species(beast_id) {
                return BeastManagerTrait::resolve_species_traits(beast_id);
            }
            self.registry.read().get_species_traits(beast_id)
        }
        /// Internal function to mint genesis beasts during contract construction
        fn mint_genesis_beasts(ref self: ContractState, to: ContractAddress) {
            // Prepare genesis batch
            let batch = MintingCoordinatorTrait::prepare_genesis_batch();

            // Process each beast in the batch
            let mut i = 0;
            let batch_len = batch.len();
            loop {
                if i >= batch_len {
                    break;
                }

                match batch.at(i) {
                    BeastResult::Ok(mint_data) => {
                        // Reserve the (id, 0, 0) affix slot: every species has
                        // exactly one Genesis Beast in the uniqueness map.
                        self.minted.entry(*mint_data.hash).write(true);

                        // Mint NFT
                        self.erc721.mint(to, *mint_data.token_id);
                    },
                    BeastResult::Err(e) => { core::panic_with_felt252(*e); },
                }

                i += 1;
            }

            // Update supply count
            let new_supply = MintingCoordinatorTrait::calculate_new_supply(
                self.supply_count.read(), 75,
            );
            self.supply_count.write(new_supply);
        }

        /// Internal helper to build the onchain metadata URI for a token.
        /// Consolidates shared logic used by `token_uri` and `animation_url`.
        fn build_metadata_uri(self: @ContractState, token_id: u256) -> ByteArray {
            // Ensure token exists
            self.erc721._require_owned(token_id);

            // Get beast data
            let beast = decode_token_id(token_id);
            let rank = BeastRankingManagerTrait::get_beast_rank(self, token_id);

            // Combat stats. Genesis species read Death Mountain live — that
            // dispatcher is owner-set and trusted. Community species read the
            // cache instead: their stats source is artist-nominated, and a
            // failed external call cannot be caught on Starknet, so a live
            // read here would let any artist permanently brick rendering for
            // their whole species.
            let mut last_killed_timestamp = 0;
            let mut last_killed_by_adventurer = 0;
            let mut adventurers_killed = 0;
            if BeastManagerTrait::is_genesis_species(beast.id) {
                let death_mountain_dispatcher = self.death_mountain_dispatcher.read();
                if death_mountain_dispatcher.contract_address != Zero::zero() {
                    let death_mountain_address = self.dungeon_address.read();
                    if death_mountain_address != Zero::zero() {
                        let beast_hash = BeastManagerTrait::get_beast_hash(
                            beast.id, beast.prefix, beast.suffix,
                        );
                        let num_deaths = death_mountain_dispatcher
                            .get_collectable_count(
                                death_mountain_dispatcher.contract_address, beast_hash,
                            );
                        if num_deaths > 0 {
                            let collectable_entity = death_mountain_dispatcher
                                .get_collectable(
                                    death_mountain_address, beast_hash, num_deaths - 1,
                                );
                            last_killed_timestamp = collectable_entity.timestamp;
                            last_killed_by_adventurer = collectable_entity.killed_by;
                        }

                        let entity_stats = death_mountain_dispatcher
                            .get_entity_stats(death_mountain_address, beast_hash);

                        adventurers_killed = entity_stats.adventurers_killed;
                    }
                }
            } else {
                let cached = self.cached_stats.entry(token_id).read();
                adventurers_killed = cached.adventurers_killed;
                last_killed_by_adventurer = cached.last_killed_by;
                last_killed_timestamp = cached.last_killed_timestamp;
            }

            let beast_name = Self::resolve_species_name(self, beast.id);
            let beast_image = Self::resolve_art(self, beast);

            // Generate metadata
            MetadataGeneratorTrait::generate_metadata(
                token_id,
                beast,
                rank,
                beast_name,
                beast_image,
                adventurers_killed,
                last_killed_by_adventurer,
                last_killed_timestamp,
            )
        }

        fn generate_metadata_update_events(
            ref self: ContractState, beast_id: u64, insertion_rank: u16,
        ) -> bool {
            let total_beasts = self.beast_counts.entry(beast_id).read();
            let mut bookmark_set = false;
            if total_beasts > FAN_OUT_LIMIT {
                let distance_to_last = total_beasts - insertion_rank;
                if distance_to_last >= FAN_OUT_LIMIT {
                    self
                        .beast_metadata_refresh_bookmark
                        .entry(beast_id)
                        .write(insertion_rank + FAN_OUT_LIMIT);
                    bookmark_set = true;
                }
            }

            // emit metadata update calls from insertion rank till total beasts or insertion rank +
            // 650
            let mut count = insertion_rank + 1;
            while count < total_beasts {
                if count >= insertion_rank + FAN_OUT_LIMIT {
                    break;
                }
                let token_id = self.beast_species_lists.entry(beast_id).entry(count).read();
                self.emit(MetadataUpdate { token_id });
                count += 1;
            }

            bookmark_set
        }
    }

    // Custom ERC721Metadata Implementation
    #[abi(embed_v0)]
    impl ERC721Metadata of IERC721Metadata<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            self.erc721.name()
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc721.symbol()
        }

        fn token_uri(self: @ContractState, token_id: u256) -> ByteArray {
            InternalTrait::build_metadata_uri(self, token_id)
        }
    }

    // Expose `animation_url` that mirrors `token_uri` for better viewer compatibility
    #[abi(embed_v0)]
    impl BeastsAnimation of IBeastsAnimation<ContractState> {
        fn animation_url(self: @ContractState, token_id: u256) -> ByteArray {
            InternalTrait::build_metadata_uri(self, token_id)
        }
    }
}
