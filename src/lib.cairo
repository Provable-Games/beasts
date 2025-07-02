pub mod beast_svg;
pub mod beast_definitions;
pub mod pack;
pub mod utils;
pub mod interfaces;

#[cfg(test)]
mod tests;

#[cfg(test)]
mod test_felt252_conversion;

#[cfg(test)]
mod mint_tests;

#[cfg(test)]
mod integration_test;

#[starknet::contract]
pub mod beasts_nft {
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use openzeppelin_token::erc721::interface::{IERC721Metadata};
    use starknet::{ContractAddress, storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess}};
    use super::beast_svg::BeastSvgTrait;
    use super::pack::{PackableBeast, get_hash};
    use super::beast_definitions;
    use super::utils::felt252_to_byte_array;
    use super::interfaces::IBeasts;

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
    /// Mints the `token_ids` tokens to `recipient` and sets
    /// the base URI.
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_ids: Span<u256>,
        owner: ContractAddress,
    ) {
        self.ownable.initializer(owner);
        self.erc721.initializer(name, symbol, base_uri);
        self.mint_assets(recipient, token_ids);
    }

    #[generate_trait]
    pub(crate) impl InternalImpl of InternalTrait {
        /// Mints `token_ids` to `recipient`.
        fn mint_assets(
            ref self: ContractState, recipient: ContractAddress, mut token_ids: Span<u256>,
        ) {
            loop {
                if token_ids.len() == 0 {
                    break;
                }
                let id = *token_ids.pop_front().unwrap();
                // Initialize beast with default attributes
                let beast = PackableBeast { 
                    id: id.try_into().unwrap(), 
                    prefix: 0, 
                    suffix: 0, 
                    level: 1, 
                    health: 100 
                };
                self.beasts.entry(id).write(beast);
                self.erc721.mint(recipient, id);
            }
        }
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
            health: u16
        ) {
            // Check minter authorization
            let caller = starknet::get_caller_address();
            assert(caller == self.minter.read(), 'Not authorized to mint');
            
            // Check beast validity
            assert(beast_id >= 1 && beast_id <= 75, 'Invalid beast ID');
            
            // Check for duplicates
            let hash = get_hash(beast_id, prefix, suffix);
            assert(!self.minted.entry(hash).read(), 'Beast already minted');
            
            // Mark as minted
            self.minted.entry(hash).write(true);
            
            // Get next token ID
            let token_id = self.token_counter.read() + 1;
            self.token_counter.write(token_id);
            
            // Create beast
            let beast = PackableBeast { id: beast_id, prefix, suffix, level, health };
            self.beasts.entry(token_id).write(beast);
            
            // Mint NFT
            self.erc721.mint(to, token_id);
        }

        fn mint_genesis_beasts(ref self: ContractState, to: ContractAddress) {
            self.ownable.assert_only_owner();
            
            // Mint all 75 genesis beasts
            let mut beast_id: u8 = 1;
            loop {
                if beast_id > 75 {
                    break;
                }
                
                // Get next token ID
                let token_id = self.token_counter.read() + 1;
                self.token_counter.write(token_id);
                
                // Create genesis beast with no prefix/suffix
                let beast = PackableBeast { 
                    id: beast_id, 
                    prefix: 0, 
                    suffix: 0, 
                    level: 1, 
                    health: 100 
                };
                self.beasts.entry(token_id).write(beast);
                
                // Mint NFT
                self.erc721.mint(to, token_id);
                
                beast_id += 1;
            };
        }

        fn get_beast(self: @ContractState, token_id: u256) -> PackableBeast {
            self.erc721._require_owned(token_id);
            self.beasts.entry(token_id).read()
        }

        fn is_minted(self: @ContractState, beast_id: u8, prefix: u8, suffix: u8) -> bool {
            let hash = get_hash(beast_id, prefix, suffix);
            self.minted.entry(hash).read()
        }

        fn total_supply(self: @ContractState) -> u256 {
            self.token_counter.read()
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
            
            // Generate metadata with SVG image
            self.create_metadata(token_id, beast)
        }
    }

    #[generate_trait]
    impl MetadataImpl of MetadataTrait {
        /// Creates metadata JSON string for a beast
        fn create_metadata(
            self: @ContractState,
            token_id: u256,
            beast: PackableBeast
        ) -> ByteArray {
            let mut metadata: ByteArray = "{\"name\":\"Beast #";
            metadata.append(@format!("{}", token_id));
            metadata.append(@"\",\"description\":\"A fearsome beast from the Loot Survivor universe\",");
            
            // Add SVG image as data URI
            metadata.append(@"\"image\":\"");
            let svg_data_uri = BeastSvgTrait::generate_svg_data_uri(beast);
            metadata.append(@svg_data_uri);
            metadata.append(@"\",");
            
            metadata.append(@"\"attributes\":[");
            
            // Beast ID attribute
            metadata.append(@"{\"trait_type\":\"Beast\",\"value\":\"");
            let beast_name = beast_definitions::get_beast_name(beast.id);
            let beast_name_str = felt252_to_byte_array(beast_name);
            metadata.append(@beast_name_str);
            metadata.append(@"\"},");
            
            // Type attribute
            metadata.append(@"{\"trait_type\":\"Type\",\"value\":\"");
            let beast_type = beast_definitions::get_type(beast.id);
            let beast_type_str = felt252_to_byte_array(beast_type);
            metadata.append(@beast_type_str);
            metadata.append(@"\"},");
            
            // Tier attribute
            metadata.append(@"{\"trait_type\":\"Tier\",\"value\":\"");
            let tier = beast_definitions::get_tier(beast.id);
            let tier_str = felt252_to_byte_array(tier);
            metadata.append(@tier_str);
            metadata.append(@"\"},");
            
            // Prefix attribute
            if beast.prefix > 0 {
                metadata.append(@"{\"trait_type\":\"Prefix\",\"value\":\"");
                let prefix = beast_definitions::get_prefix(beast.prefix);
                let prefix_str = felt252_to_byte_array(prefix);
                metadata.append(@prefix_str);
                metadata.append(@"\"},");
            }
            
            // Suffix attribute
            if beast.suffix > 0 {
                metadata.append(@"{\"trait_type\":\"Suffix\",\"value\":\"");
                let suffix = beast_definitions::get_suffix(beast.suffix);
                let suffix_str = felt252_to_byte_array(suffix);
                metadata.append(@suffix_str);
                metadata.append(@"\"},");
            }
            
            // Level attribute
            metadata.append(@"{\"trait_type\":\"Level\",\"value\":");
            metadata.append(@format!("{}", beast.level));
            metadata.append(@"},");
            
            // Health attribute
            metadata.append(@"{\"trait_type\":\"Health\",\"value\":");
            metadata.append(@format!("{}", beast.health));
            metadata.append(@"}");
            
            metadata.append(@"]}");
            
            metadata
        }
    }
}