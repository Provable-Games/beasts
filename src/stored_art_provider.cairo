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
}
