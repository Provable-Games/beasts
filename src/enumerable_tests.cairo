#[cfg(test)]
mod enumerable_tests {
    use beasts_nft::interfaces::{
        IBeastsDispatcher, IBeastsDispatcherTrait, IBeastsOwnerEnumerableDispatcher,
        IBeastsOwnerEnumerableDispatcherTrait,
    };
    use openzeppelin_interfaces::erc721::{IERC721Dispatcher, IERC721DispatcherTrait};
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
        start_mock_call, stop_cheat_caller_address,
    };
    use starknet::ContractAddress;

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    fn deploy() -> (
        IBeastsDispatcher, IERC721Dispatcher, IBeastsOwnerEnumerableDispatcher, ContractAddress,
    ) {
        let owner = test_address('owner');
        let provider = test_address('provider');
        let art: ByteArray = "data:image/png;base64,iVBORw0KGgoAAAA1";
        start_mock_call(provider, selector!("get_data_uri"), art);

        let contract = declare("beasts_nft").unwrap().contract_class();
        let mut calldata = array![];
        let name: ByteArray = "Beasts";
        let symbol: ByteArray = "BEAST";
        name.serialize(ref calldata);
        symbol.serialize(ref calldata);
        owner.serialize(ref calldata);
        owner.serialize(ref calldata);
        500_u128.serialize(ref calldata);
        provider.serialize(ref calldata);
        provider.serialize(ref calldata);
        provider.serialize(ref calldata);
        provider.serialize(ref calldata);
        0.serialize(ref calldata);

        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        (
            IBeastsDispatcher { contract_address },
            IERC721Dispatcher { contract_address },
            IBeastsOwnerEnumerableDispatcher { contract_address },
            owner,
        )
    }

    /// Every token an address holds, read back through enumeration.
    fn tokens_of(
        enumerable: IBeastsOwnerEnumerableDispatcher,
        erc721: IERC721Dispatcher,
        owner: ContractAddress,
    ) -> Array<u256> {
        let mut out = array![];
        let balance = erc721.balance_of(owner);
        let mut i: u256 = 0;
        while i < balance {
            out.append(enumerable.token_of_owner_by_index(owner, i));
            i += 1;
        }
        out
    }

    fn contains(haystack: @Array<u256>, needle: u256) -> bool {
        let mut i = 0;
        let mut found = false;
        while i < haystack.len() {
            if *haystack.at(i) == needle {
                found = true;
                break;
            }
            i += 1;
        }
        found
    }

    #[test]
    fn test_genesis_mints_are_all_enumerable() {
        let (beasts, erc721, enumerable, owner) = deploy();

        assert(erc721.balance_of(owner) == 75, 'Owner holds 75 genesis');
        let tokens = tokens_of(enumerable, erc721, owner);
        assert(tokens.len() == 75, 'Enumerates 75 tokens');

        // Every entry must be a real token owned by this address, and the
        // list must be free of duplicates — a broken index shows up as the
        // same token appearing twice.
        let mut i = 0;
        while i < tokens.len() {
            let token_id = *tokens.at(i);
            assert(erc721.owner_of(token_id) == owner, 'Enumerated token not owned');
            assert(beasts.get_beast(token_id).id != 0, 'Enumerated token invalid');

            let mut j = i + 1;
            while j < tokens.len() {
                assert(*tokens.at(j) != token_id, 'Duplicate in enumeration');
                j += 1;
            }
            i += 1;
        }
    }

    #[test]
    fn test_mint_appends_to_recipient() {
        let (beasts, erc721, enumerable, owner) = deploy();
        let minter = test_address('minter');
        let player = test_address('player');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        let (first, _, _) = beasts.mint(player, 3, 1, 1, 10, 100, 0, 0);
        let (second, _, _) = beasts.mint(player, 3, 2, 2, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        let tokens = tokens_of(enumerable, erc721, player);
        assert(tokens.len() == 2, 'Player enumerates 2');
        assert(*tokens.at(0) == first, 'First at index 0');
        assert(*tokens.at(1) == second, 'Second at index 1');
    }

    #[test]
    fn test_transfer_moves_between_owners() {
        let (beasts, erc721, enumerable, owner) = deploy();
        let minter = test_address('minter');
        let alice = test_address('alice');
        let bob = test_address('bob');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        let (token, _, _) = beasts.mint(alice, 3, 1, 1, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(erc721.contract_address, alice);
        erc721.transfer_from(alice, bob, token);
        stop_cheat_caller_address(erc721.contract_address);

        assert(tokens_of(enumerable, erc721, alice).len() == 0, 'Alice enumerates none');
        let bobs = tokens_of(enumerable, erc721, bob);
        assert(bobs.len() == 1, 'Bob enumerates one');
        assert(*bobs.at(0) == token, 'Bob holds the token');
    }

    #[test]
    fn test_removing_a_middle_token_keeps_the_list_dense() {
        // The swap-and-pop path. Removing from the middle must move the last
        // entry into the hole, or enumeration returns zero for that index and
        // silently loses a token.
        let (beasts, erc721, enumerable, owner) = deploy();
        let minter = test_address('minter');
        let alice = test_address('alice');
        let bob = test_address('bob');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        let (a, _, _) = beasts.mint(alice, 3, 1, 1, 10, 100, 0, 0);
        let (b, _, _) = beasts.mint(alice, 3, 2, 2, 10, 100, 0, 0);
        let (c, _, _) = beasts.mint(alice, 3, 3, 3, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        // Drop the middle one.
        start_cheat_caller_address(erc721.contract_address, alice);
        erc721.transfer_from(alice, bob, b);
        stop_cheat_caller_address(erc721.contract_address);

        let tokens = tokens_of(enumerable, erc721, alice);
        assert(tokens.len() == 2, 'Alice enumerates 2');
        assert(contains(@tokens, a), 'Kept token a');
        assert(contains(@tokens, c), 'Kept token c');
        assert(!contains(@tokens, b), 'Dropped token b');
        assert(*tokens.at(0) != 0 && *tokens.at(1) != 0, 'No hole left behind');
    }

    #[test]
    fn test_transfer_back_and_forth_stays_consistent() {
        let (beasts, erc721, enumerable, owner) = deploy();
        let minter = test_address('minter');
        let alice = test_address('alice');
        let bob = test_address('bob');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        let (a, _, _) = beasts.mint(alice, 3, 1, 1, 10, 100, 0, 0);
        let (b, _, _) = beasts.mint(alice, 3, 2, 2, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(erc721.contract_address, alice);
        erc721.transfer_from(alice, bob, a);
        stop_cheat_caller_address(erc721.contract_address);
        start_cheat_caller_address(erc721.contract_address, bob);
        erc721.transfer_from(bob, alice, a);
        stop_cheat_caller_address(erc721.contract_address);

        let tokens = tokens_of(enumerable, erc721, alice);
        assert(tokens.len() == 2, 'Alice enumerates 2 again');
        assert(contains(@tokens, a), 'Token a returned');
        assert(contains(@tokens, b), 'Token b retained');
        assert(tokens_of(enumerable, erc721, bob).len() == 0, 'Bob enumerates none');
    }

    #[test]
    fn test_self_transfer_does_not_duplicate() {
        // A self-transfer must be a no-op. Re-adding would list the token
        // twice and inflate the index past balance_of.
        let (beasts, erc721, enumerable, owner) = deploy();
        let minter = test_address('minter');
        let alice = test_address('alice');

        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(beasts.contract_address, minter);
        let (token, _, _) = beasts.mint(alice, 3, 1, 1, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        start_cheat_caller_address(erc721.contract_address, alice);
        erc721.transfer_from(alice, alice, token);
        stop_cheat_caller_address(erc721.contract_address);

        let tokens = tokens_of(enumerable, erc721, alice);
        assert(tokens.len() == 1, 'Still exactly one token');
        assert(*tokens.at(0) == token, 'Still the same token');
    }

    #[test]
    #[should_panic(expected: ('ERC721Enum: out of bounds index',))]
    fn test_index_past_balance_reverts() {
        let (_, erc721, enumerable, owner) = deploy();
        enumerable.token_of_owner_by_index(owner, erc721.balance_of(owner));
    }

    #[test]
    #[should_panic(expected: ('ERC721Enum: out of bounds index',))]
    fn test_enumerating_a_holder_of_nothing_reverts() {
        let (_, _, enumerable, _) = deploy();
        enumerable.token_of_owner_by_index(test_address('nobody'), 0);
    }
}
