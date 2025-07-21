#[cfg(test)]
mod integration_test {
    use beasts_nft::beast_definitions;
    use beasts_nft::pack::{PackableBeast, PackableBeastStorePacking};
    use beasts_nft::utils::felt252_to_byte_array;

    /// Test the full flow: pack beast data, then generate metadata
    #[test]
    fn test_beast_data_to_metadata_flow() {
        // Create a beast with specific attributes
        let beast = PackableBeast {
            id: 3, // Jiangshi
            prefix: 1, // Agony
            suffix: 2, // Root  
            level: 42,
            health: 1337,
            shiny: 0,
            animated: 0,
            timeline: 0,
        };

        // Test packing/unpacking
        let packed = PackableBeastStorePacking::pack(beast);
        let unpacked = PackableBeastStorePacking::unpack(packed);

        assert(unpacked.id == beast.id, 'Pack/unpack id');
        assert(unpacked.prefix == beast.prefix, 'Pack/unpack prefix');
        assert(unpacked.suffix == beast.suffix, 'Pack/unpack suffix');
        assert(unpacked.level == beast.level, 'Pack/unpack level');
        assert(unpacked.health == beast.health, 'Pack/unpack health');
        assert(unpacked.shiny == beast.shiny, 'Pack/unpack shiny');
        assert(unpacked.animated == beast.animated, 'Pack/unpack animated');
        assert(unpacked.timeline == beast.timeline, 'Pack/unpack timeline');

        // Test metadata generation
        let beast_name = beast_definitions::get_beast_name(beast.id);
        let beast_name_str = felt252_to_byte_array(beast_name);
        assert(beast_name_str == "Jiangshi", 'Beast name');

        let prefix_name = beast_definitions::get_prefix(beast.prefix);
        let prefix_str = felt252_to_byte_array(prefix_name);
        assert(prefix_str == "Agony", 'Prefix name');

        let suffix_name = beast_definitions::get_suffix(beast.suffix);
        let suffix_str = felt252_to_byte_array(suffix_name);
        assert(suffix_str == "Root", 'Suffix name');

        let beast_type = beast_definitions::get_type(beast.id);
        let type_str = felt252_to_byte_array(beast_type);
        assert(type_str == "Magical", 'Beast type');

        let tier = beast_definitions::get_tier(beast.id);
        assert(tier == 1, 'Beast tier');
        // Beast information validated
    }

    /// Test that each beast can be properly stored and retrieved
    #[test]
    fn test_all_beasts_pack_unpack() {
        let mut beast_id: u8 = 1;
        let mut failed = false;

        loop {
            if beast_id > 75 {
                break;
            }

            let beast = PackableBeast {
                id: beast_id,
                prefix: (beast_id % 69) + 1, // Valid prefix range
                suffix: (beast_id % 18) + 1, // Valid suffix range
                level: (beast_id.into() * 100_u16),
                health: (beast_id.into() * 200_u16),
                shiny: 0,
                animated: 0,
                timeline: 0,
            };

            let packed = PackableBeastStorePacking::pack(beast);
            let unpacked = PackableBeastStorePacking::unpack(packed);

            if unpacked.id != beast.id {
                // Failed on beast
                failed = true;
            }

            beast_id += 1;
        }

        assert(!failed, 'Some beasts failed pack/unpack');
    }
}
