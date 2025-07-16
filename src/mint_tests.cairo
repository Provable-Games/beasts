#[cfg(test)]
mod mint_tests {
    use beasts_nft::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};
    use starknet::{ContractAddress, contract_address_const};
    use openzeppelin_token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait};
    use openzeppelin_access::ownable::interface::IOwnableDispatcher;
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address, stop_cheat_caller_address};
    
    fn deploy_contract() -> (IBeastsDispatcher, IERC721Dispatcher, IOwnableDispatcher, ContractAddress) {
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
        
        // Recipient
        calldata.append(recipient.into());
        
        // Token IDs array (empty span)
        calldata.append(0); // array length
        
        // Owner
        calldata.append(owner.into());
        
        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        
        let beasts_dispatcher = IBeastsDispatcher { contract_address };
        let erc721_dispatcher = IERC721Dispatcher { contract_address };
        let ownable_dispatcher = IOwnableDispatcher { contract_address };
        
        (beasts_dispatcher, erc721_dispatcher, ownable_dispatcher, owner)
    }

    #[test]
    fn test_set_minter() {
        let (beasts, _, ownable, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        
        // Set minter as owner
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Verify minter was set
        assert(beasts.get_minter() == minter, 'Minter not set correctly');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_set_minter_not_owner() {
        let (beasts, _, _, _) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let random_caller = contract_address_const::<'random'>();
        
        // Try to set minter as non-owner
        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_mint_basic() {
        let (beasts, erc721, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Mint a beast
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(
            recipient,
            3,    // Jiangshi
            1,    // Agony prefix
            2,    // Root suffix
            100,  // Level
            1000  // Health
        );
        stop_cheat_caller_address(beasts.contract_address);
        
        // Verify NFT was minted
        assert(erc721.balance_of(recipient) == 1, 'Balance should be 1');
        assert(erc721.owner_of(1) == recipient, 'Wrong owner');
        
        // Verify beast data
        let beast = beasts.get_beast(1);
        assert(beast.id == 3, 'Wrong beast id');
        assert(beast.prefix == 1, 'Wrong prefix');
        assert(beast.suffix == 2, 'Wrong suffix');
        assert(beast.level == 100, 'Wrong level');
        assert(beast.health == 1000, 'Wrong health');
        
        // Verify is_minted
        assert(beasts.is_minted(3, 1, 2), 'Should be minted');
    }

    #[test]
    #[should_panic(expected: ('Not authorized to mint',))]
    fn test_mint_not_authorized() {
        let (beasts, _, _, owner) = deploy_contract();
        let random_caller = contract_address_const::<'random'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Try to mint without being minter
        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.mint(recipient, 1, 0, 0, 1, 100);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_invalid_beast_id_zero() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Try to mint beast with ID 0
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(minter, 0, 0, 0, 1, 100);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_invalid_beast_id_too_high() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Try to mint beast with ID 76
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(minter, 76, 0, 0, 1, 100);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Beast already minted',))]
    fn test_mint_duplicate() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Mint a beast
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(recipient, 1, 2, 3, 100, 200);
        
        // Try to mint the same beast again (same id, prefix, suffix)
        beasts.mint(recipient, 1, 2, 3, 500, 600); // Different level/health but same identity
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_mint_same_beast_different_attributes() {
        let (beasts, erc721, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Mint same beast ID with different prefix/suffix
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(recipient, 5, 0, 0, 100, 200); // Basilisk with no prefix/suffix
        beasts.mint(recipient, 5, 1, 0, 100, 200); // Basilisk with Agony prefix
        beasts.mint(recipient, 5, 0, 1, 100, 200); // Basilisk with Bane suffix
        stop_cheat_caller_address(beasts.contract_address);
        
        // Should have 3 NFTs
        assert(erc721.balance_of(recipient) == 3, 'Should have 3 NFTs');
        
        // Verify different beasts
        assert(beasts.is_minted(5, 0, 0), 'First should be minted');
        assert(beasts.is_minted(5, 1, 0), 'Second should be minted');
        assert(beasts.is_minted(5, 0, 1), 'Third should be minted');
        assert(!beasts.is_minted(5, 1, 1), 'Fourth should not be minted');
    }

    #[test]
    fn test_mint_genesis_beasts() {
        let (beasts, erc721, _, owner) = deploy_contract();
        let recipient = contract_address_const::<'recipient'>();
        
        // Mint genesis beasts as owner
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.mint_genesis_beasts(recipient);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Should have 75 NFTs
        assert(erc721.balance_of(recipient) == 75, 'Should have 75 NFTs');
        
        // Check first and last beast
        let first_beast = beasts.get_beast(1);
        assert(first_beast.id == 1, 'First beast should be Warlock');
        assert(first_beast.prefix == 0, 'No prefix');
        assert(first_beast.suffix == 0, 'No suffix');
        assert(first_beast.level == 1, 'Level 1');
        assert(first_beast.health == 100, 'Health 100');
        
        let last_beast = beasts.get_beast(75);
        assert(last_beast.id == 75, 'Last beast should be Skeleton');
        assert(last_beast.prefix == 0, 'No prefix');
        assert(last_beast.suffix == 0, 'No suffix');
        assert(last_beast.level == 1, 'Level 1');
        assert(last_beast.health == 100, 'Health 100');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_mint_genesis_beasts_not_owner() {
        let (beasts, _, _, _) = deploy_contract();
        let random_caller = contract_address_const::<'random'>();
        
        // Try to mint genesis beasts as non-owner
        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.mint_genesis_beasts(random_caller);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_total_supply() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        
        // Initial supply should be 0
        assert(beasts.total_supply() == 0, 'Initial supply should be 0');
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Mint some beasts
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(minter, 1, 0, 0, 1, 100);
        assert(beasts.total_supply() == 1, 'Supply should be 1');
        
        beasts.mint(minter, 2, 0, 0, 1, 100);
        assert(beasts.total_supply() == 2, 'Supply should be 2');
        
        beasts.mint(minter, 3, 0, 0, 1, 100);
        assert(beasts.total_supply() == 3, 'Supply should be 3');
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_token_uri_with_minted_data() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Mint a beast with specific attributes
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(
            recipient,
            3,     // Jiangshi
            1,     // Agony prefix
            2,     // Root suffix
            42,    // Level
            1337   // Health
        );
        stop_cheat_caller_address(beasts.contract_address);
        
        // Get token URI using ERC721Metadata interface
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: beasts.contract_address };
        let token_uri = metadata_dispatcher.token_uri(1);
        
        // Verify it contains the minted data
        assert(find_substring(@token_uri, @"Jiangshi").is_some(), 'Should contain beast name');
        assert(find_substring(@token_uri, @"Agony").is_some(), 'Should contain prefix');
        assert(find_substring(@token_uri, @"Root").is_some(), 'Should contain suffix');
        assert(find_substring(@token_uri, @"42").is_some(), 'Should contain level');
        assert(find_substring(@token_uri, @"1337").is_some(), 'Should contain health');
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

    // ===== KING BEAST TESTS =====

    #[test]
    fn test_king_beast_basic_functionality() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        // Initially, no king beast should exist
        let initial_king_power = beasts.get_king_beast_power(1);
        assert(initial_king_power == 0, 'Initial king power should be 0');
        
        // Test minting a beast with level 10 (first beast of this type)
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(recipient, 1, 0, 0, 10, 100); // Beast ID 1 (Warlock), level 10
        stop_cheat_caller_address(beasts.contract_address);
        
        // Calculate expected power: level * (6 - tier)
        // Warlock is tier 1, so power = 10 * (6 - 1) = 50
        // Verify this beast is now the king
        let king_power = beasts.get_king_beast_power(1);
        assert(king_power == 50, 'King power should be 50');
    }

    #[test]
    fn test_king_beast_higher_power_replaces_king() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        let recipient2 = contract_address_const::<'recipient2'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        start_cheat_caller_address(beasts.contract_address, minter);
        
        // Mint first beast of type 1 (Warlock) with level 10
        // Power = 10 * (6 - 1) = 50
        beasts.mint(recipient, 1, 0, 0, 10, 100);
        let king_power_after_first = beasts.get_king_beast_power(1);
        assert(king_power_after_first == 50, 'First king should be 50');
        
        // Mint second beast of same type with higher level 15
        // Power = 15 * (6 - 1) = 75
        beasts.mint(recipient2, 1, 1, 1, 15, 150);
        let king_power_after_second = beasts.get_king_beast_power(1);
        assert(king_power_after_second == 75, 'King power should be 75');
        
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_king_beast_lower_power_does_not_replace() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        let recipient2 = contract_address_const::<'recipient2'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        start_cheat_caller_address(beasts.contract_address, minter);
        
        // Mint first beast of type 1 (Warlock) with level 20
        // Power = 20 * (6 - 1) = 100
        beasts.mint(recipient, 1, 0, 0, 20, 200);
        let king_power_after_first = beasts.get_king_beast_power(1);
        assert(king_power_after_first == 100, 'First king should be 100');
        
        // Mint second beast of same type with lower level 10
        // Power = 10 * (6 - 1) = 50
        beasts.mint(recipient2, 1, 1, 1, 10, 100);
        let king_power_after_second = beasts.get_king_beast_power(1);
        assert(king_power_after_second == 100, 'King should remain 100');
        
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_king_beast_different_tiers() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        start_cheat_caller_address(beasts.contract_address, minter);
        
        // Mint Warlock (ID 1, Tier 1) with level 10
        // Power = 10 * (6 - 1) = 50
        beasts.mint(recipient, 1, 0, 0, 10, 100);
        let warlock_king_power = beasts.get_king_beast_power(1);
        assert(warlock_king_power == 50, 'Warlock king should be 50');
        
        // Mint Yeti (ID 68, Tier 4) with level 15
        // Power = 15 * (6 - 4) = 30
        beasts.mint(recipient, 68, 0, 0, 15, 150);
        let yeti_king_power = beasts.get_king_beast_power(68);
        assert(yeti_king_power == 30, 'Yeti king should be 30');
        
        // Mint Skeleton (ID 75, Tier 5) with level 20
        // Power = 20 * (6 - 5) = 20
        beasts.mint(recipient, 75, 0, 0, 20, 200);
        let skeleton_king_power = beasts.get_king_beast_power(75);
        assert(skeleton_king_power == 20, 'Skeleton king should be 20');
        
        stop_cheat_caller_address(beasts.contract_address);
        
        // Verify each beast type has its own king
        assert(beasts.get_king_beast_power(1) == 50, 'Warlock king should be 50');
        assert(beasts.get_king_beast_power(68) == 30, 'Yeti king should be 30');
        assert(beasts.get_king_beast_power(75) == 20, 'Skeleton king should be 20');
    }

    #[test]
    fn test_king_beast_same_power_keeps_existing() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        let recipient2 = contract_address_const::<'recipient2'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        start_cheat_caller_address(beasts.contract_address, minter);
        
        // Mint first beast of type 1 (Warlock) with level 10
        // Power = 10 * (6 - 1) = 50
        beasts.mint(recipient, 1, 0, 0, 10, 100);
        let king_power_after_first = beasts.get_king_beast_power(1);
        assert(king_power_after_first == 50, 'First king should be 50');
        
        // Mint second beast of same type with same level
        // Power = 10 * (6 - 1) = 50
        beasts.mint(recipient2, 1, 1, 1, 10, 100);
        let king_power_after_second = beasts.get_king_beast_power(1);
        assert(king_power_after_second == 50, 'King should remain 50');
        
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_king_beast_edge_cases() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter = contract_address_const::<'minter'>();
        let recipient = contract_address_const::<'recipient'>();
        
        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
        
        start_cheat_caller_address(beasts.contract_address, minter);
        
        // Test with minimum level
        beasts.mint(recipient, 1, 0, 0, 1, 10);
        let min_king_power = beasts.get_king_beast_power(1);
        // Warlock (Tier 1): 1 * (6 - 1) = 5
        assert(min_king_power == 5, 'Min king should be 5');
        
        // Test with maximum valid beast ID and high level
        beasts.mint(recipient, 75, 0, 0, 1000, 10000);
        let max_king_power = beasts.get_king_beast_power(75);
        // Skeleton (Tier 5): 1000 * (6 - 5) = 1000
        assert(max_king_power == 1000, 'Max king should be 1000');
        
        stop_cheat_caller_address(beasts.contract_address);
    }
}