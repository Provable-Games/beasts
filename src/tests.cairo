#[cfg(test)]
mod tests {
    use beasts_nft::beast_definitions;
    use beasts_nft::pack::{PackableBeast, encode_token_id};
    use openzeppelin_interfaces::erc721::{
        IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait,
    };
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare, start_mock_call};
    use starknet::ContractAddress;

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    #[test]
    fn test_beast_names() {
        // Test that beast ID 1 is Warlock
        let warlock_name = beast_definitions::get_beast_name(1);
        assert(warlock_name == 'Warlock', 'Beast 1 should be Warlock');

        // Test that beast ID 68 is Yeti
        let yeti_name = beast_definitions::get_beast_name(68);
        assert(yeti_name == 'Yeti', 'Beast 68 should be Yeti');

        // Test that beast ID 75 is Skeleton
        let skeleton_name = beast_definitions::get_beast_name(75);
        assert(skeleton_name == 'Skeleton', 'Beast 75 should be Skeleton');
    }

    #[test]
    fn test_beast_types() {
        // Test beast types
        let warlock_type = beast_definitions::get_type(1);
        assert(warlock_type == beast_definitions::TYPE_MAGIC, 'Warlock should be Magical');

        let yeti_type = beast_definitions::get_type(68);
        assert(yeti_type == beast_definitions::TYPE_BRUTE, 'Yeti should be Brute');

        let skeleton_type = beast_definitions::get_type(75);
        assert(skeleton_type == beast_definitions::TYPE_BRUTE, 'Skeleton should be Brute');
    }

    #[test]
    fn test_beast_tiers() {
        // Test beast tiers
        let warlock_tier = beast_definitions::get_tier(1);
        assert(warlock_tier == beast_definitions::TIER_1, 'Warlock should be Tier 1');

        let yeti_tier = beast_definitions::get_tier(68);
        assert(yeti_tier == beast_definitions::TIER_4, 'Yeti should be Tier 4');

        let skeleton_tier = beast_definitions::get_tier(75);
        assert(skeleton_tier == beast_definitions::TIER_5, 'Skeleton should be Tier 5');
    }

    #[test]
    fn test_token_uri_returns_proper_strings() {
        // Deploy contract
        let owner = test_address('owner');
        let royalty_receiver = test_address('royalty_receiver');
        let mock_provider = test_address('provider');

        // Declare and deploy contract
        let contract = declare("beasts_nft").unwrap().contract_class();

        // Setup calldata for deployment with proper ByteArray serialization
        let mut calldata = array![];
        let name: ByteArray = "Beasts";
        let symbol: ByteArray = "BEAST";
        let royalty_fraction: u128 = 500;

        name.serialize(ref calldata);
        symbol.serialize(ref calldata);
        owner.serialize(ref calldata);
        royalty_receiver.serialize(ref calldata);
        royalty_fraction.serialize(ref calldata);
        mock_provider.serialize(ref calldata);
        mock_provider.serialize(ref calldata);
        mock_provider.serialize(ref calldata);
        mock_provider.serialize(ref calldata);
        0.serialize(ref calldata);
        0.serialize(ref calldata);

        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
        let mock_img: ByteArray = "data:image/png;base64,AA==";
        start_mock_call(mock_provider, selector!("get_data_uri"), mock_img);

        let jiangshi = PackableBeast {
            id: 3, prefix: 0, suffix: 0, level: 1, health: 100, shiny: 1, animated: 1,
        };
        let token_id = encode_token_id(jiangshi);

        // Get token URI for genesis Jiangshi
        let token_uri = metadata_dispatcher.token_uri(token_id);

        let json_data_uri_position = find_substring(@token_uri, @"data:application/json;base64,");
        assert(json_data_uri_position.is_some(), 'Should have JSON data URI');
        assert(token_uri.len() > 0, 'Should return token URI');
    }

    // Helper function to find substring in a ByteArray
    fn find_substring(text: @ByteArray, pattern: @ByteArray) -> Option<usize> {
        let text_len = text.len();
        let pattern_len = pattern.len();

        if pattern_len > text_len {
            return Option::None;
        }

        let mut i = 0;
        loop {
            if i > text_len - pattern_len {
                break Option::None;
            }

            let mut j = 0;
            let mut found = true;
            loop {
                if j >= pattern_len {
                    break;
                }

                if text.at(i + j) != pattern.at(j) {
                    found = false;
                    break;
                }
                j += 1;
            }

            if found {
                break Option::Some(i);
            }

            i += 1;
        }
    }
}
