#[cfg(test)]
mod tests {
    use beasts_nft::beast_definitions;
    use starknet::contract_address_const;
    use openzeppelin_token::erc721::interface::{IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait};
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
    
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
        assert(warlock_type == beast_definitions::TYPE_MAGICAL, 'Warlock should be Magical');
        
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
        let owner = contract_address_const::<'owner'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Declare and deploy contract
        let contract = declare("beasts_nft").unwrap().contract_class();
        
        // Setup calldata for deployment with proper ByteArray serialization
        let mut calldata = array![];
        
        // Name: "Beasts" as ByteArray
        calldata.append(0); // no full 31-byte chunks
        calldata.append('Beasts'); // pending word
        calldata.append(6); // pending word length (6 bytes)
        
        // Symbol: "BEAST" as ByteArray
        calldata.append(0); // no full 31-byte chunks
        calldata.append('BEAST'); // pending word
        calldata.append(5); // pending word length (5 bytes)
        
        // Base URI: empty ByteArray
        calldata.append(0); // no full 31-byte chunks
        calldata.append(0); // no pending word
        calldata.append(0); // pending word length (0 bytes)
        
        calldata.append(recipient.into());
        
        // Token IDs array as Span<u256>
        calldata.append(1); // array length
        calldata.append(3); // token_id for Jiangshi (u256 low)
        calldata.append(0); // token_id for Jiangshi (u256 high)
        
        calldata.append(owner.into());
        
        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
        
        // Get token URI for Jiangshi (token id 3)
        let token_uri = metadata_dispatcher.token_uri(3);
        
        // Print the token URI for inspection
        println!("Token URI for Jiangshi (id 3):");
        println!("{}", token_uri);
        
        // Verify it contains the beast name as a string, not a number
        // Check for "Jiangshi" in the JSON
        let jiangshi_position = find_substring(@token_uri, @"Jiangshi");
        assert(jiangshi_position.is_some(), 'Should contain Jiangshi name');
        
        // Verify it doesn't contain the felt252 number representation
        let number_position = find_substring(@token_uri, @"5361923958171199593");
        assert(number_position.is_none(), 'Should not contain felt number');
        
        // Verify it contains proper type string
        let magical_position = find_substring(@token_uri, @"Magical");
        assert(magical_position.is_some(), 'Should contain Magical type');
        
        // Verify SVG data URI
        let svg_position = find_substring(@token_uri, @"data:image/svg+xml,");
        assert(svg_position.is_some(), 'Should have SVG data URI');
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
            };
            
            if found {
                break Option::Some(i);
            }
            
            i += 1;
        }
    }
}