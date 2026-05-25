use starknet::ContractAddress;

#[derive(Drop, Copy, Serde, PartialEq)]
pub struct TiddyMun {
    pub id: u8,
    pub prefix: u8,
    pub suffix: u8,
    pub health: u16,
    pub level: u16,
    pub animated: bool,
    pub shiny: bool,
}

pub impl TiddyMunStorePacking of starknet::storage_access::StorePacking<TiddyMun, felt252> {
    fn pack(value: TiddyMun) -> felt252 {
        let animated: u128 = if value.animated {
            1
        } else {
            0
        };
        let shiny: u128 = if value.shiny {
            1
        } else {
            0
        };

        let packed: u128 = value.id.into()
            + value.prefix.into() * 0x80
            + value.suffix.into() * 0x4000
            + value.health.into() * 0x80000
            + value.level.into() * 0x800000000
            + animated * 0x8000000000000
            + shiny * 0x10000000000000;
        packed.into()
    }

    fn unpack(value: felt252) -> TiddyMun {
        let mut packed: u128 = value.try_into().expect('unpack tiddy');

        let id = (packed % 0x80).try_into().expect('unpack id');
        packed = packed / 0x80;
        let prefix = (packed % 0x80).try_into().expect('unpack prefix');
        packed = packed / 0x80;
        let suffix = (packed % 0x20).try_into().expect('unpack suffix');
        packed = packed / 0x20;
        let health = (packed % 0x10000).try_into().expect('unpack health');
        packed = packed / 0x10000;
        let level = (packed % 0x10000).try_into().expect('unpack level');
        packed = packed / 0x10000;
        let animated = (packed % 2) == 1;
        packed = packed / 2;
        let shiny = (packed % 2) == 1;
        packed = packed / 2;

        assert(packed == 0, 'invalid tiddy data');

        TiddyMun { id, prefix, suffix, health, level, animated, shiny }
    }
}

#[starknet::interface]
pub trait ITiddyMunNft<TContractState> {
    fn set_minter_address(ref self: TContractState, address: ContractAddress);
    fn get_minter_address(self: @TContractState) -> ContractAddress;
    fn mint(
        ref self: TContractState,
        to: ContractAddress,
        beast_id: u8,
        prefix: u8,
        suffix: u8,
        health: u16,
        level: u16,
        animated: bool,
        shiny: bool,
    ) -> u256;
    fn get_tiddy_mun(self: @TContractState, token_id: u256) -> TiddyMun;
    fn is_minted(self: @TContractState, prefix: u8, suffix: u8) -> bool;
    fn total_supply(self: @TContractState) -> u256;
}

#[starknet::interface]
pub trait ITiddyMunAnimation<TContractState> {
    fn animation_url(self: @TContractState, token_id: u256) -> ByteArray;
}

#[starknet::contract]
pub mod tiddy_mun_nft {
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_interfaces::erc721::IERC721Metadata;
    use openzeppelin_interfaces::upgrades::IUpgradeable;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc721::ERC721Component;
    use openzeppelin_upgrades::UpgradeableComponent;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use starknet::{ClassHash, ContractAddress};
    use super::super::encoding::bytes_base64_encode;
    use super::super::tiddy_mun_card::{TiddyMunCardAttributes, TiddyMunCardTrait};
    use super::super::utils::felt252_to_byte_array;
    use super::super::{beast_definitions, tiddy_mun_assets};
    use super::{ITiddyMunAnimation, ITiddyMunNft, TiddyMun};

    const TIDDY_MUN_BEAST_ID: u8 = 76;
    const TIDDY_MUN_TIER: u8 = 1;
    const TIDDY_MUN_TYPE: felt252 = 'Magic';
    const GENESIS_TOKEN_ID: u256 = 1;
    const FIRST_LIVE_TOKEN_ID: u256 = 2;
    const MAX_PREFIX: u8 = 69;
    const MAX_SUFFIX: u8 = 18;
    const TOTAL_CAPACITY: u256 = 1243;
    const GENESIS_HEALTH: u16 = 100;
    const GENESIS_LEVEL: u16 = 1;
    const GENESIS_ANIMATED: bool = false;
    const GENESIS_SHINY: bool = false;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnlyImpl = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl SRC5InternalImpl = SRC5Component::InternalImpl<ContractState>;

    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    impl ERC721HooksImpl of ERC721Component::ERC721HooksTrait<ContractState> {
        fn before_update(
            ref self: ERC721Component::ComponentState<ContractState>,
            to: ContractAddress,
            token_id: u256,
            auth: ContractAddress,
        ) {}
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
        pub upgradeable: UpgradeableComponent::Storage,
        pub minter_address: ContractAddress,
        pub next_token_id: u256,
        pub supply_count: u256,
        pub minted: Map<felt252, bool>,
        pub tiddy_muns: Map<u256, TiddyMun>,
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
        UpgradeableEvent: UpgradeableComponent::Event,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        owner: ContractAddress,
        minter_address: ContractAddress,
    ) {
        self.ownable.initializer(owner);
        self.erc721.initializer(name, symbol, "");
        self.minter_address.write(minter_address);

        let genesis = TiddyMun {
            id: TIDDY_MUN_BEAST_ID,
            prefix: 0,
            suffix: 0,
            health: GENESIS_HEALTH,
            level: GENESIS_LEVEL,
            animated: GENESIS_ANIMATED,
            shiny: GENESIS_SHINY,
        };
        self.tiddy_muns.entry(GENESIS_TOKEN_ID).write(genesis);
        self.minted.entry(InternalTrait::minted_key(0, 0)).write(true);
        self.erc721.mint(owner, GENESIS_TOKEN_ID);
        self.next_token_id.write(FIRST_LIVE_TOKEN_ID);
        self.supply_count.write(1);
    }

    #[abi(embed_v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.upgradeable.upgrade(new_class_hash);
        }
    }

    #[abi(embed_v0)]
    impl TiddyMunImpl of ITiddyMunNft<ContractState> {
        fn set_minter_address(ref self: ContractState, address: ContractAddress) {
            self.ownable.assert_only_owner();
            self.minter_address.write(address);
        }

        fn get_minter_address(self: @ContractState) -> ContractAddress {
            self.minter_address.read()
        }

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast_id: u8,
            prefix: u8,
            suffix: u8,
            health: u16,
            level: u16,
            animated: bool,
            shiny: bool,
        ) -> u256 {
            assert(
                starknet::get_caller_address() == self.minter_address.read(),
                'Not authorized to mint',
            );
            assert(beast_id == TIDDY_MUN_BEAST_ID, 'Invalid beast ID');
            InternalTrait::assert_live_prefix_suffix(prefix, suffix);
            assert(self.supply_count.read() < TOTAL_CAPACITY, 'Collection full');

            let key = InternalTrait::minted_key(prefix, suffix);
            assert(!self.minted.entry(key).read(), 'Tiddy Mun already minted');
            self.minted.entry(key).write(true);

            let token_id = self.next_token_id.read();
            let tiddy_mun = TiddyMun {
                id: beast_id, prefix, suffix, health, level, animated, shiny,
            };
            self.tiddy_muns.entry(token_id).write(tiddy_mun);
            self.erc721.mint(to, token_id);
            self.next_token_id.write(token_id + 1);
            self.supply_count.write(self.supply_count.read() + 1);

            token_id
        }

        fn get_tiddy_mun(self: @ContractState, token_id: u256) -> TiddyMun {
            self.erc721._require_owned(token_id);
            self.tiddy_muns.entry(token_id).read()
        }

        fn is_minted(self: @ContractState, prefix: u8, suffix: u8) -> bool {
            self.minted.entry(InternalTrait::minted_key(prefix, suffix)).read()
        }

        fn total_supply(self: @ContractState) -> u256 {
            self.supply_count.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn minted_key(prefix: u8, suffix: u8) -> felt252 {
            prefix.into() * 100 + suffix.into()
        }

        fn assert_live_prefix_suffix(prefix: u8, suffix: u8) {
            assert(prefix != 0, 'Invalid prefix');
            assert(suffix != 0, 'Invalid suffix');
            assert(prefix <= MAX_PREFIX, 'Invalid prefix');
            assert(suffix <= MAX_SUFFIX, 'Invalid suffix');
        }

        fn selected_asset_uri(tiddy_mun: TiddyMun) -> ByteArray {
            if tiddy_mun.animated {
                if tiddy_mun.shiny {
                    tiddy_mun_assets::shiny_animated_uri()
                } else {
                    tiddy_mun_assets::regular_animated_uri()
                }
            } else {
                if tiddy_mun.shiny {
                    tiddy_mun_assets::shiny_static_uri()
                } else {
                    tiddy_mun_assets::regular_static_uri()
                }
            }
        }

        fn bool_value(value: bool) -> ByteArray {
            if value {
                "true"
            } else {
                "false"
            }
        }

        fn append_attribute(
            ref json: ByteArray, trait_type: ByteArray, value: ByteArray, has_next: bool,
        ) {
            json.append(@"{\"trait_type\":\"");
            json.append(@trait_type);
            json.append(@"\",\"value\":\"");
            json.append(@value);
            json.append(@"\"}");
            if has_next {
                json.append(@",");
            }
        }

        fn build_metadata_uri(self: @ContractState, token_id: u256) -> ByteArray {
            self.erc721._require_owned(token_id);
            let tiddy_mun = self.tiddy_muns.entry(token_id).read();
            let is_genesis = token_id == GENESIS_TOKEN_ID;

            let mut name: ByteArray = "";
            let mut prefix_value: ByteArray = "";
            let mut suffix_value: ByteArray = "";
            let mut prefix_name: felt252 = 0;
            let mut suffix_name: felt252 = 0;

            if is_genesis {
                name.append(@"Tiddy Mun");
                prefix_value.append(@"Genesis");
                suffix_value.append(@"Genesis");
            } else {
                prefix_name = beast_definitions::get_prefix(tiddy_mun.prefix);
                suffix_name = beast_definitions::get_suffix(tiddy_mun.suffix);
                prefix_value = felt252_to_byte_array(prefix_name);
                suffix_value = felt252_to_byte_array(suffix_name);
                name.append(@format!("\\\"{} {}\\\" Tiddy Mun", prefix_value, suffix_value));
            }

            let card_asset = Self::selected_asset_uri(tiddy_mun);
            let raw_asset = Self::selected_asset_uri(tiddy_mun);
            let tier_value: u16 = TIDDY_MUN_TIER.into();
            let power = (6 - tier_value) * tiddy_mun.level;
            let card_attrs = TiddyMunCardAttributes {
                tier: TIDDY_MUN_TIER,
                level: tiddy_mun.level,
                beast_type: TIDDY_MUN_TYPE,
                power,
                health: tiddy_mun.health,
                shiny: tiddy_mun.shiny,
            };
            let svg = TiddyMunCardTrait::generate_svg(
                prefix_name, suffix_name, 'Tiddy Mun', 0, card_attrs, card_asset,
            );
            let image = format!("data:image/svg+xml;base64,{}", bytes_base64_encode(svg));

            let mut level_value: ByteArray = "";
            level_value.append(@format!("{}", tiddy_mun.level));
            let mut health_value: ByteArray = "";
            health_value.append(@format!("{}", tiddy_mun.health));
            let mut id_value: ByteArray = "";
            id_value.append(@format!("{}", tiddy_mun.id));
            let shiny_value = Self::bool_value(tiddy_mun.shiny);
            let animated_value = Self::bool_value(tiddy_mun.animated);
            let genesis_value = Self::bool_value(is_genesis);

            let mut json: ByteArray = "";
            json.append(@"data:application/json;utf8,{");
            json.append(@"\"name\":\"");
            json.append(@name);
            json.append(@"\",");
            json
                .append(
                    @"\"description\":\"A grey-gowned bog spirit from the Lincolnshire carrs, Tiddy Mun slips through fen mist with white tangled hair and a peewit laugh. Loved as well as feared, he was called on at the new moon to draw back floodwaters, yet old tales say he cursed the land when his watery home was drained.\",",
                );
            json.append(@"\"image\":\"");
            json.append(@image);
            json.append(@"\",");
            json.append(@"\"animation_url\":\"");
            json.append(@raw_asset);
            json.append(@"\",");
            json.append(@"\"attributes\":[");
            Self::append_attribute(ref json, "Beast", "Tiddy Mun", true);
            Self::append_attribute(ref json, "Beast ID", id_value, true);
            Self::append_attribute(ref json, "Prefix", prefix_value, true);
            Self::append_attribute(ref json, "Suffix", suffix_value, true);
            Self::append_attribute(ref json, "Level", level_value, true);
            Self::append_attribute(ref json, "Health", health_value, true);
            Self::append_attribute(ref json, "Shiny", shiny_value, true);
            Self::append_attribute(ref json, "Animated", animated_value, true);
            Self::append_attribute(ref json, "Genesis", genesis_value, false);
            json.append(@"]}");
            json
        }
    }

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

    #[abi(embed_v0)]
    impl TiddyMunAnimation of ITiddyMunAnimation<ContractState> {
        fn animation_url(self: @ContractState, token_id: u256) -> ByteArray {
            InternalTrait::build_metadata_uri(self, token_id)
        }
    }
}
