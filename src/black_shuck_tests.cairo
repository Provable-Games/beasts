#[cfg(test)]
mod black_shuck_tests {
    use beasts_nft::beast_card::{BeastCardAttributes, BeastCardTrait};
    use beasts_nft::black_shuck::{
        BlackShuck, IBlackShuckAnimationDispatcher, IBlackShuckAnimationDispatcherTrait,
        IBlackShuckNftDispatcher, IBlackShuckNftDispatcherTrait,
    };
    use beasts_nft::encoding::bytes_base64_encode;
    use beasts_nft::{beast_definitions, black_shuck_assets};
    use openzeppelin_interfaces::erc2981::{
        IERC2981AdminDispatcher, IERC2981AdminDispatcherTrait, IERC2981Dispatcher,
        IERC2981DispatcherTrait, IERC2981_ID,
    };
    use openzeppelin_interfaces::erc721::{
        IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher,
        IERC721MetadataDispatcherTrait, IERC721_ID,
    };
    use openzeppelin_interfaces::introspection::{ISRC5Dispatcher, ISRC5DispatcherTrait};
    use openzeppelin_interfaces::ownable::{IOwnableDispatcher, IOwnableDispatcherTrait};
    use openzeppelin_interfaces::upgrades::{IUpgradeableDispatcher, IUpgradeableDispatcherTrait};
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
        stop_cheat_caller_address,
    };
    use starknet::{ClassHash, ContractAddress};

    const BEAST_ID: u8 = 77;
    const ROYALTY_FRACTION: u128 = 500; // 5% of FEE_DENOMINATOR (10,000)

    fn test_address(address: felt252) -> ContractAddress {
        address.try_into().unwrap()
    }

    fn deploy_contract() -> (
        IBlackShuckNftDispatcher,
        IERC721Dispatcher,
        IERC721MetadataDispatcher,
        IBlackShuckAnimationDispatcher,
        IOwnableDispatcher,
        IUpgradeableDispatcher,
        ContractAddress,
        ContractAddress,
    ) {
        let owner = test_address('owner');
        let minter = test_address('minter');
        let contract = declare("black_shuck_nft").unwrap().contract_class();

        let mut calldata = array![];
        let name: ByteArray = "Black Shuck";
        let symbol: ByteArray = "SHUCK";
        name.serialize(ref calldata);
        symbol.serialize(ref calldata);
        owner.serialize(ref calldata);
        minter.serialize(ref calldata);
        test_address('royalty').serialize(ref calldata);
        ROYALTY_FRACTION.serialize(ref calldata);

        let (contract_address, _) = contract.deploy(@calldata).unwrap();

        (
            IBlackShuckNftDispatcher { contract_address },
            IERC721Dispatcher { contract_address },
            IERC721MetadataDispatcher { contract_address },
            IBlackShuckAnimationDispatcher { contract_address },
            IOwnableDispatcher { contract_address },
            IUpgradeableDispatcher { contract_address },
            owner,
            minter,
        )
    }

    #[test]
    fn test_constructor_mints_genesis_and_sets_config() {
        let (shuck, erc721, metadata, _, ownable, _, owner, minter) = deploy_contract();

        assert(metadata.name() == "Black Shuck", 'Wrong name');
        assert(metadata.symbol() == "SHUCK", 'Wrong symbol');
        assert(ownable.owner() == owner, 'Wrong owner');
        assert(shuck.get_minter_address() == minter, 'Wrong minter');
        assert(shuck.total_supply() == 1, 'Wrong initial supply');
        assert(erc721.owner_of(1) == owner, 'Wrong genesis owner');
        assert(erc721.balance_of(owner) == 1, 'Wrong owner balance');
        assert(shuck.is_minted(0, 0), 'Genesis not marked');

        let expected = BlackShuck {
            id: BEAST_ID,
            prefix: 0,
            suffix: 0,
            health: 100,
            level: 1,
            animated: false,
            shiny: false,
        };
        assert(shuck.get_black_shuck(1) == expected, 'Wrong genesis data');
    }

    #[test]
    fn test_owner_can_update_minter_address() {
        let (shuck, _, _, _, _, _, owner, _) = deploy_contract();
        let new_minter = test_address('new_minter');

        start_cheat_caller_address(shuck.contract_address, owner);
        shuck.set_minter_address(new_minter);
        stop_cheat_caller_address(shuck.contract_address);

        assert(shuck.get_minter_address() == new_minter, 'Minter not updated');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_non_owner_cannot_update_minter_address() {
        let (shuck, _, _, _, _, _, _, _) = deploy_contract();
        let random = test_address('random');
        let new_minter = test_address('new_minter');

        start_cheat_caller_address(shuck.contract_address, random);
        shuck.set_minter_address(new_minter);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Not authorized to mint',))]
    fn test_only_minter_can_mint() {
        let (shuck, _, _, _, _, _, _, _) = deploy_contract();
        let random = test_address('random');
        let recipient = test_address('recipient');

        start_cheat_caller_address(shuck.contract_address, random);
        shuck.mint(recipient, BEAST_ID, 1, 1, 200, 3, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    fn test_live_mints_use_sequential_token_ids() {
        let (shuck, erc721, _, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(shuck.contract_address, minter);
        let first = shuck.mint(recipient, BEAST_ID, 1, 2, 300, 4, false, true);
        let second = shuck.mint(recipient, BEAST_ID, 2, 3, 400, 5, true, false);
        stop_cheat_caller_address(shuck.contract_address);

        assert(first == 2, 'First live ID');
        assert(second == 3, 'Second live ID');
        assert(erc721.owner_of(first) == recipient, 'Wrong first owner');
        assert(erc721.owner_of(second) == recipient, 'Wrong second owner');
        assert(shuck.total_supply() == 3, 'Wrong supply');

        let expected = BlackShuck {
            id: BEAST_ID, prefix: 1, suffix: 2, health: 300, level: 4, animated: false, shiny: true,
        };
        assert(shuck.get_black_shuck(first) == expected, 'Wrong live data');
    }

    #[test]
    #[should_panic(expected: ('Invalid prefix',))]
    fn test_mint_rejects_zero_prefix() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(minter, BEAST_ID, 0, 1, 100, 1, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast ID',))]
    fn test_mint_rejects_non_black_shuck_beast_id() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(minter, 76, 1, 1, 100, 1, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid suffix',))]
    fn test_mint_rejects_zero_suffix() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(minter, BEAST_ID, 1, 0, 100, 1, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid prefix',))]
    fn test_mint_rejects_prefix_above_max() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(minter, BEAST_ID, 70, 1, 100, 1, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid suffix',))]
    fn test_mint_rejects_suffix_above_max() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(minter, BEAST_ID, 1, 19, 100, 1, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    /// Power is (6 - tier) * level as a u16, so level 13107 is the largest that still renders
    /// (5 * 13107 = 65535). One above it used to mint happily and then leave token_uri and
    /// animation_url reverting forever, with no way back short of an upgrade.
    #[test]
    fn test_mint_accepts_highest_renderable_level() {
        let (shuck, _, metadata, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(shuck.contract_address, minter);
        let token = shuck.mint(recipient, BEAST_ID, 1, 1, 500, 13107, false, false);
        stop_cheat_caller_address(shuck.contract_address);

        // The card must actually render at the boundary, not merely mint. Power lives only
        // inside the base64-encoded SVG, so rebuild the expected card and match on that.
        let expected_svg = BeastCardTrait::generate_svg(
            beast_definitions::get_prefix(1),
            beast_definitions::get_suffix(1),
            'Black Shuck',
            0,
            BeastCardAttributes {
                tier: 1,
                level: 13107,
                beast_type: 'Hunter',
                power: 65535,
                health: 500,
                shiny: false,
            },
            black_shuck_assets::regular_static_uri(),
        );
        let expected_image = format!(
            "data:image/svg+xml;base64,{}", bytes_base64_encode(expected_svg),
        );
        let uri = metadata.token_uri(token);
        assert(find_substring(@uri, @expected_image).is_some(), 'Boundary card mismatch');
    }

    #[test]
    #[should_panic(expected: ('Invalid level',))]
    fn test_mint_rejects_level_that_would_overflow_power() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(test_address('recipient'), BEAST_ID, 1, 1, 500, 13108, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Invalid level',))]
    fn test_mint_rejects_max_u16_level() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(test_address('recipient'), BEAST_ID, 1, 1, 500, 65535, false, false);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Black Shuck already minted',))]
    fn test_duplicate_prefix_suffix_rejected_even_with_different_traits() {
        let (shuck, _, _, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(shuck.contract_address, minter);
        shuck.mint(recipient, BEAST_ID, 7, 8, 100, 1, false, false);
        shuck.mint(recipient, BEAST_ID, 7, 8, 999, 9, true, true);
        stop_cheat_caller_address(shuck.contract_address);
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
        assert(find_substring(@token_uri, @"Black Shuck").is_some(), 'Missing name');
        assert(find_substring(@token_uri, @"Genesis").is_some(), 'Missing genesis trait');
        assert(
            find_substring(@token_uri, @"data:image/svg+xml;base64,").is_some(), 'Missing card svg',
        );
        assert(find_substring(@token_uri, @"data:image/png;base64,").is_some(), 'Missing png uri');
        assert(
            find_substring(@token_uri, @black_shuck_assets::regular_static_uri()).is_some(),
            'Wrong animation',
        );
    }

    #[test]
    fn test_live_token_uri_uses_names_traits_and_all_asset_variants() {
        let (shuck, _, metadata, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(shuck.contract_address, minter);
        let regular_static = shuck.mint(recipient, BEAST_ID, 1, 1, 111, 2, false, false);
        let shiny_static = shuck.mint(recipient, BEAST_ID, 2, 2, 222, 3, false, true);
        let regular_animated = shuck.mint(recipient, BEAST_ID, 3, 3, 333, 4, true, false);
        let shiny_animated = shuck.mint(recipient, BEAST_ID, 4, 4, 444, 5, true, true);
        stop_cheat_caller_address(shuck.contract_address);

        let uri = metadata.token_uri(regular_static);
        assert(find_substring(@uri, @"Agony Bane").is_some(), 'Missing live name');
        assert(find_substring(@uri, @"Agony").is_some(), 'Missing prefix');
        assert(find_substring(@uri, @"Bane").is_some(), 'Missing suffix');
        assert(find_substring(@uri, @"111").is_some(), 'Missing health');
        assert(find_substring(@uri, @"2").is_some(), 'Missing level');
        assert(find_substring(@uri, @"data:image/svg+xml;base64,").is_some(), 'Missing card svg');
        assert(find_substring(@uri, @"data:image/png;base64,").is_some(), 'Missing png uri');
        assert(
            find_substring(@uri, @black_shuck_assets::regular_static_uri()).is_some(),
            'Regular static animation',
        );

        let uri = metadata.token_uri(shiny_static);
        assert(
            find_substring(@uri, @black_shuck_assets::shiny_static_uri()).is_some(), 'Shiny static',
        );

        let uri = metadata.token_uri(regular_animated);
        assert(find_substring(@uri, @"data:image/gif;base64,").is_some(), 'Missing gif uri');
        assert(
            find_substring(@uri, @black_shuck_assets::regular_animated_uri()).is_some(),
            'Regular animated',
        );

        let uri = metadata.token_uri(shiny_animated);
        assert(
            find_substring(@uri, @black_shuck_assets::shiny_animated_uri()).is_some(),
            'Shiny animated',
        );
        assert(find_substring(@uri, @"true").is_some(), 'Missing bool trait');
    }

    /// End-to-end check that tier 1, type Hunter and power (6 - tier) * level = 10 all reach the
    /// rendered card. Power is not a JSON attribute and the SVG is base64-encoded into `image`,
    /// so it is unobservable by substring alone: rebuild the expected card and match on that.
    #[test]
    fn test_card_render_carries_tier_type_and_derived_power() {
        let (shuck, _, metadata, _, _, _, _, minter) = deploy_contract();
        let recipient = test_address('recipient');

        start_cheat_caller_address(shuck.contract_address, minter);
        let token = shuck.mint(recipient, BEAST_ID, 5, 5, 150, 2, false, false);
        stop_cheat_caller_address(shuck.contract_address);

        let expected_svg = BeastCardTrait::generate_svg(
            beast_definitions::get_prefix(5),
            beast_definitions::get_suffix(5),
            'Black Shuck',
            0,
            BeastCardAttributes {
                tier: 1, level: 2, beast_type: 'Hunter', power: 10, health: 150, shiny: false,
            },
            black_shuck_assets::regular_static_uri(),
        );
        let expected_image = format!(
            "data:image/svg+xml;base64,{}", bytes_base64_encode(expected_svg),
        );

        let uri = metadata.token_uri(token);
        assert(find_substring(@uri, @expected_image).is_some(), 'Card render mismatch');
    }

    /// Marketplaces route secondary-sale royalties through ERC2981, so the interface must be
    /// advertised through SRC5 and `royalty_info` must pay the configured receiver.
    #[test]
    fn test_royalty_info_and_interface_support() {
        let (shuck, _, _, _, _, _, _, _) = deploy_contract();
        let contract_address = shuck.contract_address;

        let src5 = ISRC5Dispatcher { contract_address };
        assert(src5.supports_interface(IERC2981_ID), 'ERC2981 not advertised');
        assert(src5.supports_interface(IERC721_ID), 'ERC721 not advertised');

        let erc2981 = IERC2981Dispatcher { contract_address };
        let (receiver, amount) = erc2981.royalty_info(1, 10_000);
        assert(receiver == test_address('royalty'), 'Wrong royalty receiver');
        assert(amount == 500, 'Wrong royalty amount');

        // Denominator is 10,000, so the fraction scales linearly with sale price.
        let (_, half) = erc2981.royalty_info(1, 5_000);
        assert(half == 250, 'Royalty should scale');
    }

    /// ERC2981 adds four externals that can redirect royalty payments. They must be owner-only.
    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_non_owner_cannot_change_default_royalty() {
        let (shuck, _, _, _, _, _, _, _) = deploy_contract();
        let admin = IERC2981AdminDispatcher { contract_address: shuck.contract_address };

        start_cheat_caller_address(shuck.contract_address, test_address('random'));
        admin.set_default_royalty(test_address('attacker'), 10_000);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    fn test_owner_can_change_default_royalty() {
        let (shuck, _, _, _, _, _, owner, _) = deploy_contract();
        let contract_address = shuck.contract_address;
        let admin = IERC2981AdminDispatcher { contract_address };

        start_cheat_caller_address(contract_address, owner);
        admin.set_default_royalty(test_address('new_receiver'), 250);
        stop_cheat_caller_address(contract_address);

        let (receiver, amount) = IERC2981Dispatcher { contract_address }.royalty_info(1, 10_000);
        assert(receiver == test_address('new_receiver'), 'Receiver not updated');
        assert(amount == 250, 'Fraction not updated');
    }

    /// The four art variants must stay distinct, otherwise `selected_asset_uri` is untestable
    /// and a half-finished art swap would go unnoticed.
    #[test]
    fn test_asset_variants_are_distinct() {
        let regular_static = black_shuck_assets::regular_static_uri();
        let shiny_static = black_shuck_assets::shiny_static_uri();
        let regular_animated = black_shuck_assets::regular_animated_uri();
        let shiny_animated = black_shuck_assets::shiny_animated_uri();

        assert(regular_static != shiny_static, 'Static variants collide');
        assert(regular_animated != shiny_animated, 'Animated variants collide');
        assert(regular_static != regular_animated, 'Regular variants collide');
        assert(shiny_static != shiny_animated, 'Shiny variants collide');
    }

    #[test]
    #[should_panic(expected: ('Caller is not the owner',))]
    fn test_upgrade_not_owner() {
        let (shuck, _, _, _, _, upgradeable, _, _) = deploy_contract();
        let random = test_address('random');
        let zero_class_hash: ClassHash = 0.try_into().unwrap();

        start_cheat_caller_address(shuck.contract_address, random);
        upgradeable.upgrade(zero_class_hash);
        stop_cheat_caller_address(shuck.contract_address);
    }

    #[test]
    #[should_panic(expected: ('Class hash cannot be zero',))]
    fn test_upgrade_owner_reaches_upgradeable_validation() {
        let (shuck, _, _, _, _, upgradeable, owner, _) = deploy_contract();
        let zero_class_hash: ClassHash = 0.try_into().unwrap();

        start_cheat_caller_address(shuck.contract_address, owner);
        upgradeable.upgrade(zero_class_hash);
        stop_cheat_caller_address(shuck.contract_address);
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
