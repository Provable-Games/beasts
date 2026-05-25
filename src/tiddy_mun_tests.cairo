#[cfg(test)]
mod tiddy_mun_tests {
    use beasts_nft::tiddy_mun::{
        ITiddyMunAnimationDispatcher, ITiddyMunAnimationDispatcherTrait, ITiddyMunNftDispatcher,
        ITiddyMunNftDispatcherTrait, TiddyMun,
    };
    use beasts_nft::tiddy_mun_assets;
    use openzeppelin_interfaces::erc721::{
        IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher,
        IERC721MetadataDispatcherTrait,
    };
    use openzeppelin_interfaces::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
    use openzeppelin_interfaces::upgrades::{IUpgradeableDispatcher, IUpgradeableDispatcherTrait};
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
        stop_cheat_caller_address,
    };
    use starknet::{ClassHash, ContractAddress};

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    fn deploy_contract() -> (
        ITiddyMunNftDispatcher,
        IERC721Dispatcher,
        IERC721MetadataDispatcher,
        ITiddyMunAnimationDispatcher,
        IOwnableDispatcher,
        IUpgradeableDispatcher,
        ContractAddress,
        ContractAddress,
    ) {
        let owner = test_address('owner');
        let minter = test_address('minter');
        let contract = declare("tiddy_mun_nft").unwrap().contract_class();

        let mut calldata = array![];
        let name: ByteArray = "Tiddy Mun";
        let symbol: ByteArray = "TIDDY";
        name.serialize(ref calldata);
        symbol.serialize(ref calldata);
        owner.serialize(ref calldata);
        minter.serialize(ref calldata);

        let (contract_address, _) = contract.deploy(@calldata).unwrap();

        (
            ITiddyMunNftDispatcher { contract_address },
            IERC721Dispatcher { contract_address },
            IERC721MetadataDispatcher { contract_address },
            ITiddyMunAnimationDispatcher { contract_address },
            IOwnableDispatcher { contract_address },
            IUpgradeableDispatcher { contract_address },
            owner,
            minter,
        )
    }

    #[test]
    fn test_constructor_mints_genesis_and_sets_config() {
        let (tiddy, erc721, metadata, _, ownable, _, owner, minter) = deploy_contract();

        assert(metadata.name() == "Tiddy Mun", 'Wrong name');
        assert(metadata.symbol() == "TIDDY", 'Wrong symbol');
        assert(ownable.owner() == owner, 'Wrong owner');
        assert(tiddy.get_minter_address() == minter, 'Wrong minter');
        assert(tiddy.total_supply() == 1, 'Wrong initial supply');
        assert(erc721.owner_of(1) == owner, 'Wrong genesis owner');
        assert(erc721.balance_of(owner) == 1, 'Wrong owner balance');
        assert(tiddy.is_minted(0, 0), 'Genesis not marked');

        let expected = TiddyMun {
            id: 76, prefix: 0, suffix: 0, health: 100, level: 1, animated: false, shiny: false,
        };
        assert(tiddy.get_tiddy_mun(1) == expected, 'Wrong genesis data');
    }

    #[test]
    fn test_owner_can_update_minter_address() {
        let (tiddy, _, _, _, _, _, owner, _) = deploy_contract();
        let new_minter = test_address('new_minter');

        start_cheat_caller_address(tiddy.contract_address, owner);
        tiddy.set_minter_address(new_minter);
        stop_cheat_caller_address(tiddy.contract_address);

        assert(tiddy.get_minter_address() == new_minter, 'Minter not updated');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_non_owner_cannot_update_minter_address() {
        let (tiddy, _, _, _, _, _, _, _) = deploy_contract();
        let random = test_address('random');
        let new_minter = test_address('new_minter');

        start_cheat_caller_address(tiddy.contract_address, random);
        tiddy.set_minter_address(new_minter);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Not authorized to mint',))]
    fn test_only_minter_can_mint() {
        let (tiddy, _, _, _, _, _, _, _) = deploy_contract();
        let random = test_address('random');
        let recipient = test_address('recipient');

        start_cheat_caller_address(tiddy.contract_address, random);
        tiddy.mint(recipient, 76, 1, 1, 200, 3, false, false);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    fn test_live_mints_use_sequential_token_ids() {
        let (tiddy, erc721, _, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(tiddy.contract_address, minter);
        let first = tiddy.mint(recipient, 76, 1, 2, 300, 4, false, true);
        let second = tiddy.mint(recipient, 76, 2, 3, 400, 5, true, false);
        stop_cheat_caller_address(tiddy.contract_address);

        assert(first == 2, 'First live ID');
        assert(second == 3, 'Second live ID');
        assert(erc721.owner_of(first) == recipient, 'Wrong first owner');
        assert(erc721.owner_of(second) == recipient, 'Wrong second owner');
        assert(tiddy.total_supply() == 3, 'Wrong supply');

        let expected = TiddyMun {
            id: 76, prefix: 1, suffix: 2, health: 300, level: 4, animated: false, shiny: true,
        };
        assert(tiddy.get_tiddy_mun(first) == expected, 'Wrong live data');
    }

    #[test]
    #[should_panic(expected: ('Invalid prefix',))]
    fn test_mint_rejects_zero_prefix() {
        let (tiddy, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(tiddy.contract_address, minter);
        tiddy.mint(minter, 76, 0, 1, 100, 1, false, false);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_rejects_non_tiddy_mun_beast_id() {
        let (tiddy, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(tiddy.contract_address, minter);
        tiddy.mint(minter, 75, 1, 1, 100, 1, false, false);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid suffix',))]
    fn test_mint_rejects_zero_suffix() {
        let (tiddy, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(tiddy.contract_address, minter);
        tiddy.mint(minter, 76, 1, 0, 100, 1, false, false);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid prefix',))]
    fn test_mint_rejects_prefix_above_max() {
        let (tiddy, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(tiddy.contract_address, minter);
        tiddy.mint(minter, 76, 70, 1, 100, 1, false, false);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid suffix',))]
    fn test_mint_rejects_suffix_above_max() {
        let (tiddy, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(tiddy.contract_address, minter);
        tiddy.mint(minter, 76, 1, 19, 100, 1, false, false);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Tiddy Mun already minted',))]
    fn test_duplicate_prefix_suffix_rejected_even_with_different_traits() {
        let (tiddy, _, _, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(tiddy.contract_address, minter);
        tiddy.mint(recipient, 76, 7, 8, 100, 1, false, false);
        tiddy.mint(recipient, 76, 7, 8, 999, 9, true, true);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic]
    fn test_token_uri_fails_for_nonexistent_token() {
        let (_, _, metadata, _, _, _, _, _) = deploy_contract();
        metadata.token_uri(999);
    }

    #[test]
    fn test_genesis_token_uri_contains_core_metadata() {
        let (_, _, metadata, animation, _, _, _, _) = deploy_contract();
        let token_uri = metadata.token_uri(1);

        assert(animation.animation_url(1) == token_uri, 'Animation should mirror');
        assert(find_substring(@token_uri, @"Tiddy Mun").is_some(), 'Missing name');
        assert(find_substring(@token_uri, @"Genesis").is_some(), 'Missing genesis trait');
        assert(
            find_substring(@token_uri, @"data:image/svg+xml;base64,").is_some(), 'Missing card svg',
        );
        assert(find_substring(@token_uri, @"data:image/png;base64,").is_some(), 'Missing png uri');
        assert(
            find_substring(@token_uri, @tiddy_mun_assets::regular_static_uri()).is_some(),
            'Wrong animation',
        );
    }

    #[test]
    fn test_live_token_uri_uses_names_traits_and_all_asset_variants() {
        let (tiddy, _, metadata, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(tiddy.contract_address, minter);
        let regular_static = tiddy.mint(recipient, 76, 1, 1, 111, 2, false, false);
        let shiny_static = tiddy.mint(recipient, 76, 2, 2, 222, 3, false, true);
        let regular_animated = tiddy.mint(recipient, 76, 3, 3, 333, 4, true, false);
        let shiny_animated = tiddy.mint(recipient, 76, 4, 4, 444, 5, true, true);
        stop_cheat_caller_address(tiddy.contract_address);

        let uri = metadata.token_uri(regular_static);
        assert(find_substring(@uri, @"Agony Bane").is_some(), 'Missing live name');
        assert(find_substring(@uri, @"Agony").is_some(), 'Missing prefix');
        assert(find_substring(@uri, @"Bane").is_some(), 'Missing suffix');
        assert(find_substring(@uri, @"111").is_some(), 'Missing health');
        assert(find_substring(@uri, @"2").is_some(), 'Missing level');
        assert(find_substring(@uri, @"data:image/svg+xml;base64,").is_some(), 'Missing card svg');
        assert(find_substring(@uri, @"data:image/png;base64,").is_some(), 'Missing png uri');
        assert(
            find_substring(@uri, @tiddy_mun_assets::regular_static_uri()).is_some(),
            'Regular static animation',
        );

        let uri = metadata.token_uri(shiny_static);
        assert(
            find_substring(@uri, @tiddy_mun_assets::shiny_static_uri()).is_some(), 'Shiny static',
        );

        let uri = metadata.token_uri(regular_animated);
        assert(find_substring(@uri, @"data:image/gif;base64,").is_some(), 'Missing gif uri');
        assert(
            find_substring(@uri, @tiddy_mun_assets::regular_animated_uri()).is_some(),
            'Regular animated',
        );

        let uri = metadata.token_uri(shiny_animated);
        assert(
            find_substring(@uri, @tiddy_mun_assets::shiny_animated_uri()).is_some(),
            'Shiny animated',
        );
        assert(find_substring(@uri, @"true").is_some(), 'Missing bool trait');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_upgrade_not_owner() {
        let (tiddy, _, _, _, _, upgradeable, _, _) = deploy_contract();
        let random = test_address('random');
        let zero_class_hash: ClassHash = 0.try_into().unwrap();

        start_cheat_caller_address(tiddy.contract_address, random);
        upgradeable.upgrade(zero_class_hash);
        stop_cheat_caller_address(tiddy.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Class hash cannot be zero',))]
    fn test_upgrade_owner_reaches_upgradeable_validation() {
        let (tiddy, _, _, _, _, upgradeable, owner, _) = deploy_contract();
        let zero_class_hash: ClassHash = 0.try_into().unwrap();

        start_cheat_caller_address(tiddy.contract_address, owner);
        upgradeable.upgrade(zero_class_hash);
        stop_cheat_caller_address(tiddy.contract_address);
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
