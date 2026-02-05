pub mod beast_definitions;
pub mod beast_gif_regular_data;
pub mod beast_gif_shiny_data;
pub mod beast_images;
pub mod beast_manager;
pub mod beast_png_regular_data;
pub mod beast_png_shiny_data;
pub mod beast_ranking;
pub mod beast_svg;
pub mod encoding;
pub mod interfaces;
pub mod metadata_generator;
pub mod minting_coordinator;
pub mod pack;
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
    use openzeppelin_governance::votes::VotesComponent;
    use openzeppelin_interfaces::erc721::IERC721Metadata;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::common::erc2981::ERC2981Component;
    use openzeppelin_token::erc721::ERC721Component;
    use openzeppelin_utils::contract_clock::ERC6372TimestampClock;
    use openzeppelin_utils::cryptography::nonces::NoncesComponent;
    use openzeppelin_utils::cryptography::snip12::SNIP12Metadata;
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use super::beast_manager::{BeastManagerTrait, BeastResult};
    use super::beast_ranking::BeastRankingManagerTrait;
    use super::interfaces::{
        IBeastImageDataProviderDispatcher, IBeastSystemsDispatcher, IBeastSystemsDispatcherTrait,
        IBeasts, IBeastsAnimation,
    };
    use super::metadata_generator::MetadataGeneratorTrait;
    use super::minting_coordinator::{MintRequest, MintingCoordinatorTrait};
    use super::pack::PackableBeast;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: ERC2981Component, storage: erc2981, event: ERC2981Event);
    component!(path: VotesComponent, storage: erc721_votes, event: ERC721VotesEvent);
    component!(path: NoncesComponent, storage: nonces, event: NoncesEvent);

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

    // ERC6372 Clock implementation (required for VotesComponent)
    impl Clock = ERC6372TimestampClock;

    // Votes Implementation
    #[abi(embed_v0)]
    impl VotesImpl = VotesComponent::VotesImpl<ContractState>;
    impl VotesInternalImpl = VotesComponent::InternalImpl<ContractState>;

    // Nonces
    #[abi(embed_v0)]
    impl NoncesImpl = NoncesComponent::NoncesImpl<ContractState>;
    impl NoncesInternalImpl = NoncesComponent::InternalImpl<ContractState>;

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
        pub erc721_votes: VotesComponent::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage,
        #[substorage(v0)]
        pub erc2981: ERC2981Component::Storage,
        #[substorage(v0)]
        pub nonces: NoncesComponent::Storage,
        // Beast-specific storage
        pub beasts: Map<u256, PackableBeast>,
        pub beast_token_ranks: Map<u256, u16>, // token_id -> current rank (for tokenURI)
        pub beast_species_lists: Map<
            u8, Map<u16, u256>,
        >, // beast_id -> rank -> token_id (nested map)
        pub beast_counts: Map<u8, u16>, // beast_id -> count of beasts
        pub beast_metadata_refresh_bookmark: Map<u8, u16>, // beast_id -> count of updates
        pub last_manual_metadata_refresh: Map<u256, u64>, // token_id -> timestamp of last update
        pub minted: Map<felt252, bool>,
        pub dungeon_address: ContractAddress,
        pub token_counter: u256,
        // External data providers
        pub regular_png_provider: IBeastImageDataProviderDispatcher,
        pub shiny_png_provider: IBeastImageDataProviderDispatcher,
        pub regular_gif_provider: IBeastImageDataProviderDispatcher,
        pub shiny_gif_provider: IBeastImageDataProviderDispatcher,
        pub death_mountain_dispatcher: IBeastSystemsDispatcher,
        // If non-zero, contract becomes terminal after this timestamp
        pub terminal_timestamp: u64,
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
        ERC721VotesEvent: VotesComponent::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        ERC2981Event: ERC2981Component::Event,
        #[flat]
        NoncesEvent: NoncesComponent::Event,
        MetadataUpdate: MetadataUpdate,
    }

    /// Required for hash computation.
    pub impl SNIP12MetadataImpl of SNIP12Metadata {
        fn name() -> felt252 {
            'Beasts'
        }
        fn version() -> felt252 {
            '1.0.0'
        }
    }

    // We need to call the `transfer_voting_units` function after
    // every mint, burn and transfer.
    // For this, we use the `before_update` hook of the
    //`ERC721Component::ERC721HooksTrait`.
    // This hook is called before the transfer is executed.
    // This gives us access to the previous owner.
    impl ERC721VotesHooksImpl of ERC721Component::ERC721HooksTrait<ContractState> {
        fn before_update(
            ref self: ERC721Component::ComponentState<ContractState>,
            to: ContractAddress,
            token_id: u256,
            auth: ContractAddress,
        ) {
            let mut contract_state = self.get_contract_mut();

            // We use the internal function here since it does not check if the token
            // id exists which is necessary for mints
            let previous_owner = self._owner_of(token_id);
            contract_state.erc721_votes.transfer_voting_units(previous_owner, to, 1);
        }
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
        terminal_timestamp: u64,
    ) {
        self.ownable.initializer(owner);
        self.erc721.initializer(name, symbol, "");
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

        // Configure terminal timestamp (0 means disabled)
        self.terminal_timestamp.write(terminal_timestamp);

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

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast_id: u8,
            prefix: u8,
            suffix: u8,
            level: u16,
            health: u16,
            shiny: u8,
            animated: u8,
        ) -> (u256, u16, bool) {
            // Ensure caller is Dungeon
            let caller = starknet::get_caller_address();
            assert(caller == self.dungeon_address.read(), 'Not authorized to mint');

            // Prepare mint request
            let request = MintRequest { beast_id, prefix, suffix, level, health, shiny, animated };
            let next_token_id = self.token_counter.read() + 1;

            // Validate and prepare mint data
            let (token_id, insertion_rank) =
                match MintingCoordinatorTrait::prepare_mint(request, next_token_id) {
                BeastResult::Ok(mint_data) => {
                    // Check for duplicates
                    assert(!self.minted.entry(mint_data.hash).read(), 'Beast already minted');

                    // Mark as minted
                    self.minted.entry(mint_data.hash).write(true);

                    // Update token counter
                    self.token_counter.write(mint_data.token_id);

                    // Store beast
                    self.beasts.entry(mint_data.token_id).write(mint_data.beast);

                    // Calculate and store beast rank for tokenURI
                    let insertion_rank = BeastRankingManagerTrait::calculate_and_store_rank(
                        ref self, mint_data.beast, mint_data.token_id,
                    );

                    // Mint NFT
                    self.erc721.mint(to, mint_data.token_id);
                    (mint_data.token_id, insertion_rank)
                },
                BeastResult::Err(e) => { core::panic_with_felt252(e); },
            };

            let bookmark_set = InternalTrait::generate_metadata_update_events(
                ref self, beast_id, insertion_rank,
            );

            (token_id, insertion_rank, bookmark_set)
        }

        fn refresh_metadata(ref self: ContractState, beast_id: u8) {
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

            let beast = self.beasts.entry(token_id).read();
            assert(beast.id != 0, 'Beast does not exist');

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

        fn get_beast(self: @ContractState, token_id: u256) -> PackableBeast {
            self.erc721._require_owned(token_id);
            self.beasts.entry(token_id).read()
        }

        fn is_minted(self: @ContractState, beast_id: u8, prefix: u8, suffix: u8) -> bool {
            let hash = BeastManagerTrait::get_beast_hash(beast_id, prefix, suffix);
            self.minted.entry(hash).read()
        }

        fn total_supply(self: @ContractState) -> u256 {
            self.token_counter.read()
        }

        fn get_beast_rank(self: @ContractState, token_id: u256) -> u16 {
            BeastRankingManagerTrait::get_beast_rank(self, token_id)
        }

        fn get_kill_count(self: @ContractState, token_id: u256) -> u64 {
            let beast = self.beasts.entry(token_id).read();
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
            let beast = self.beasts.entry(token_id).read();
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
            let beast = self.beasts.entry(token_id).read();
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
            let beast = self.beasts.entry(token_id).read();
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
            let beast = self.beasts.entry(token_id).read();
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

        fn get_terminal_time(self: @ContractState) -> u64 {
            self.terminal_timestamp.read()
        }

        fn get_token_id_at_rank(self: @ContractState, beast_id: u8, rank: u16) -> u256 {
            self.beast_species_lists.entry(beast_id).entry(rank).read()
        }

        fn get_species_count(self: @ContractState, beast_id: u8) -> u16 {
            self.beast_counts.entry(beast_id).read()
        }

        fn get_beast_metadata_bookmark(self: @ContractState, beast_id: u8) -> u16 {
            self.beast_metadata_refresh_bookmark.entry(beast_id).read()
        }

        fn get_last_manual_metadata_refresh(self: @ContractState, token_id: u256) -> u64 {
            self.last_manual_metadata_refresh.entry(token_id).read()
        }
    }

    // Internal implementations
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Internal function to mint genesis beasts during contract construction
        fn mint_genesis_beasts(ref self: ContractState, to: ContractAddress) {
            // Prepare genesis batch
            let starting_token_id = self.token_counter.read() + 1;
            let batch = MintingCoordinatorTrait::prepare_genesis_batch(starting_token_id);

            // Process each beast in the batch
            let mut i = 0;
            let batch_len = batch.len();
            loop {
                if i >= batch_len {
                    break;
                }

                match batch.at(i) {
                    BeastResult::Ok(mint_data) => {
                        // Store beast
                        self.beasts.entry(*mint_data.token_id).write(*mint_data.beast);

                        // Mint NFT
                        self.erc721.mint(to, *mint_data.token_id);
                    },
                    BeastResult::Err(e) => { core::panic_with_felt252(*e); },
                }

                i += 1;
            }

            // Update token counter
            let new_supply = MintingCoordinatorTrait::calculate_new_supply(
                self.token_counter.read(), 75,
            );
            self.token_counter.write(new_supply);
        }

        /// Internal helper to build the onchain metadata URI for a token.
        /// Consolidates shared logic used by `token_uri` and `animation_url`.
        fn build_metadata_uri(self: @ContractState, token_id: u256) -> ByteArray {
            // Ensure token exists
            self.erc721._require_owned(token_id);

            // If terminal timestamp is set and passed, disallow metadata
            let terminal_ts = self.terminal_timestamp.read();
            if terminal_ts != 0_u64 {
                let now = starknet::get_block_timestamp();
                assert(now <= terminal_ts, 'Terminal: token_uri disabled');
            }

            // Get beast data
            let beast = self.beasts.entry(token_id).read();
            let rank = self.beast_token_ranks.entry(token_id).read();

            // Get additional data from death mountain
            let mut last_killed_timestamp = 0;
            let mut last_killed_by_adventurer = 0;
            let mut adventurers_killed = 0;
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
                            .get_collectable(death_mountain_address, beast_hash, num_deaths - 1);
                        last_killed_timestamp = collectable_entity.timestamp;
                        last_killed_by_adventurer = collectable_entity.killed_by;
                    }

                    let entity_stats = death_mountain_dispatcher
                        .get_entity_stats(death_mountain_address, beast_hash);

                    adventurers_killed = entity_stats.adventurers_killed;
                }
            }

            // Choose image provider based on beast flags
            let mut image_data_provider = self.regular_gif_provider.read();
            if beast.animated == 0 {
                if beast.shiny == 1 {
                    image_data_provider = self.shiny_png_provider.read();
                } else {
                    image_data_provider = self.regular_png_provider.read();
                }
            } else {
                if beast.shiny == 1 {
                    image_data_provider = self.shiny_gif_provider.read();
                }
            }

            // Generate metadata
            MetadataGeneratorTrait::generate_metadata(
                token_id,
                beast,
                rank,
                image_data_provider,
                adventurers_killed,
                last_killed_by_adventurer,
                last_killed_timestamp,
            )
        }

        fn generate_metadata_update_events(
            ref self: ContractState, beast_id: u8, insertion_rank: u16,
        ) -> bool {
            let total_beasts = self.beast_counts.entry(beast_id).read();
            let mut bookmark_set = false;
            if total_beasts > 650 {
                let distance_to_last = total_beasts - insertion_rank;
                if distance_to_last >= 650 {
                    self
                        .beast_metadata_refresh_bookmark
                        .entry(beast_id)
                        .write(insertion_rank + 650);
                    bookmark_set = true;
                }
            }

            // emit metadata update calls from insertion rank till total beasts or insertion rank +
            // 650
            let mut count = insertion_rank + 1;
            while count < total_beasts {
                if count >= insertion_rank + 650 {
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
