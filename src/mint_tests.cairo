#[cfg(test)]
mod mint_tests {
    use beasts_nft::interfaces::{
        IBEASTS_OWNER_ENUMERABLE_ID, IBeastsDispatcher, IBeastsDispatcherTrait,
        IBeastsOwnerEnumerableDispatcher, IBeastsOwnerEnumerableDispatcherTrait,
    };
    use beasts_nft::pack::{PackableBeast, encode_token_id};
    use openzeppelin_interfaces::access::ownable::IOwnableDispatcher;
    use openzeppelin_interfaces::erc721::{
        IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher,
        IERC721MetadataDispatcherTrait,
    };
    use openzeppelin_interfaces::introspection::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
        start_mock_call, stop_cheat_caller_address,
    };
    use starknet::ContractAddress;

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    fn genesis_beast(beast_id: u8) -> PackableBeast {
        PackableBeast {
            id: beast_id, prefix: 0, suffix: 0, level: 1, health: 100, shiny: 1, animated: 1,
        }
    }

    fn genesis_token_id(beast_id: u8) -> u256 {
        encode_token_id(genesis_beast(beast_id))
    }

    fn deploy_contract() -> (
        IBeastsDispatcher,
        IERC721Dispatcher,
        IERC721MetadataDispatcher,
        IOwnableDispatcher,
        ContractAddress,
    ) {
        let owner = test_address('owner');
        let royalty_receiver: ContractAddress = test_address('royalty_receiver');
        let mock_provider = test_address('provider');
        let royalty_fraction: u128 = 500;

        let contract = declare("beasts_nft").unwrap().contract_class();

        let mut calldata = array![];
        let name: ByteArray = "Beasts";
        let symbol: ByteArray = "BEAST";

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

        (
            IBeastsDispatcher { contract_address },
            IERC721Dispatcher { contract_address },
            IERC721MetadataDispatcher { contract_address },
            IOwnableDispatcher { contract_address },
            owner,
        )
    }

    #[test]
    fn test_set_dungeon_address() {
        let (beasts, _, _, _, owner) = deploy_contract();
        let minter = test_address('minter');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        assert(beasts.get_dungeon_address() == minter, 'Minter not set correctly');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_set_dungeon_address_not_owner() {
        let (beasts, _, _, _, _) = deploy_contract();
        let minter = test_address('minter');
        let random_caller = test_address('random');

        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_constructor_mints_genesis_beasts_with_packed_ids() {
        let (beasts, erc721, _, _, owner) = deploy_contract();

        assert(erc721.balance_of(owner) == 75, 'Owner should have genesis');

        let first_expected = genesis_beast(1);
        let last_expected = genesis_beast(75);
        let first_token_id = encode_token_id(first_expected);
        let last_token_id = encode_token_id(last_expected);

        assert(first_token_id != 1, 'Genesis token should be packed');
        assert(erc721.owner_of(first_token_id) == owner, 'Wrong first owner');
        assert(erc721.owner_of(last_token_id) == owner, 'Wrong last owner');
        assert(beasts.get_beast(first_token_id) == first_expected, 'First beast mismatch');
        assert(beasts.get_beast(last_token_id) == last_expected, 'Last beast mismatch');
        assert(beasts.get_beast_rank(first_token_id) == 0, 'Genesis rank should be 0');
    }

    #[test]
    fn test_constructor_genesis_owner_enumeration() {
        let (beasts, erc721, _, _, owner) = deploy_contract();
        let enumerable = IBeastsOwnerEnumerableDispatcher {
            contract_address: beasts.contract_address,
        };

        assert(erc721.balance_of(owner) == 75, 'Owner should have genesis');

        let mut beast_id = 1_u8;
        let mut index = 0_u256;
        loop {
            if beast_id > 75_u8 {
                break;
            }

            assert(
                enumerable.token_of_owner_by_index(owner, index) == genesis_token_id(beast_id),
                'Wrong enumerable token',
            );

            beast_id += 1;
            index += 1;
        }
    }

    #[test]
    fn test_mint_basic_uses_encoded_token_id() {
        let (beasts, erc721, _, _, owner) = deploy_contract();
        let minter = test_address('minter');
        let recipient = test_address('recipient');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        let expected = PackableBeast {
            id: 3, prefix: 1, suffix: 2, level: 100, health: 1000, shiny: 0, animated: 1,
        };

        start_cheat_caller_address(beasts.contract_address, minter);
        let (token_id, insertion_rank, bookmark_set) = beasts
            .mint(recipient, 3, 1, 2, 100, 1000, 0, 1);
        stop_cheat_caller_address(beasts.contract_address);

        let enumerable = IBeastsOwnerEnumerableDispatcher {
            contract_address: beasts.contract_address,
        };

        assert(token_id == encode_token_id(expected), 'Token ID mismatch');
        assert(insertion_rank == 1, 'Insertion rank mismatch');
        assert(!bookmark_set, 'Bookmark should not be set');
        assert(erc721.owner_of(token_id) == recipient, 'Wrong owner');
        assert(erc721.balance_of(recipient) == 1, 'Balance should be 1');
        assert(enumerable.token_of_owner_by_index(recipient, 0) == token_id, 'Enumerable token');
        assert(beasts.get_beast(token_id) == expected, 'Stored beast mismatch');
        assert(beasts.is_minted(3, 1, 2), 'Should be minted');
    }

    #[test]
    #[should_panic(expected: ('Not authorized to mint',))]
    fn test_mint_not_authorized() {
        let (beasts, _, _, _, _) = deploy_contract();
        let random_caller = test_address('random');
        let recipient = test_address('recipient');

        start_cheat_caller_address(beasts.contract_address, random_caller);
        beasts.mint(recipient, 1, 0, 0, 1, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_invalid_beast_id_zero() {
        let (beasts, _, _, _, owner) = deploy_contract();
        let minter = test_address('minter');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(minter, 0, 0, 0, 1, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_invalid_beast_id_too_high() {
        let (beasts, _, _, _, owner) = deploy_contract();
        let minter = test_address('minter');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(minter, 76, 0, 0, 1, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Beast already minted',))]
    fn test_mint_duplicate() {
        let (beasts, _, _, _, owner) = deploy_contract();
        let minter = test_address('minter');
        let recipient = test_address('recipient');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(recipient, 1, 2, 3, 100, 200, 0, 0);
        beasts.mint(recipient, 1, 2, 3, 500, 600, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);
    }

    #[test]
    fn test_mint_same_beast_different_attributes() {
        let (beasts, erc721, _, _, owner) = deploy_contract();
        let minter = test_address('minter');
        let recipient = test_address('recipient');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        beasts.mint(recipient, 5, 1, 0, 100, 200, 0, 0);
        beasts.mint(recipient, 5, 0, 1, 100, 200, 0, 0);
        beasts.mint(recipient, 5, 1, 1, 100, 200, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        assert(erc721.balance_of(recipient) == 3, 'Should have 3 NFTs');
        assert(beasts.is_minted(5, 0, 0), 'Genesis should be minted');
        assert(beasts.is_minted(5, 1, 0), 'Prefix-only should mint');
        assert(beasts.is_minted(5, 0, 1), 'Suffix-only should mint');
        assert(beasts.is_minted(5, 1, 1), 'Both affixes should mint');
        assert(!beasts.is_minted(5, 2, 2), 'Unminted affixes should not');
    }

    #[test]
    fn test_transfer_owner_enumeration_swap_fill_and_append() {
        let (beasts, erc721, _, _, owner) = deploy_contract();
        let enumerable = IBeastsOwnerEnumerableDispatcher {
            contract_address: beasts.contract_address,
        };
        let recipient = test_address('recipient');
        let first_token_id = genesis_token_id(1);
        let second_token_id = genesis_token_id(2);
        let seventy_fourth_token_id = genesis_token_id(74);
        let last_token_id = genesis_token_id(75);

        start_cheat_caller_address(beasts.contract_address, owner);
        erc721.transfer_from(owner, recipient, first_token_id);
        stop_cheat_caller_address(beasts.contract_address);

        assert(erc721.balance_of(owner) == 74, 'Owner balance after first');
        assert(erc721.balance_of(recipient) == 1, 'Recipient balance first');
        assert(
            enumerable.token_of_owner_by_index(recipient, 0) == first_token_id,
            'Recipient first token',
        );
        assert(
            enumerable.token_of_owner_by_index(owner, 0) == last_token_id, 'Owner slot swap first',
        );

        start_cheat_caller_address(beasts.contract_address, owner);
        erc721.transfer_from(owner, recipient, second_token_id);
        stop_cheat_caller_address(beasts.contract_address);

        assert(erc721.balance_of(owner) == 73, 'Owner balance after second');
        assert(erc721.balance_of(recipient) == 2, 'Recipient balance second');
        assert(
            enumerable.token_of_owner_by_index(recipient, 1) == second_token_id,
            'Recipient append token',
        );
        assert(
            enumerable.token_of_owner_by_index(owner, 1) == seventy_fourth_token_id,
            'Owner slot swap second',
        );

        start_cheat_caller_address(beasts.contract_address, recipient);
        erc721.transfer_from(recipient, owner, second_token_id);
        stop_cheat_caller_address(beasts.contract_address);

        assert(erc721.balance_of(owner) == 74, 'Owner balance after return');
        assert(erc721.balance_of(recipient) == 1, 'Recipient balance after return');
        assert(
            enumerable.token_of_owner_by_index(recipient, 0) == first_token_id,
            'Recipient kept first',
        );
        assert(
            enumerable.token_of_owner_by_index(owner, 73) == second_token_id,
            'Owner append returned second',
        );

        start_cheat_caller_address(beasts.contract_address, recipient);
        erc721.transfer_from(recipient, owner, first_token_id);
        stop_cheat_caller_address(beasts.contract_address);

        assert(erc721.balance_of(owner) == 75, 'Owner balance restored');
        assert(erc721.balance_of(recipient) == 0, 'Recipient drained');
        assert(
            enumerable.token_of_owner_by_index(owner, 74) == first_token_id,
            'Owner append returned first',
        );
    }

    #[test]
    #[should_panic(expected: ('ERC721Enum: out of bounds index',))]
    fn test_owner_enumeration_out_of_bounds_panics() {
        let (beasts, _, _, _, owner) = deploy_contract();
        let enumerable = IBeastsOwnerEnumerableDispatcher {
            contract_address: beasts.contract_address,
        };

        enumerable.token_of_owner_by_index(owner, 75);
    }

    #[test]
    fn test_src5_supports_owner_enumerable_interface() {
        let (beasts, _, _, _, _) = deploy_contract();
        let src5 = ISRC5Dispatcher { contract_address: beasts.contract_address };

        assert(src5.supports_interface(IBEASTS_OWNER_ENUMERABLE_ID), 'Should support owner enum');
    }

    #[test]
    fn test_token_uri_with_minted_data() {
        let (beasts, _, metadata, _, owner) = deploy_contract();
        let minter = test_address('minter');
        let recipient = test_address('recipient');
        let mock_provider = test_address('provider');
        let mock_img: ByteArray = "data:image/png;base64,AA==";
        start_mock_call(mock_provider, selector!("get_data_uri"), mock_img);

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        let (token_id, _, _) = beasts.mint(recipient, 3, 1, 2, 42, 1337, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        let token_uri = metadata.token_uri(token_id);

        assert(
            find_substring(@token_uri, @"data:application/json;base64,").is_some(),
            'Should have JSON data URI',
        );
        assert(token_uri.len() > 0, 'Should return token URI');
    }

    #[test]
    #[should_panic]
    fn test_unowned_packed_token_id_fails_ownership_check() {
        let (beasts, _, _, _, _) = deploy_contract();
        let unowned = PackableBeast {
            id: 4, prefix: 1, suffix: 1, level: 2, health: 3, shiny: 0, animated: 0,
        };

        beasts.get_beast(encode_token_id(unowned));
    }

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
