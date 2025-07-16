#[cfg(test)]
mod test_felt252_conversion {
    use beasts_nft::beast_definitions;
    use beasts_nft::utils::felt252_to_byte_array;

    #[test]
    fn test_felt252_to_byte_array_conversion() {
        // Test beast names
        let jiangshi = beast_definitions::get_beast_name(3);
        let jiangshi_str = felt252_to_byte_array(jiangshi);
        println!("Jiangshi as ByteArray: {}", jiangshi_str);
        assert(jiangshi_str == "Jiangshi", 'Should convert to Jiangshi');

        let warlock = beast_definitions::get_beast_name(1);
        let warlock_str = felt252_to_byte_array(warlock);
        println!("Warlock as ByteArray: {}", warlock_str);
        assert(warlock_str == "Warlock", 'Should convert to Warlock');

        let yeti = beast_definitions::get_beast_name(68);
        let yeti_str = felt252_to_byte_array(yeti);
        println!("Yeti as ByteArray: {}", yeti_str);
        assert(yeti_str == "Yeti", 'Should convert to Yeti');

        // Test types
        let magical = beast_definitions::TYPE_MAGICAL;
        let magical_str = felt252_to_byte_array(magical);
        println!("Magical as ByteArray: {}", magical_str);
        assert(magical_str == "Magical", 'Should convert to Magical');

        // Test tiers
        let tier1 = beast_definitions::TIER_1;
        let tier1_str = felt252_to_byte_array(tier1);
        println!("Tier 1 as ByteArray: {}", tier1_str);
        assert(tier1_str == "1", 'Should convert to 1');
    }
}
