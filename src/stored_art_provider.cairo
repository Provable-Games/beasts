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
        /// "verified art" designation — so the content must be provably an
        /// inert image: an exact data-URI prefix, a structurally valid
        /// standard-base64 payload (length multiple of 4, padding only at
        /// the end), and the encoded PNG/GIF magic bytes. The magic bytes
        /// need no decoding: PNG's 8-byte signature always base64-encodes to
        /// the prefix "iVBORw0KGgo", and GIF87a/89a headers to "R0lGOD".
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
            let payload_len = total_len - prefix_len;
            assert(payload_len % 4 == 0, 'Provider: bad art length');

            Self::assert_valid_magic(uri, prefix_len, payload_len, is_gif);

            // Base64 body: '=' padding may only appear in the final two
            // positions, and "=X" is never valid.
            let mut j = prefix_len;
            while j < total_len - 2 {
                assert(Self::is_base64_char(uri.at(j).unwrap()), 'Provider: bad art payload');
                j += 1;
            }
            let second_last = uri.at(total_len - 2).unwrap();
            let last = uri.at(total_len - 1).unwrap();
            assert(
                Self::is_base64_char(second_last) || second_last == '=',
                'Provider: bad art payload',
            );
            assert(Self::is_base64_char(last) || last == '=', 'Provider: bad art payload');
            if second_last == '=' {
                assert(last == '=', 'Provider: bad art payload');
            }
        }

        /// A fixed leading image signature always base64-encodes to a fixed
        /// character prefix, so magic-byte verification is a prefix
        /// comparison with no on-chain decoding:
        ///   PNG  89 50 4E 47 0D 0A 1A 0A + IHDR length -> "iVBORw0KGgo"
        ///   GIF  "GIF87a" -> "R0lGODdh", "GIF89a" -> "R0lGODlh"
        /// The GIF version characters must be checked too: "R0lGOD" alone
        /// admits payloads like "R0lGODAAAAAA", which decodes to the invalid
        /// header "GIF80".
        fn assert_valid_magic(uri: @ByteArray, prefix_len: u32, payload_len: u32, is_gif: bool) {
            if is_gif {
                assert(payload_len >= 8, 'Provider: bad art magic');
                assert(Self::matches_at(uri, prefix_len, @"R0lGOD"), 'Provider: bad art magic');
                let version = uri.at(prefix_len + 6).unwrap();
                assert(version == 'd' || version == 'l', 'Provider: bad art magic');
                assert(uri.at(prefix_len + 7).unwrap() == 'h', 'Provider: bad art magic');
            } else {
                assert(payload_len >= 11, 'Provider: bad art magic');
                assert(
                    Self::matches_at(uri, prefix_len, @"iVBORw0KGgo"), 'Provider: bad art magic',
                );
            }
        }

        /// Caller must guarantee `uri` has at least `offset + needle.len()`
        /// bytes.
        fn matches_at(uri: @ByteArray, offset: u32, needle: @ByteArray) -> bool {
            let needle_len = needle.len();
            let mut i: u32 = 0;
            let mut matched = true;
            while i < needle_len {
                if uri.at(offset + i).unwrap() != needle.at(i).unwrap() {
                    matched = false;
                    break;
                }
                i += 1;
            }
            matched
        }

        /// Strict base64 alphabet, excluding padding.
        fn is_base64_char(byte: u8) -> bool {
            (byte >= 'A' && byte <= 'Z')
                || (byte >= 'a' && byte <= 'z')
                || (byte >= '0' && byte <= '9')
                || byte == '+'
                || byte == '/'
        }
    }
}
