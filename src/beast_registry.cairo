/// Permissionless registry for community Beast species.
///
/// Anyone can register a new species (art, name, type, tier, minter) in a
/// single transaction. The registry is the only permissionless surface of the
/// system: the Beasts NFT contract reads species data and minter auth from
/// here, and exposes registry-only entrypoints for the provenance mint and
/// metadata-refresh fan-out (`IBeastsProvenance`).
///
/// Species IDs are assigned sequentially starting at 76 (1-75 are the genesis
/// species defined in `beast_definitions`). IDs are `u64`, so the collection
/// can never be filled or squatted out.
#[starknet::contract]
pub mod beast_registry {
    use core::num::traits::Zero;
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_interfaces::introspection::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use starknet::{ClassHash, ContractAddress};
    use super::super::interfaces::{
        BeastDefinition, BeastType, IBEAST_STATS_ID, IBeastRegistry, IBeastsProvenanceDispatcher,
        IBeastsProvenanceDispatcherTrait, IStoredArtProviderDispatcher,
        IStoredArtProviderDispatcherTrait,
    };
    use super::{SpeciesMeta, assert_valid_name};

    /// The first community species ID; 1-75 are genesis species.
    pub const FIRST_COMMUNITY_ID: u64 = 76;

    /// Shared per-species cooldown for art-driven metadata refreshes
    /// (`update_art` and `notify_art_updated`), protecting indexers from
    /// event-spam. Tune before deployment if needed.
    pub const ART_REFRESH_COOLDOWN_SECONDS: u64 = 3600;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        // Per-species definition. `meta` packs tier/type/flags into one slot.
        names: Map<u64, felt252>,
        artists: Map<u64, ContractAddress>,
        minters: Map<u64, ContractAddress>,
        art_providers: Map<u64, ContractAddress>,
        factory_providers: Map<u64, ContractAddress>, // canonical factory deploy, 0 if none
        stats_sources: Map<u64, ContractAddress>,
        metas: Map<u64, SpeciesMeta>,
        last_art_refresh: Map<u64, u64>,
        next_id: u64,
        stored_art_class_hash: ClassHash,
        nft: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct BeastRegistered {
        #[key]
        pub beast_id: u64,
        pub name: felt252,
        pub artist: ContractAddress,
        pub minter: ContractAddress,
        pub tier: u8,
        pub beast_type: u8,
        pub art_provider: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct MinterUpdated {
        #[key]
        pub beast_id: u64,
        pub minter: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct MinterLocked {
        #[key]
        pub beast_id: u64,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ArtUpdated {
        #[key]
        pub beast_id: u64,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ArtProviderUpdated {
        #[key]
        pub beast_id: u64,
        pub art_provider: ContractAddress,
        pub factory_provider: bool,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ArtLocked {
        #[key]
        pub beast_id: u64,
    }

    #[derive(Drop, starknet::Event)]
    pub struct StatsSourceUpdated {
        #[key]
        pub beast_id: u64,
        pub stats_source: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    pub struct ArtistTransferred {
        #[key]
        pub beast_id: u64,
        pub previous_artist: ContractAddress,
        pub new_artist: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        BeastRegistered: BeastRegistered,
        MinterUpdated: MinterUpdated,
        MinterLocked: MinterLocked,
        ArtUpdated: ArtUpdated,
        ArtProviderUpdated: ArtProviderUpdated,
        ArtLocked: ArtLocked,
        StatsSourceUpdated: StatsSourceUpdated,
        ArtistTransferred: ArtistTransferred,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, owner: ContractAddress, stored_art_class_hash: ClassHash,
    ) {
        self.ownable.initializer(owner);
        self.stored_art_class_hash.write(stored_art_class_hash);
        self.next_id.write(FIRST_COMMUNITY_ID);
    }

    #[abi(embed_v0)]
    impl BeastRegistryImpl of IBeastRegistry<ContractState> {
        fn register_beast_with_art(
            ref self: ContractState,
            name: felt252,
            beast_type: BeastType,
            tier: u8,
            minter: ContractAddress,
            png_regular: ByteArray,
            png_shiny: ByteArray,
            gif_regular: ByteArray,
            gif_shiny: ByteArray,
        ) -> u64 {
            let beast_id = InternalTrait::assert_registration_valid(@self, name, tier);

            // Deploy the canonical StoredArtProvider for this species.
            // salt = beast_id makes the address deterministic per species.
            let mut calldata: Array<felt252> = array![];
            starknet::get_contract_address().serialize(ref calldata);
            beast_id.serialize(ref calldata);
            png_regular.serialize(ref calldata);
            png_shiny.serialize(ref calldata);
            gif_regular.serialize(ref calldata);
            gif_shiny.serialize(ref calldata);

            let (provider, _) = starknet::syscalls::deploy_syscall(
                self.stored_art_class_hash.read(), beast_id.into(), calldata.span(), false,
            )
                .expect('Registry: art deploy failed');

            self.factory_providers.entry(beast_id).write(provider);
            InternalTrait::store_and_mint(
                ref self, beast_id, name, beast_type, tier, minter, provider, true,
            )
        }

        fn register_beast(
            ref self: ContractState,
            name: felt252,
            beast_type: BeastType,
            tier: u8,
            minter: ContractAddress,
            art_provider: ContractAddress,
        ) -> u64 {
            let beast_id = InternalTrait::assert_registration_valid(@self, name, tier);
            assert(art_provider.is_non_zero(), 'Registry: zero art provider');

            InternalTrait::store_and_mint(
                ref self, beast_id, name, beast_type, tier, minter, art_provider, false,
            )
        }

        fn set_minter(ref self: ContractState, beast_id: u64, minter: ContractAddress) {
            InternalTrait::assert_only_artist(@self, beast_id);
            let meta = self.metas.entry(beast_id).read();
            assert(!meta.minter_locked, 'Registry: minter locked');

            self.minters.entry(beast_id).write(minter);
            self.emit(MinterUpdated { beast_id, minter });
        }

        fn lock_minter(ref self: ContractState, beast_id: u64) {
            InternalTrait::assert_only_artist(@self, beast_id);
            let mut meta = self.metas.entry(beast_id).read();
            assert(!meta.minter_locked, 'Registry: minter locked');

            meta.minter_locked = true;
            self.metas.entry(beast_id).write(meta);
            self.emit(MinterLocked { beast_id });
        }

        fn update_art(
            ref self: ContractState,
            beast_id: u64,
            png_regular: ByteArray,
            png_shiny: ByteArray,
            gif_regular: ByteArray,
            gif_shiny: ByteArray,
        ) {
            InternalTrait::assert_only_artist(@self, beast_id);
            let meta = self.metas.entry(beast_id).read();
            assert(!meta.art_locked, 'Registry: art locked');
            assert(meta.factory_provider, 'Registry: not factory provider');
            InternalTrait::assert_refresh_cooldown(ref self, beast_id);

            let provider = IStoredArtProviderDispatcher {
                contract_address: self.art_providers.entry(beast_id).read(),
            };
            provider.set_art(beast_id, png_regular, png_shiny, gif_regular, gif_shiny);

            self.emit(ArtUpdated { beast_id });
            InternalTrait::notify_nft_art_updated(ref self, beast_id);
        }

        fn set_art_provider(ref self: ContractState, beast_id: u64, provider: ContractAddress) {
            InternalTrait::assert_only_artist(@self, beast_id);
            let mut meta = self.metas.entry(beast_id).read();
            assert(!meta.art_locked, 'Registry: art locked');
            assert(provider.is_non_zero(), 'Registry: zero art provider');
            // A provider swap changes every existing token's rendered art, so
            // it shares the refresh cooldown and fans out atomically with the
            // pointer change — otherwise a swap followed by lock_art would
            // leave marketplaces permanently stale.
            InternalTrait::assert_refresh_cooldown(ref self, beast_id);

            // The factory flag is recomputed against the species' canonical
            // factory deploy on every swap; it can never be true while
            // pointing at another species' provider.
            meta.factory_provider = provider == self.factory_providers.entry(beast_id).read();
            self.metas.entry(beast_id).write(meta);
            self.art_providers.entry(beast_id).write(provider);

            self
                .emit(
                    ArtProviderUpdated {
                        beast_id, art_provider: provider, factory_provider: meta.factory_provider,
                    },
                );
            InternalTrait::notify_nft_art_updated(ref self, beast_id);
        }

        fn notify_art_updated(ref self: ContractState, beast_id: u64) {
            InternalTrait::assert_only_artist(@self, beast_id);
            let meta = self.metas.entry(beast_id).read();
            assert(!meta.art_locked, 'Registry: art locked');
            InternalTrait::assert_refresh_cooldown(ref self, beast_id);

            self.emit(ArtUpdated { beast_id });
            InternalTrait::notify_nft_art_updated(ref self, beast_id);
        }

        fn lock_art(ref self: ContractState, beast_id: u64) {
            InternalTrait::assert_only_artist(@self, beast_id);
            let mut meta = self.metas.entry(beast_id).read();
            assert(!meta.art_locked, 'Registry: art locked');

            meta.art_locked = true;
            self.metas.entry(beast_id).write(meta);
            self.emit(ArtLocked { beast_id });
        }

        fn set_stats_source(ref self: ContractState, beast_id: u64, source: ContractAddress) {
            InternalTrait::assert_only_artist(@self, beast_id);

            // Verified once, at set time: a non-zero source must be a
            // deployed contract registering IBEAST_STATS_ID via SRC5.
            // Zero clears the source (stats off).
            if source.is_non_zero() {
                let src5 = ISRC5Dispatcher { contract_address: source };
                assert(src5.supports_interface(IBEAST_STATS_ID), 'Registry: bad stats source');
            }

            self.stats_sources.entry(beast_id).write(source);
            self.emit(StatsSourceUpdated { beast_id, stats_source: source });
        }

        fn transfer_artist_role(
            ref self: ContractState, beast_id: u64, new_artist: ContractAddress,
        ) {
            InternalTrait::assert_only_artist(@self, beast_id);
            assert(new_artist.is_non_zero(), 'Registry: zero artist');

            let previous_artist = self.artists.entry(beast_id).read();
            self.artists.entry(beast_id).write(new_artist);
            self.emit(ArtistTransferred { beast_id, previous_artist, new_artist });
        }

        fn get_definition(self: @ContractState, beast_id: u64) -> BeastDefinition {
            InternalTrait::assert_registered(self, beast_id);
            let meta = self.metas.entry(beast_id).read();

            BeastDefinition {
                name: self.names.entry(beast_id).read(),
                beast_type: meta.beast_type,
                tier: meta.tier,
                minter: self.minters.entry(beast_id).read(),
                artist: self.artists.entry(beast_id).read(),
                art_provider: self.art_providers.entry(beast_id).read(),
                stats_source: self.stats_sources.entry(beast_id).read(),
                factory_provider: meta.factory_provider,
                art_locked: meta.art_locked,
                minter_locked: meta.minter_locked,
            }
        }

        fn get_minter(self: @ContractState, beast_id: u64) -> ContractAddress {
            self.minters.entry(beast_id).read()
        }

        fn get_artist(self: @ContractState, beast_id: u64) -> ContractAddress {
            self.artists.entry(beast_id).read()
        }

        fn get_art_provider(self: @ContractState, beast_id: u64) -> ContractAddress {
            self.art_providers.entry(beast_id).read()
        }

        fn get_stats_source(self: @ContractState, beast_id: u64) -> ContractAddress {
            self.stats_sources.entry(beast_id).read()
        }

        fn get_species_traits(self: @ContractState, beast_id: u64) -> (u8, u8) {
            InternalTrait::assert_registered(self, beast_id);
            let meta = self.metas.entry(beast_id).read();
            (meta.tier, meta.beast_type)
        }

        fn get_species_name(self: @ContractState, beast_id: u64) -> felt252 {
            InternalTrait::assert_registered(self, beast_id);
            self.names.entry(beast_id).read()
        }

        fn is_registered(self: @ContractState, beast_id: u64) -> bool {
            beast_id >= FIRST_COMMUNITY_ID && beast_id < self.next_id.read()
        }

        fn is_art_locked(self: @ContractState, beast_id: u64) -> bool {
            self.metas.entry(beast_id).read().art_locked
        }

        fn is_minter_locked(self: @ContractState, beast_id: u64) -> bool {
            self.metas.entry(beast_id).read().minter_locked
        }

        fn species_count(self: @ContractState) -> u64 {
            // Total species including the 75 genesis species.
            self.next_id.read() - 1
        }

        fn get_nft_address(self: @ContractState) -> ContractAddress {
            self.nft.read()
        }

        fn get_stored_art_class_hash(self: @ContractState) -> ClassHash {
            self.stored_art_class_hash.read()
        }

        fn set_nft_address(ref self: ContractState, nft: ContractAddress) {
            self.ownable.assert_only_owner();
            assert(self.nft.read().is_zero(), 'Registry: nft already set');
            assert(nft.is_non_zero(), 'Registry: zero nft');
            self.nft.write(nft);
        }

        fn set_stored_art_class_hash(ref self: ContractState, class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.stored_art_class_hash.write(class_hash);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Common registration validation. Returns the species ID that will
        /// be assigned. Reverts until `set_nft_address` has been called so a
        /// half-wired deployment cannot accept registrations.
        fn assert_registration_valid(self: @ContractState, name: felt252, tier: u8) -> u64 {
            assert(self.nft.read().is_non_zero(), 'Registry: nft not set');
            assert(tier >= 1 && tier <= 5, 'Registry: invalid tier');
            assert_valid_name(name);
            self.next_id.read()
        }

        /// Writes the full definition, advances the ID counter, then calls
        /// the NFT for the provenance mint. Definition is stored BEFORE the
        /// external call: the NFT reads tier/type back from the registry to
        /// encode the Genesis Beast's token ID.
        fn store_and_mint(
            ref self: ContractState,
            beast_id: u64,
            name: felt252,
            beast_type: BeastType,
            tier: u8,
            minter: ContractAddress,
            art_provider: ContractAddress,
            factory_provider: bool,
        ) -> u64 {
            let artist = starknet::get_caller_address();
            let type_code: u8 = beast_type.into();

            self.names.entry(beast_id).write(name);
            self.artists.entry(beast_id).write(artist);
            self.minters.entry(beast_id).write(minter);
            self.art_providers.entry(beast_id).write(art_provider);
            self
                .metas
                .entry(beast_id)
                .write(
                    SpeciesMeta {
                        tier,
                        beast_type: type_code,
                        factory_provider,
                        art_locked: false,
                        minter_locked: false,
                    },
                );
            self.next_id.write(beast_id + 1);

            let nft = IBeastsProvenanceDispatcher { contract_address: self.nft.read() };
            nft.mint_provenance(artist, beast_id);

            self
                .emit(
                    BeastRegistered {
                        beast_id, name, artist, minter, tier, beast_type: type_code, art_provider,
                    },
                );

            beast_id
        }

        fn assert_registered(self: @ContractState, beast_id: u64) {
            assert(
                beast_id >= FIRST_COMMUNITY_ID && beast_id < self.next_id.read(),
                'Registry: not registered',
            );
        }

        fn assert_only_artist(self: @ContractState, beast_id: u64) {
            Self::assert_registered(self, beast_id);
            let caller = starknet::get_caller_address();
            assert(caller == self.artists.entry(beast_id).read(), 'Registry: not artist');
        }

        fn assert_refresh_cooldown(ref self: ContractState, beast_id: u64) {
            let now = starknet::get_block_timestamp();
            let last = self.last_art_refresh.entry(beast_id).read();
            assert(
                last == 0 || now >= last + ART_REFRESH_COOLDOWN_SECONDS,
                'Registry: refresh cooldown',
            );
            self.last_art_refresh.entry(beast_id).write(now);
        }

        fn notify_nft_art_updated(ref self: ContractState, beast_id: u64) {
            let nft = IBeastsProvenanceDispatcher { contract_address: self.nft.read() };
            nft.emit_species_metadata_update(beast_id);
        }
    }
}

/// Per-species static traits and flags, manually packed into one felt252
/// storage slot: tier (8 bits) | type (8 bits) | factory (1) | art_locked (1)
/// | minter_locked (1).
#[derive(Drop, Copy, Serde, PartialEq)]
pub struct SpeciesMeta {
    pub tier: u8,
    pub beast_type: u8,
    pub factory_provider: bool,
    pub art_locked: bool,
    pub minter_locked: bool,
}

const TWO_POW_8: u256 = 0x100;
const TWO_POW_16: u256 = 0x10000;
const TWO_POW_17: u256 = 0x20000;
const TWO_POW_18: u256 = 0x40000;

pub impl SpeciesMetaStorePacking of starknet::storage_access::StorePacking<SpeciesMeta, felt252> {
    fn pack(value: SpeciesMeta) -> felt252 {
        let packed: u256 = value.tier.into()
            + value.beast_type.into() * TWO_POW_8
            + if value.factory_provider {
                TWO_POW_16
            } else {
                0
            }
            + if value.art_locked {
                TWO_POW_17
            } else {
                0
            }
            + if value.minter_locked {
                TWO_POW_18
            } else {
                0
            };
        packed.try_into().expect('pack species meta')
    }

    fn unpack(value: felt252) -> SpeciesMeta {
        let mut packed: u256 = value.into();

        let tier: u8 = (packed % TWO_POW_8).try_into().expect('unpack tier');
        packed = packed / TWO_POW_8;
        let beast_type: u8 = (packed % TWO_POW_8).try_into().expect('unpack type');
        packed = packed / TWO_POW_8;
        let factory_provider = (packed % 2) == 1;
        packed = packed / 2;
        let art_locked = (packed % 2) == 1;
        packed = packed / 2;
        let minter_locked = (packed % 2) == 1;
        packed = packed / 2;

        assert(packed == 0, 'invalid species meta');

        SpeciesMeta { tier, beast_type, factory_provider, art_locked, minter_locked }
    }
}

/// On-chain name guard. This is an injection defense, not a style rule:
/// `components_to_json` and the SVG builder embed species names unescaped,
/// so the charset is what keeps every token's metadata well-formed.
///
/// Rules: non-empty, <= 31 bytes, characters restricted to
/// [A-Za-z0-9], space, apostrophe, hyphen; no leading or trailing space.
/// Uniqueness is deliberately NOT enforced (name-squatting grief vector);
/// species ID is the identity.
pub fn assert_valid_name(name: felt252) {
    assert(name != 0, 'Registry: empty name');

    let mut value: u256 = name.into();
    let mut len: u32 = 0;
    // Bytes are extracted low-to-high, i.e. last character first.
    let mut leading_byte: u8 = 0;
    let mut trailing_byte: u8 = 0;

    while value != 0 {
        let byte: u8 = (value % 0x100).try_into().unwrap();
        assert(is_allowed_name_char(byte), 'Registry: invalid name char');
        if len == 0 {
            trailing_byte = byte;
        }
        leading_byte = byte;
        len += 1;
        value = value / 0x100;
    }

    assert(len <= 31, 'Registry: name too long');
    assert(leading_byte != 0x20, 'Registry: leading space');
    assert(trailing_byte != 0x20, 'Registry: trailing space');
}

fn is_allowed_name_char(byte: u8) -> bool {
    (byte >= 'A' && byte <= 'Z')
        || (byte >= 'a' && byte <= 'z')
        || (byte >= '0' && byte <= '9')
        || byte == ' '
        || byte == '\''
        || byte == '-'
}

#[cfg(test)]
mod tests {
    use super::{SpeciesMeta, SpeciesMetaStorePacking, assert_valid_name};

    #[test]
    fn test_species_meta_round_trip() {
        let meta = SpeciesMeta {
            tier: 3, beast_type: 2, factory_provider: true, art_locked: false, minter_locked: true,
        };
        let unpacked = SpeciesMetaStorePacking::unpack(SpeciesMetaStorePacking::pack(meta));
        assert(unpacked == meta, 'meta round trip');
    }

    #[test]
    fn test_species_meta_all_flags() {
        let meta = SpeciesMeta {
            tier: 5, beast_type: 0, factory_provider: true, art_locked: true, minter_locked: true,
        };
        let unpacked = SpeciesMetaStorePacking::unpack(SpeciesMetaStorePacking::pack(meta));
        assert(unpacked == meta, 'all flags round trip');
    }

    #[test]
    fn test_valid_names() {
        assert_valid_name('Warlock');
        assert_valid_name('Fire Drake');
        assert_valid_name('K9');
        assert_valid_name('Ol\' One-Eye');
        assert_valid_name('x');
        assert_valid_name('A name that is 31 bytes long ok');
    }

    #[test]
    #[should_panic(expected: 'Registry: empty name')]
    fn test_empty_name_rejected() {
        assert_valid_name(0);
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid name char')]
    fn test_double_quote_rejected() {
        assert_valid_name('bad"name');
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid name char')]
    fn test_backslash_rejected() {
        assert_valid_name('bad\\name');
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid name char')]
    fn test_angle_bracket_rejected() {
        assert_valid_name('<svg>');
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid name char')]
    fn test_control_byte_rejected() {
        // 0x07 (BEL) embedded via a raw felt value: 'A' << 8 | 0x07
        assert_valid_name(0x4107);
    }

    #[test]
    #[should_panic(expected: 'Registry: invalid name char')]
    fn test_comma_rejected() {
        assert_valid_name('a,b');
    }

    #[test]
    #[should_panic(expected: 'Registry: leading space')]
    fn test_leading_space_rejected() {
        assert_valid_name(' Warlock');
    }

    #[test]
    #[should_panic(expected: 'Registry: trailing space')]
    fn test_trailing_space_rejected() {
        assert_valid_name('Warlock ');
    }
}
