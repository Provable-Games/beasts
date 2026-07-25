/// Canonical art provider deployed by the BeastRegistry factory, one instance
/// per community species. Holds the four variant data URIs and selects among
/// them from the decoded beast's shiny/animated flags. Not upgradable; the
/// only mutator is registry-gated `set_art`, so a factory provider whose
/// species is art-locked is provably frozen.
#[starknet::contract]
pub mod stored_art_provider {
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::super::interfaces::{IBeastArtProvider, IStoredArtProvider};
    use super::super::pack::PackableBeast;

    #[storage]
    struct Storage {
        registry: ContractAddress,
        beast_id: u64,
        png_regular: ByteArray,
        png_shiny: ByteArray,
        gif_regular: ByteArray,
        gif_shiny: ByteArray,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        registry: ContractAddress,
        beast_id: u64,
        png_regular: ByteArray,
        png_shiny: ByteArray,
        gif_regular: ByteArray,
        gif_shiny: ByteArray,
    ) {
        InternalTrait::assert_valid_art_set(@png_regular, @png_shiny, @gif_regular, @gif_shiny);

        self.registry.write(registry);
        self.beast_id.write(beast_id);
        self.png_regular.write(png_regular);
        self.png_shiny.write(png_shiny);
        self.gif_regular.write(gif_regular);
        self.gif_shiny.write(gif_shiny);
    }

    #[abi(embed_v0)]
    impl BeastArtProviderImpl of IBeastArtProvider<ContractState> {
        fn get_data_uri(self: @ContractState, beast: PackableBeast) -> ByteArray {
            assert(beast.id == self.beast_id.read(), 'Provider: wrong species');

            if beast.animated == 1 {
                if beast.shiny == 1 {
                    self.gif_shiny.read()
                } else {
                    self.gif_regular.read()
                }
            } else {
                if beast.shiny == 1 {
                    self.png_shiny.read()
                } else {
                    self.png_regular.read()
                }
            }
        }
    }

    #[abi(embed_v0)]
    impl StoredArtProviderImpl of IStoredArtProvider<ContractState> {
        fn set_art(
            ref self: ContractState,
            beast_id: u64,
            png_regular: ByteArray,
            png_shiny: ByteArray,
            gif_regular: ByteArray,
            gif_shiny: ByteArray,
        ) {
            // Double gate: only the registry may write, and only for the
            // species this provider was deployed for (defense against any
            // registry-side routing bug).
            let caller = starknet::get_caller_address();
            assert(caller == self.registry.read(), 'Provider: not registry');
            assert(beast_id == self.beast_id.read(), 'Provider: wrong species');
            InternalTrait::assert_valid_art_set(@png_regular, @png_shiny, @gif_regular, @gif_shiny);

            self.png_regular.write(png_regular);
            self.png_shiny.write(png_shiny);
            self.gif_regular.write(gif_regular);
            self.gif_shiny.write(gif_shiny);
        }

        fn get_registry(self: @ContractState) -> ContractAddress {
            self.registry.read()
        }

        fn get_species_id(self: @ContractState) -> u64 {
            self.beast_id.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn assert_valid_art_set(
            png_regular: @ByteArray,
            png_shiny: @ByteArray,
            gif_regular: @ByteArray,
            gif_shiny: @ByteArray,
        ) {
            Self::assert_valid_data_uri(png_regular, false);
            Self::assert_valid_data_uri(png_shiny, false);
            Self::assert_valid_data_uri(gif_regular, true);
            Self::assert_valid_data_uri(gif_shiny, true);
        }

        /// The renderer embeds these URIs verbatim inside a single-quoted SVG
        /// attribute, and the factory provider carries the trusted
        /// "verified art" designation — so the content must be provably
        /// inert: an exact image data-URI prefix followed by a non-empty
        /// standard-base64 payload. Quotes, markup, and control bytes cannot
        /// pass the base64 charset.
        fn assert_valid_data_uri(uri: @ByteArray, is_gif: bool) {
            let prefix: ByteArray = if is_gif {
                "data:image/gif;base64,"
            } else {
                "data:image/png;base64,"
            };
            let prefix_len = prefix.len();
            assert(uri.len() > prefix_len, 'Provider: bad art prefix');

            let mut i: u32 = 0;
            while i < prefix_len {
                assert(uri.at(i).unwrap() == prefix.at(i).unwrap(), 'Provider: bad art prefix');
                i += 1;
            }

            let total_len = uri.len();
            let mut j = prefix_len;
            while j < total_len {
                assert(Self::is_base64_char(uri.at(j).unwrap()), 'Provider: bad art payload');
                j += 1;
            }
        }

        fn is_base64_char(byte: u8) -> bool {
            (byte >= 'A' && byte <= 'Z')
                || (byte >= 'a' && byte <= 'z')
                || (byte >= '0' && byte <= '9')
                || byte == '+'
                || byte == '/'
                || byte == '='
        }
    }
}
