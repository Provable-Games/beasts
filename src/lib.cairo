pub mod beast_definitions;
pub mod beast_manager;
pub mod beast_ranking;
pub mod beast_svg;
pub mod interfaces;
pub mod metadata_generator;
pub mod minting_coordinator;
pub mod pack;
pub mod utils;


#[starknet::contract]
pub mod beasts_nft {
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::interface::IERC721Metadata;
    use openzeppelin_token::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use super::beast_manager::{BeastManagerTrait, BeastResult};
    use super::beast_ranking::BeastRankingManagerTrait;
    use super::interfaces::IBeasts;
    use super::metadata_generator::MetadataGeneratorTrait;
    use super::minting_coordinator::{MintRequest, MintingCoordinatorTrait};
    use super::pack::PackableBeast;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

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

    // SRC5 Implementation
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        pub erc721: ERC721Component::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage,
        // Beast-specific storage
        pub beasts: Map<u256, PackableBeast>,
        pub beast_token_ranks: Map<u256, u16>, // token_id -> current rank (for tokenURI)
        pub beast_species_lists: Map<
            u8, Map<u16, u256>,
        >, // beast_id -> rank -> token_id (nested map)
        pub beast_counts: Map<u8, u16>, // beast_id -> count of beasts
        pub minted: Map<felt252, bool>,
        pub minter: ContractAddress,
        pub token_counter: u256,
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
    }

    /// Assigns `owner` as the contract owner.
    /// Sets the token `name` and `symbol`.
    /// Sets the base URI.
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        owner: ContractAddress,
    ) {
        self.ownable.initializer(owner);
        self.erc721.initializer(name, symbol, base_uri);
    }

    // IBeasts Implementation
    #[abi(embed_v0)]
    impl BeastsImpl of IBeasts<ContractState> {
        fn set_minter(ref self: ContractState, minter: ContractAddress) {
            self.ownable.assert_only_owner();
            self.minter.write(minter);
        }

        fn get_minter(self: @ContractState) -> ContractAddress {
            self.minter.read()
        }

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast_id: u8,
            prefix: u8,
            suffix: u8,
            level: u16,
            health: u16,
            shiny: bool,
        ) {
            // Check minter authorization
            let caller = starknet::get_caller_address();
            assert(caller == self.minter.read(), 'Not authorized to mint');

            // Prepare mint request
            let request = MintRequest { beast_id, prefix, suffix, level, health, shiny };
            let next_token_id = self.token_counter.read() + 1;

            // Validate and prepare mint data
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
                    BeastRankingManagerTrait::calculate_and_store_rank(
                        ref self, mint_data.beast, mint_data.token_id,
                    );

                    // Mint NFT
                    self.erc721.mint(to, mint_data.token_id);
                },
                BeastResult::Err(e) => { core::panic_with_felt252(e); },
            }
        }

        fn mint_genesis_beasts(ref self: ContractState, to: ContractAddress) {
            self.ownable.assert_only_owner();

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
            self.erc721._require_owned(token_id);

            // Get beast data
            let beast = self.beasts.entry(token_id).read();
            let rank = self.beast_token_ranks.entry(token_id).read();

            // Generate metadata using pure Cairo library
            MetadataGeneratorTrait::generate_metadata(token_id, beast, rank)
        }
    }
}
