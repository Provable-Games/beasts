#[cfg(test)]
mod mint_tests {
    use beasts_nft::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};
    use openzeppelin_access::ownable::interface::IOwnableDispatcher;
    use openzeppelin_token::erc721::interface::{
        IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher,
        IERC721MetadataDispatcherTrait,
    };
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
        stop_cheat_caller_address,
    };
    use starknet::ContractAddress;

    fn deploy_contract() -> (
        IBeastsDispatcher, IERC721Dispatcher, IOwnableDispatcher, ContractAddress,
    ) {
        let owner: ContractAddress = 'owner'.try_into().unwrap();
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

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
        let (beasts, _, _, owner) = deploy_contract();
        let minter: ContractAddress = 'minter'.try_into().unwrap();

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
        let minter: ContractAddress = 'minter'.try_into().unwrap();
        let random_caller: ContractAddress = 'random'.try_into().unwrap();

        // Try to set minter as non-owner
        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_mint_basic() {
        let (beasts, erc721, _, owner) = deploy_contract();
        let minter: ContractAddress = 'minter'.try_into().unwrap();
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);

        // Mint a beast
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts
            .mint(
                recipient,
                3, // Jiangshi
                1, // Agony prefix
                2, // Root suffix
                100, // Level
                1000 // Health
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
        let (beasts, _, _, _) = deploy_contract();
        let random_caller: ContractAddress = 'random'.try_into().unwrap();
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

        // Try to mint without being minter
        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.mint(recipient, 1, 0, 0, 1, 100);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_invalid_beast_id_zero() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter: ContractAddress = 'minter'.try_into().unwrap();

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
        let minter: ContractAddress = 'minter'.try_into().unwrap();

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
        let minter: ContractAddress = 'minter'.try_into().unwrap();
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

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
        let minter: ContractAddress = 'minter'.try_into().unwrap();
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

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
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

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
        let random_caller: ContractAddress = 'random'.try_into().unwrap();

        // Try to mint genesis beasts as non-owner
        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.mint_genesis_beasts(random_caller);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_total_supply() {
        let (beasts, _, _, owner) = deploy_contract();
        let minter: ContractAddress = 'minter'.try_into().unwrap();

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
        let minter: ContractAddress = 'minter'.try_into().unwrap();
        let recipient: ContractAddress = 'recipient'.try_into().unwrap();

        // Set minter
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_minter(minter);
        stop_cheat_caller_address(beasts.contract_address);

        // Mint a beast with specific attributes
        start_cheat_caller_address(beasts.contract_address, minter);
        beasts
            .mint(
                recipient,
                3, // Jiangshi
                1, // Agony prefix
                2, // Root suffix
                42, // Level
                1337 // Health
            );
        stop_cheat_caller_address(beasts.contract_address);

        // Get token URI using ERC721Metadata interface
        let metadata_dispatcher = IERC721MetadataDispatcher {
            contract_address: beasts.contract_address,
        };
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
            }

            if found {
                break Option::Some(i);
            }

            i += 1;
        }
    }
}
