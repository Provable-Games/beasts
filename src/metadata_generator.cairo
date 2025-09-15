use super::beast_manager::BeastManagerTrait;
use super::beast_svg::BeastSvgTrait;
use super::encoding::bytes_base64_encode;
use super::pack::PackableBeast;
use super::utils::felt252_to_byte_array;
use super::interfaces::IBeastImageDataProviderDispatcher;

/// Generates metadata for beasts
#[derive(Drop)]
pub struct MetadataGenerator {}

/// Metadata components for building JSON
#[derive(Drop)]
pub struct MetadataComponents {
    pub name: ByteArray,
    pub description: ByteArray,
    pub image: ByteArray,
    pub attributes: Array<Attribute>,
}

/// Single attribute for metadata
#[derive(Drop)]
pub struct Attribute {
    pub trait_type: ByteArray,
    pub value: ByteArray,
}

#[generate_trait]
pub impl MetadataGeneratorImpl of MetadataGeneratorTrait {
    /// Generates complete metadata JSON for a beast
    fn generate_metadata(
        token_id: u256,
        beast: PackableBeast,
        rank: u16,
        image_data_provider: IBeastImageDataProviderDispatcher,
        adventurers_killed: u64,
        last_killed_by_adventurer: u64,
        last_killed_timestamp: u64,
    ) -> ByteArray {
        let components = Self::build_metadata_components(
            token_id,
            beast,
            rank,
            image_data_provider,
            adventurers_killed,
            last_killed_by_adventurer,
            last_killed_timestamp,
        );
        let json = Self::components_to_json(components);

        format!("data:application/json;base64,{}", bytes_base64_encode(json))
    }

    /// Builds metadata components from beast data
    fn build_metadata_components(
        token_id: u256,
        beast: PackableBeast,
        rank: u16,
        image_data_provider: IBeastImageDataProviderDispatcher,
        adventurers_killed: u64,
        last_killed_by_adventurer: u64,
        last_killed_timestamp: u64,
    ) -> MetadataComponents {
        // Description
        let description =
            "The Beasts are a collection of digital native creatures, born onchain and built for battle.
            
            With 1,243 variants across 75 species, the fixed supply of 93,225 Beasts strikes a balance between abundance and scarcity: ample supply for onchain fun, paired with distinctive visual and non-visual traits that give collectors endless reasons to obsess over this rich collection.

            Beasts carry two sets of traits: visual and combat. Visual traits make collecting exciting, with Shiny and Animated forms that activate unique, pixel-perfect effects. Each Beast also features live traits, such as a built-in ranking system that places every Beast between 1 and 1,243 based on its power relative to others of its species. Rankings update automatically with each newly minted Beast until all 1,243 of that species are collected, at which point a King Beast is crowned.

            When collected, a Beast is minted with its level and health. Combined with its type and tier, these traits define a combat profile that allows Beasts to canonically battle onchain using the same combat system that first brought them into the world - Loot Survivor. Beasts also evolve through live traits such as the number of Adventurers they have slain, the last Adventurer who defeated them, and the timestamp of that defeat. These provide long-term, credibly neutral building blocks for future systems of growth and leveling, intentionally omitted from the base layer to support and promote emergence.

            Beasts are not purchased, they are earned by worthy Adventurers in the dungeons of Loot Survivor, a fully onchain game powered by verifiable randomness. The story of every Beast begins not at its mint, but with the Adventurer who braved the dungeon. It is the combination of decisions and chance that ultimately leads to the creation of each Beast. Every step of that journey is etched onto an incorruptible, indestructible ledger, ensuring those stories remain accessible as long as the network exists.

            For collectors, Beasts offer a generative art collection with verifiable scarcity, issuance, and provenance. 
            For players, Beasts deliver endless and timeless opportunities for onchain fun.

            Beast artwork courtesy of the legends at 1337 Skulls (:5ku11u73:)";
        // Get beast names
        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);

        // Build name
        let mut name: ByteArray = "";

        // non-genesis Beast
        if beast.prefix > 0 {
            let prefix_name_str = felt252_to_byte_array(prefix_name);
            let suffix_name_str = felt252_to_byte_array(suffix_name);
            let beast_name_str = felt252_to_byte_array(beast_name);
            name.append(@format!("\"{} {}\" {}", prefix_name_str, suffix_name_str, beast_name_str));
        } else {
            // no double quotes before genesis name
            let beast_name_str = felt252_to_byte_array(beast_name);
            name.append(@format!("{}", beast_name_str));
        }

        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        );
        let image = format!("data:image/svg+xml;base64,{}", bytes_base64_encode(svg));

        // Build attributes
        let mut attributes = array![];

        // Token ID attribute
        let mut token_id_value: ByteArray = "";
        token_id_value.append(@format!("{}", token_id));
        attributes.append(Attribute { trait_type: "Token ID", value: token_id_value });

        // Beast ID attribute
        let mut id_value: ByteArray = "";
        id_value.append(@format!("{}", beast.id));
        attributes.append(Attribute { trait_type: "Beast ID", value: id_value });

        // Beast name attribute
        attributes
            .append(Attribute { trait_type: "Beast", value: felt252_to_byte_array(beast_name) });

        // Type attribute
        attributes
            .append(
                Attribute {
                    trait_type: "Type", value: felt252_to_byte_array(beast_attrs.beast_type),
                },
            );

        // Tier attribute
        let mut tier_value: ByteArray = "";
        tier_value.append(@format!("{}", beast_attrs.tier));
        attributes.append(Attribute { trait_type: "Tier", value: tier_value });

        // Prefix attribute (if exists)
        if beast.prefix > 0 {
            attributes
                .append(
                    Attribute { trait_type: "Prefix", value: felt252_to_byte_array(prefix_name) },
                );
        }

        // Suffix attribute (if exists)
        if beast.suffix > 0 {
            attributes
                .append(
                    Attribute { trait_type: "Suffix", value: felt252_to_byte_array(suffix_name) },
                );
        }

        // Level attribute
        let mut level_value: ByteArray = "";
        level_value.append(@format!("{}", beast_attrs.level));
        attributes.append(Attribute { trait_type: "Level", value: level_value });

        // Health attribute
        let mut health_value: ByteArray = "";
        health_value.append(@format!("{}", beast_attrs.health));
        attributes.append(Attribute { trait_type: "Health", value: health_value });

        // Power attribute
        let mut power_value: ByteArray = "";
        power_value.append(@format!("{}", beast_attrs.level * (6 - beast_attrs.tier.into())));
        attributes.append(Attribute { trait_type: "Power", value: power_value });

        // Rank attribute
        let mut rank_value: ByteArray = "";
        rank_value.append(@format!("{}", rank));
        attributes.append(Attribute { trait_type: "Rank", value: rank_value });

        // Adventurers killed attribute
        let mut adventurers_killed_value: ByteArray = "";
        adventurers_killed_value.append(@format!("{}", adventurers_killed));
        attributes
            .append(
                Attribute { trait_type: "Adventurers Killed", value: adventurers_killed_value },
            );

        // Last killed by adventurer attribute
        let mut last_killed_by_adventurer_value: ByteArray = "";
        last_killed_by_adventurer_value.append(@format!("{}", last_killed_by_adventurer));
        attributes
            .append(
                Attribute { trait_type: "Last Killed By", value: last_killed_by_adventurer_value },
            );

        // Last killed timestamp attribute
        let mut last_killed_timestamp_value: ByteArray = "";
        last_killed_timestamp_value.append(@format!("{}", last_killed_timestamp));
        attributes
            .append(
                Attribute {
                    trait_type: "Last Death Timestamp", value: last_killed_timestamp_value,
                },
            );

        // Shiny attribute
        let mut shiny_value: ByteArray = "";
        shiny_value.append(@format!("{}", beast_attrs.shiny));
        attributes.append(Attribute { trait_type: "Shiny", value: shiny_value });

        // Animated attribute
        let mut animated_value: ByteArray = "";
        animated_value.append(@format!("{}", beast_attrs.animated));
        attributes.append(Attribute { trait_type: "Animated", value: animated_value });

        // Genesis attribute
        let mut genesis_value: ByteArray = "";
        genesis_value.append(@format!("{}", if token_id <= 75 {
            1
        } else {
            0
        }));
        attributes.append(Attribute { trait_type: "Genesis", value: genesis_value });

        MetadataComponents { name, description, image, attributes }
    }

    /// Converts metadata components to JSON string
    fn components_to_json(components: MetadataComponents) -> ByteArray {
        let mut json: ByteArray = "";

        // Start JSON object
        json.append(@"{");

        // Name
        json.append(@"\"name\":\"");
        json.append(@components.name);
        json.append(@"\",");

        // Description
        json.append(@"\"description\":\"");
        json.append(@components.description);
        json.append(@"\",");

        // Image
        json.append(@"\"image\":\"");
        json.append(@components.image);
        json.append(@"\",");

        // Attributes array
        json.append(@"\"attributes\":[");

        let mut i = 0;
        let attributes_len = components.attributes.len();
        loop {
            if i >= attributes_len {
                break;
            }

            let attr = components.attributes.at(i);
            json.append(@"{\"trait_type\":\"");
            json.append(@attr.trait_type.clone());
            json.append(@"\",\"value\":\"");
            json.append(@attr.value.clone());
            json.append(@"\"}");

            if i < attributes_len - 1 {
                json.append(@",");
            }

            i += 1;
        };

        json.append(@"]");

        // Close JSON object
        json.append(@"}");

        json
    }
}

#[cfg(test)]
mod tests {
    use super::{Attribute, MetadataGeneratorTrait, PackableBeast, BeastSvgTrait};
    use super::super::interfaces::{
        IBeastImageDataProviderDispatcher, IBeastImageDataProviderDispatcherTrait,
    };
    use super::super::beast_manager::BeastManagerTrait;
    use beasts_nft::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};
    use openzeppelin_token::erc721::interface::{
        IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait,
    };
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_mock_call,
        start_cheat_caller_address, stop_cheat_caller_address,
    };
    use starknet::{ContractAddress, contract_address_const};

    fn find_substring(text: @ByteArray, pattern: @ByteArray) -> bool {
        let text_len = text.len();
        let pattern_len = pattern.len();

        if pattern_len > text_len {
            return false;
        }

        let mut i = 0;
        loop {
            if i > text_len - pattern_len {
                break false;
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
                break true;
            }

            i += 1;
        }
    }

    // Helper: deploy contract with provided terminal timestamp and mocked providers
    fn deploy_beasts_with_terminal(
        terminal_ts: u64, mock_provider_addr: ContractAddress,
    ) -> (IBeastsDispatcher, IERC721MetadataDispatcher, ContractAddress, ContractAddress) {
        let owner = contract_address_const::<'owner'>();
        let royalty_receiver: ContractAddress = contract_address_const::<'royalty_receiver'>();

        let contract = declare("beasts_nft").unwrap().contract_class();

        // Prepare constructor calldata
        let mut calldata: Array<felt252> = array![];

        // name: "Beasts"
        calldata.append(0); // no full 31-byte chunks
        calldata.append('Beasts'); // pending word
        calldata.append(6); // pending word length

        // symbol: "BEAST"
        calldata.append(0);
        calldata.append('BEAST');
        calldata.append(5);

        // owner
        calldata.append(owner.into());

        // royalty receiver + fraction
        calldata.append(royalty_receiver.into());
        // royalty_fraction (u128) encoded as felt252 in calldata
        calldata.append(500);

        // image providers (all mocked to the same address)
        calldata.append(mock_provider_addr.into()); // regular_png_provider
        calldata.append(mock_provider_addr.into()); // shiny_png_provider
        calldata.append(mock_provider_addr.into()); // regular_gif_provider
        calldata.append(mock_provider_addr.into()); // shiny_gif_provider

        // death_mountain_address
        calldata.append(0);

        // terminal timestamp
        calldata.append(terminal_ts.into());

        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        (
            IBeastsDispatcher { contract_address },
            IERC721MetadataDispatcher { contract_address },
            owner,
            contract_address,
        )
    }

    #[test]
    #[ignore]
    fn token_uri_allowed_when_not_terminal() {
        // Mock provider to avoid external calls
        let mock_provider: ContractAddress = 'mock_provider'.try_into().unwrap();
        let mock_img: ByteArray =
            "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAEElEQVR4nGP4z8DAwMAAAgABAAJcQp0pAAAAAElFTkSuQmCC";
        start_mock_call(mock_provider, selector!("get_data_uri"), mock_img);

        // Deploy with terminal disabled (0)
        let (beasts, metadata, owner, _addr) = deploy_beasts_with_terminal(0_u64, mock_provider);

        // Set minter
        let minter = contract_address_const::<'minter'>();
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        // Mint one beast
        let recipient = contract_address_const::<'recipient'>();
        start_cheat_caller_address(beasts.contract_address, minter);
        let (token_id, _, _) = beasts.mint(recipient, 3, 1, 2, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        // Should not panic and should return non-empty URI
        let uri = metadata.token_uri(token_id);
        assert!(uri.len() != 0, "token_uri should return data when not terminal");
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    #[should_panic(expected: ('Terminal: token_uri disabled',))]
    fn token_uri_panics_after_terminal_time() {
        // Mock provider (won't be used because call should revert before)
        let mock_provider: ContractAddress = 'mock_provider'.try_into().unwrap();
        let mock_img: ByteArray = "data:image/png;base64,AA==";
        start_mock_call(mock_provider, selector!("get_data_uri"), mock_img);

        // Deploy with terminal set in the past (1)
        let (beasts, metadata, owner, _addr) = deploy_beasts_with_terminal(1_u64, mock_provider);

        // Set minter
        let minter = contract_address_const::<'minter'>();
        start_cheat_caller_address(beasts.contract_address, owner);
        beasts.set_dungeon_address(minter);
        stop_cheat_caller_address(beasts.contract_address);

        // Mint a beast so token exists
        let recipient = contract_address_const::<'recipient'>();
        start_cheat_caller_address(beasts.contract_address, minter);
        let (token_id, _, _) = beasts.mint(recipient, 3, 1, 2, 10, 100, 0, 0);
        stop_cheat_caller_address(beasts.contract_address);

        // Expect panic due to terminal
        let _ = metadata.token_uri(token_id);
    }

    #[test]
    fn test_build_metadata_components() {
        let beast = PackableBeast {
            id: 2, prefix: 5, suffix: 10, level: 25, health: 100, shiny: 0, animated: 0,
        };

        let adventurers_killed = 10;
        let last_killed_by_adventurer = 1002;
        let last_killed_timestamp = 1715558400;

        let mock_data_provider_address = 'data_provider'.try_into().unwrap();
        let mock_return_data: ByteArray =
            "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAASFJREFUSIm1VW2uxCAIVE/dI+yt3/vBBu0wfLVZstlQhAFGxTF+IH+frc+HYVc1aj1Al0+wgKeuVjugcGkfXhGJX1r+KT2K0oqkp6KzW1cjst5BXdrlQ6TV35ZDsYJ9BiEUaXAKUTlL01rn9dVVGfcjD7hwGyBkqVX9VKekx23ZkHVmO3PQYDqOaEO6OsHppMV+gsiq/ivUaVlevaM8MhURsoosMckvQN8tM7vNsR28isAyzOmie+CluWE9uKUSRW9P6T0ABnawuRy26sa4tuxXHtG8A0rxqcRSpYiia9ZXCbwNuKH4OUp78Gb6NyhyIUKK8g7s+QH0OH2VIjoqFD0aiCk0iXGqpo327kEXfaQUwQa4I/Nyh1iDIvumDsYhtPIPgYPBCOPyCoAAAAAASUVORK5CYII=";

        start_mock_call(mock_data_provider_address, selector!("get_data_uri"), mock_return_data);

        let beast_image_data_provider_dispatcher = IBeastImageDataProviderDispatcher {
            contract_address: mock_data_provider_address,
        };
        let components = MetadataGeneratorTrait::build_metadata_components(
            123,
            beast,
            1,
            beast_image_data_provider_dispatcher,
            adventurers_killed,
            last_killed_by_adventurer,
            last_killed_timestamp,
        );

        assert(components.name == "\"Behemoth Shadow\" Typhon", 'Name mismatch');
        assert(components.attributes.len() == 17, 'Should have 17 attributes');
        assert!(
            components.attributes.at(0).trait_type == @"Token ID", "Should have Token ID trait",
        );
        assert!(
            components.attributes.at(1).trait_type == @"Beast ID", "Should have Beast ID trait",
        );
        assert!(components.attributes.at(2).trait_type == @"Beast", "Should have Beast trait");
        assert!(components.attributes.at(3).trait_type == @"Type", "Should have Type trait");
        assert!(components.attributes.at(4).trait_type == @"Tier", "Should have Tier trait");
        assert!(components.attributes.at(5).trait_type == @"Prefix", "Should have Prefix trait");
        assert!(components.attributes.at(6).trait_type == @"Suffix", "Should have Suffix trait");
        assert!(components.attributes.at(7).trait_type == @"Level", "Should have Level trait");
        assert!(components.attributes.at(8).trait_type == @"Health", "Should have Health trait");
        assert!(components.attributes.at(9).trait_type == @"Power", "Should have Power trait");
        assert!(components.attributes.at(10).trait_type == @"Rank", "Should have Rank trait");
        assert!(
            components.attributes.at(11).trait_type == @"Adventurers Killed",
            "Should have Adventurers Killed trait",
        );
        assert!(
            components.attributes.at(12).trait_type == @"Last Killed By",
            "Should have Last Killed By Adventurer trait",
        );
        assert!(
            components.attributes.at(13).trait_type == @"Last Death Timestamp",
            "Should have Last Killed Timestamp trait",
        );
        assert!(components.attributes.at(14).trait_type == @"Shiny", "Should have Shiny trait");
        assert!(
            components.attributes.at(15).trait_type == @"Animated", "Should have Animated trait",
        );
        assert!(components.attributes.at(16).trait_type == @"Genesis", "Should have Genesis trait");
    }

    #[test]
    fn test_components_to_json_formatting() {
        let mut attributes = array![];
        attributes.append(Attribute { trait_type: "Test", value: "Value" });
        attributes.append(Attribute { trait_type: "Another", value: "Thing" });

        let components = super::MetadataComponents {
            name: "Test Beast", description: "A test beast", image: "data:test", attributes,
        };

        let json = MetadataGeneratorTrait::components_to_json(components);

        // Check proper JSON formatting
        assert(find_substring(@json, @"{\"name\":\"Test Beast\""), 'Should start with name');
        assert(find_substring(@json, @"\"attributes\":[{"), 'Should have attributes array');
        assert(find_substring(@json, @"},{"), 'Should have comma between attrs');
        assert(find_substring(@json, @"}]}"), 'Should end properly');
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn fork_png_provider_returns_data_uri() {
        // pick an arbitrary valid beast id
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_regular_png_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "PNG provider must return data URI");
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn fork_gif_provider_returns_data_uri() {
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_regular_gif_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "GIF provider must return data URI");
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn fork_shiny_png_provider_returns_data_uri() {
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_shiny_png_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "Shiny PNG provider must return data URI");
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn fork_shiny_gif_provider_returns_data_uri() {
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_shiny_gif_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "Shiny GIF provider must return data URI");
    }

    // Helper to render and print SVG for a given beast and variant
    fn render_svg_for(beast_id: u8, shiny: u8, animated: u8) -> ByteArray {
        let beast: PackableBeast = PackableBeast {
            id: beast_id, prefix: 1, suffix: 1, level: 25, health: 100, shiny, animated,
        };

        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);
        let rank = 1;

        let provider_addr = if shiny == 1 {
            if animated == 1 {
                get_shiny_gif_provider()
            } else {
                get_shiny_png_provider()
            }
        } else {
            if animated == 1 {
                get_regular_gif_provider()
            } else {
                get_regular_png_provider()
            }
        };
        let image_data_provider = IBeastImageDataProviderDispatcher {
            contract_address: provider_addr,
        };

        BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        )
    }

    fn print_svg_for(beast_id: u8, shiny: u8, animated: u8) {
        let svg = render_svg_for(beast_id, shiny, animated);
        println!("{}", svg);
    }

    // Generate SVG locally for all four variants of each of the 75 beasts (300 tests total)
    // using mainnet data providers
    // 1: Warlock
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_warlock_shiny_animated() {
        print_svg_for(1, 1, 1);
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_warlock_regular_animated() {
        print_svg_for(1, 0, 1);
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_warlock_shiny_static() {
        print_svg_for(1, 1, 0);
    }

    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_warlock_regular_static() {
        print_svg_for(1, 0, 0);
    }

    // 2: Typhon
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_typhon_shiny_animated() {
        print_svg_for(2, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_typhon_regular_animated() {
        print_svg_for(2, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_typhon_shiny_static() {
        print_svg_for(2, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_typhon_regular_static() {
        print_svg_for(2, 0, 0);
    }

    // 3: Jiangshi
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jiangshi_shiny_animated() {
        print_svg_for(3, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jiangshi_regular_animated() {
        print_svg_for(3, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jiangshi_shiny_static() {
        print_svg_for(3, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jiangshi_regular_static() {
        print_svg_for(3, 0, 0);
    }

    // 4: Anansi
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_anansi_shiny_animated() {
        print_svg_for(4, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_anansi_regular_animated() {
        print_svg_for(4, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_anansi_shiny_static() {
        print_svg_for(4, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_anansi_regular_static() {
        print_svg_for(4, 0, 0);
    }

    // 5: Basilisk
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_basilisk_shiny_animated() {
        print_svg_for(5, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_basilisk_regular_animated() {
        print_svg_for(5, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_basilisk_shiny_static() {
        print_svg_for(5, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_basilisk_regular_static() {
        print_svg_for(5, 0, 0);
    }

    // 6: Gorgon
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gorgon_shiny_animated() {
        print_svg_for(6, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gorgon_regular_animated() {
        print_svg_for(6, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gorgon_shiny_static() {
        print_svg_for(6, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gorgon_regular_static() {
        print_svg_for(6, 0, 0);
    }

    // 7: Kitsune
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kitsune_shiny_animated() {
        print_svg_for(7, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kitsune_regular_animated() {
        print_svg_for(7, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kitsune_shiny_static() {
        print_svg_for(7, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kitsune_regular_static() {
        print_svg_for(7, 0, 0);
    }

    // 8: Lich
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_lich_shiny_animated() {
        print_svg_for(8, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_lich_regular_animated() {
        print_svg_for(8, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_lich_shiny_static() {
        print_svg_for(8, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_lich_regular_static() {
        print_svg_for(8, 0, 0);
    }

    // 9: Chimera
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chimera_shiny_animated() {
        print_svg_for(9, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chimera_regular_animated() {
        print_svg_for(9, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chimera_shiny_static() {
        print_svg_for(9, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chimera_regular_static() {
        print_svg_for(9, 0, 0);
    }

    // 10: Wendigo
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wendigo_shiny_animated() {
        print_svg_for(10, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wendigo_regular_animated() {
        print_svg_for(10, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wendigo_shiny_static() {
        print_svg_for(10, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wendigo_regular_static() {
        print_svg_for(10, 0, 0);
    }

    // 11: Rakshasa
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rakshasa_shiny_animated() {
        print_svg_for(11, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rakshasa_regular_animated() {
        print_svg_for(11, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rakshasa_shiny_static() {
        print_svg_for(11, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rakshasa_regular_static() {
        print_svg_for(11, 0, 0);
    }

    // 12: Werewolf
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_werewolf_shiny_animated() {
        print_svg_for(12, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_werewolf_regular_animated() {
        print_svg_for(12, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_werewolf_shiny_static() {
        print_svg_for(12, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_werewolf_regular_static() {
        print_svg_for(12, 0, 0);
    }

    // 13: Banshee
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_banshee_shiny_animated() {
        print_svg_for(13, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_banshee_regular_animated() {
        print_svg_for(13, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_banshee_shiny_static() {
        print_svg_for(13, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_banshee_regular_static() {
        print_svg_for(13, 0, 0);
    }

    // 14: Draugr
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_draugr_shiny_animated() {
        print_svg_for(14, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_draugr_regular_animated() {
        print_svg_for(14, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_draugr_shiny_static() {
        print_svg_for(14, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_draugr_regular_static() {
        print_svg_for(14, 0, 0);
    }

    // 15: Vampire
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_vampire_shiny_animated() {
        print_svg_for(15, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_vampire_regular_animated() {
        print_svg_for(15, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_vampire_shiny_static() {
        print_svg_for(15, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_vampire_regular_static() {
        print_svg_for(15, 0, 0);
    }

    // 16: Goblin
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_goblin_shiny_animated() {
        print_svg_for(16, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_goblin_regular_animated() {
        print_svg_for(16, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_goblin_shiny_static() {
        print_svg_for(16, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_goblin_regular_static() {
        print_svg_for(16, 0, 0);
    }

    // 17: Ghoul
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ghoul_shiny_animated() {
        print_svg_for(17, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ghoul_regular_animated() {
        print_svg_for(17, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ghoul_shiny_static() {
        print_svg_for(17, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ghoul_regular_static() {
        print_svg_for(17, 0, 0);
    }

    // 18: Wraith
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wraith_shiny_animated() {
        print_svg_for(18, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wraith_regular_animated() {
        print_svg_for(18, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wraith_shiny_static() {
        print_svg_for(18, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wraith_regular_static() {
        print_svg_for(18, 0, 0);
    }

    // 19: Sprite
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_sprite_shiny_animated() {
        print_svg_for(19, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_sprite_regular_animated() {
        print_svg_for(19, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_sprite_shiny_static() {
        print_svg_for(19, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_sprite_regular_static() {
        print_svg_for(19, 0, 0);
    }

    // 20: Kappa
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kappa_shiny_animated() {
        print_svg_for(20, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kappa_regular_animated() {
        print_svg_for(20, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kappa_shiny_static() {
        print_svg_for(20, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kappa_regular_static() {
        print_svg_for(20, 0, 0);
    }

    // 21: Fairy
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fairy_shiny_animated() {
        print_svg_for(21, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fairy_regular_animated() {
        print_svg_for(21, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fairy_shiny_static() {
        print_svg_for(21, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fairy_regular_static() {
        print_svg_for(21, 0, 0);
    }

    // 22: Leprechaun
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leprechaun_shiny_animated() {
        print_svg_for(22, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leprechaun_regular_animated() {
        print_svg_for(22, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leprechaun_shiny_static() {
        print_svg_for(22, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leprechaun_regular_static() {
        print_svg_for(22, 0, 0);
    }

    // 23: Kelpie
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kelpie_shiny_animated() {
        print_svg_for(23, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kelpie_regular_animated() {
        print_svg_for(23, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kelpie_shiny_static() {
        print_svg_for(23, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kelpie_regular_static() {
        print_svg_for(23, 0, 0);
    }

    // 24: Pixie
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pixie_shiny_animated() {
        print_svg_for(24, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pixie_regular_animated() {
        print_svg_for(24, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pixie_shiny_static() {
        print_svg_for(24, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pixie_regular_static() {
        print_svg_for(24, 0, 0);
    }

    // 25: Gnome
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gnome_shiny_animated() {
        print_svg_for(25, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gnome_regular_animated() {
        print_svg_for(25, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gnome_shiny_static() {
        print_svg_for(25, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_gnome_regular_static() {
        print_svg_for(25, 0, 0);
    }

    // 26: Griffin
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_griffin_shiny_animated() {
        print_svg_for(26, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_griffin_regular_animated() {
        print_svg_for(26, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_griffin_shiny_static() {
        print_svg_for(26, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_griffin_regular_static() {
        print_svg_for(26, 0, 0);
    }

    // 27: Manticore
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_manticore_shiny_animated() {
        print_svg_for(27, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_manticore_regular_animated() {
        print_svg_for(27, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_manticore_shiny_static() {
        print_svg_for(27, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_manticore_regular_static() {
        print_svg_for(27, 0, 0);
    }

    // 28: Phoenix
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_phoenix_shiny_animated() {
        print_svg_for(28, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_phoenix_regular_animated() {
        print_svg_for(28, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_phoenix_shiny_static() {
        print_svg_for(28, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_phoenix_regular_static() {
        print_svg_for(28, 0, 0);
    }

    // 29: Dragon
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_dragon_shiny_animated() {
        print_svg_for(29, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_dragon_regular_animated() {
        print_svg_for(29, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_dragon_shiny_static() {
        print_svg_for(29, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_dragon_regular_static() {
        print_svg_for(29, 0, 0);
    }

    // 30: Minotaur
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_minotaur_shiny_animated() {
        print_svg_for(30, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_minotaur_regular_animated() {
        print_svg_for(30, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_minotaur_shiny_static() {
        print_svg_for(30, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_minotaur_regular_static() {
        print_svg_for(30, 0, 0);
    }

    // 31: Qilin
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_qilin_shiny_animated() {
        print_svg_for(31, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_qilin_regular_animated() {
        print_svg_for(31, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_qilin_shiny_static() {
        print_svg_for(31, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_qilin_regular_static() {
        print_svg_for(31, 0, 0);
    }

    // 32: Ammit
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ammit_shiny_animated() {
        print_svg_for(32, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ammit_regular_animated() {
        print_svg_for(32, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ammit_shiny_static() {
        print_svg_for(32, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ammit_regular_static() {
        print_svg_for(32, 0, 0);
    }

    // 33: Nue
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nue_shiny_animated() {
        print_svg_for(33, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nue_regular_animated() {
        print_svg_for(33, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nue_shiny_static() {
        print_svg_for(33, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nue_regular_static() {
        print_svg_for(33, 0, 0);
    }

    // 34: Skinwalker
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skinwalker_shiny_animated() {
        print_svg_for(34, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skinwalker_regular_animated() {
        print_svg_for(34, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skinwalker_shiny_static() {
        print_svg_for(34, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skinwalker_regular_static() {
        print_svg_for(34, 0, 0);
    }

    // 35: Chupacabra
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chupacabra_shiny_animated() {
        print_svg_for(35, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chupacabra_regular_animated() {
        print_svg_for(35, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chupacabra_shiny_static() {
        print_svg_for(35, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_chupacabra_regular_static() {
        print_svg_for(35, 0, 0);
    }

    // 36: Weretiger
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_weretiger_shiny_animated() {
        print_svg_for(36, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_weretiger_regular_animated() {
        print_svg_for(36, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_weretiger_shiny_static() {
        print_svg_for(36, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_weretiger_regular_static() {
        print_svg_for(36, 0, 0);
    }

    // 37: Wyvern
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wyvern_shiny_animated() {
        print_svg_for(37, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wyvern_regular_animated() {
        print_svg_for(37, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wyvern_shiny_static() {
        print_svg_for(37, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wyvern_regular_static() {
        print_svg_for(37, 0, 0);
    }

    // 38: Roc
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_roc_shiny_animated() {
        print_svg_for(38, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_roc_regular_animated() {
        print_svg_for(38, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_roc_shiny_static() {
        print_svg_for(38, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_roc_regular_static() {
        print_svg_for(38, 0, 0);
    }

    // 39: Harpy
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_harpy_shiny_animated() {
        print_svg_for(39, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_harpy_regular_animated() {
        print_svg_for(39, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_harpy_shiny_static() {
        print_svg_for(39, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_harpy_regular_static() {
        print_svg_for(39, 0, 0);
    }

    // 40: Pegasus
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pegasus_shiny_animated() {
        print_svg_for(40, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pegasus_regular_animated() {
        print_svg_for(40, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pegasus_shiny_static() {
        print_svg_for(40, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_pegasus_regular_static() {
        print_svg_for(40, 0, 0);
    }

    // 41: Hippogriff
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hippogriff_shiny_animated() {
        print_svg_for(41, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hippogriff_regular_animated() {
        print_svg_for(41, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hippogriff_shiny_static() {
        print_svg_for(41, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hippogriff_regular_static() {
        print_svg_for(41, 0, 0);
    }

    // 42: Fenrir
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fenrir_shiny_animated() {
        print_svg_for(42, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fenrir_regular_animated() {
        print_svg_for(42, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fenrir_shiny_static() {
        print_svg_for(42, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_fenrir_regular_static() {
        print_svg_for(42, 0, 0);
    }

    // 43: Jaguar
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jaguar_shiny_animated() {
        print_svg_for(43, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jaguar_regular_animated() {
        print_svg_for(43, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jaguar_shiny_static() {
        print_svg_for(43, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jaguar_regular_static() {
        print_svg_for(43, 0, 0);
    }

    // 44: Satori
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_satori_shiny_animated() {
        print_svg_for(44, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_satori_regular_animated() {
        print_svg_for(44, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_satori_shiny_static() {
        print_svg_for(44, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_satori_regular_static() {
        print_svg_for(44, 0, 0);
    }

    // 45: Direwolf
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_direwolf_shiny_animated() {
        print_svg_for(45, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_direwolf_regular_animated() {
        print_svg_for(45, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_direwolf_shiny_static() {
        print_svg_for(45, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_direwolf_regular_static() {
        print_svg_for(45, 0, 0);
    }

    // 46: Bear
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bear_shiny_animated() {
        print_svg_for(46, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bear_regular_animated() {
        print_svg_for(46, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bear_shiny_static() {
        print_svg_for(46, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bear_regular_static() {
        print_svg_for(46, 0, 0);
    }

    // 47: Wolf
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wolf_shiny_animated() {
        print_svg_for(47, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wolf_regular_animated() {
        print_svg_for(47, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wolf_shiny_static() {
        print_svg_for(47, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_wolf_regular_static() {
        print_svg_for(47, 0, 0);
    }

    // 48: Mantis
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_mantis_shiny_animated() {
        print_svg_for(48, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_mantis_regular_animated() {
        print_svg_for(48, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_mantis_shiny_static() {
        print_svg_for(48, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_mantis_regular_static() {
        print_svg_for(48, 0, 0);
    }

    // 49: Spider
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_spider_shiny_animated() {
        print_svg_for(49, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_spider_regular_animated() {
        print_svg_for(49, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_spider_shiny_static() {
        print_svg_for(49, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_spider_regular_static() {
        print_svg_for(49, 0, 0);
    }

    // 50: Rat
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rat_shiny_animated() {
        print_svg_for(50, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rat_regular_animated() {
        print_svg_for(50, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rat_shiny_static() {
        print_svg_for(50, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_rat_regular_static() {
        print_svg_for(50, 0, 0);
    }

    // 51: Kraken
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kraken_shiny_animated() {
        print_svg_for(51, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kraken_regular_animated() {
        print_svg_for(51, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kraken_shiny_static() {
        print_svg_for(51, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_kraken_regular_static() {
        print_svg_for(51, 0, 0);
    }

    // 52: Colossus
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_colossus_shiny_animated() {
        print_svg_for(52, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_colossus_regular_animated() {
        print_svg_for(52, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_colossus_shiny_static() {
        print_svg_for(52, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_colossus_regular_static() {
        print_svg_for(52, 0, 0);
    }

    // 53: Balrog
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_balrog_shiny_animated() {
        print_svg_for(53, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_balrog_regular_animated() {
        print_svg_for(53, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_balrog_shiny_static() {
        print_svg_for(53, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_balrog_regular_static() {
        print_svg_for(53, 0, 0);
    }

    // 54: Leviathan
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leviathan_shiny_animated() {
        print_svg_for(54, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leviathan_regular_animated() {
        print_svg_for(54, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leviathan_shiny_static() {
        print_svg_for(54, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_leviathan_regular_static() {
        print_svg_for(54, 0, 0);
    }

    // 55: Tarrasque
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_tarrasque_shiny_animated() {
        print_svg_for(55, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_tarrasque_regular_animated() {
        print_svg_for(55, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_tarrasque_shiny_static() {
        print_svg_for(55, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_tarrasque_regular_static() {
        print_svg_for(55, 0, 0);
    }

    // 56: Titan
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_titan_shiny_animated() {
        print_svg_for(56, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_titan_regular_animated() {
        print_svg_for(56, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_titan_shiny_static() {
        print_svg_for(56, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_titan_regular_static() {
        print_svg_for(56, 0, 0);
    }

    // 57: Nephilim
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nephilim_shiny_animated() {
        print_svg_for(57, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nephilim_regular_animated() {
        print_svg_for(57, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nephilim_shiny_static() {
        print_svg_for(57, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nephilim_regular_static() {
        print_svg_for(57, 0, 0);
    }

    // 58: Behemoth
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_behemoth_shiny_animated() {
        print_svg_for(58, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_behemoth_regular_animated() {
        print_svg_for(58, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_behemoth_shiny_static() {
        print_svg_for(58, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_behemoth_regular_static() {
        print_svg_for(58, 0, 0);
    }

    // 59: Hydra
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hydra_shiny_animated() {
        print_svg_for(59, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hydra_regular_animated() {
        print_svg_for(59, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hydra_shiny_static() {
        print_svg_for(59, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_hydra_regular_static() {
        print_svg_for(59, 0, 0);
    }

    // 60: Juggernaut
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_juggernaut_shiny_animated() {
        print_svg_for(60, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_juggernaut_regular_animated() {
        print_svg_for(60, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_juggernaut_shiny_static() {
        print_svg_for(60, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_juggernaut_regular_static() {
        print_svg_for(60, 0, 0);
    }

    // 61: Oni
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_oni_shiny_animated() {
        print_svg_for(61, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_oni_regular_animated() {
        print_svg_for(61, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_oni_shiny_static() {
        print_svg_for(61, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_oni_regular_static() {
        print_svg_for(61, 0, 0);
    }

    // 62: Jotunn
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jotunn_shiny_animated() {
        print_svg_for(62, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jotunn_regular_animated() {
        print_svg_for(62, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jotunn_shiny_static() {
        print_svg_for(62, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_jotunn_regular_static() {
        print_svg_for(62, 0, 0);
    }

    // 63: Ettin
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ettin_shiny_animated() {
        print_svg_for(63, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ettin_regular_animated() {
        print_svg_for(63, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ettin_shiny_static() {
        print_svg_for(63, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ettin_regular_static() {
        print_svg_for(63, 0, 0);
    }

    // 64: Cyclops
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_cyclops_shiny_animated() {
        print_svg_for(64, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_cyclops_regular_animated() {
        print_svg_for(64, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_cyclops_shiny_static() {
        print_svg_for(64, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_cyclops_regular_static() {
        print_svg_for(64, 0, 0);
    }

    // 65: Giant
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_giant_shiny_animated() {
        print_svg_for(65, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_giant_regular_animated() {
        print_svg_for(65, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_giant_shiny_static() {
        print_svg_for(65, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_giant_regular_static() {
        print_svg_for(65, 0, 0);
    }

    // 66: Nemean Lion
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nemean_lion_shiny_animated() {
        print_svg_for(66, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nemean_lion_regular_animated() {
        print_svg_for(66, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nemean_lion_shiny_static() {
        print_svg_for(66, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_nemean_lion_regular_static() {
        print_svg_for(66, 0, 0);
    }

    // 67: Berserker
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_berserker_shiny_animated() {
        print_svg_for(67, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_berserker_regular_animated() {
        print_svg_for(67, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_berserker_shiny_static() {
        print_svg_for(67, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_berserker_regular_static() {
        print_svg_for(67, 0, 0);
    }

    // 68: Yeti
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_yeti_shiny_animated() {
        print_svg_for(68, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_yeti_regular_animated() {
        print_svg_for(68, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_yeti_shiny_static() {
        print_svg_for(68, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_yeti_regular_static() {
        print_svg_for(68, 0, 0);
    }

    // 69: Golem
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_golem_shiny_animated() {
        print_svg_for(69, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_golem_regular_animated() {
        print_svg_for(69, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_golem_shiny_static() {
        print_svg_for(69, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_golem_regular_static() {
        print_svg_for(69, 0, 0);
    }

    // 70: Ent
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ent_shiny_animated() {
        print_svg_for(70, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ent_regular_animated() {
        print_svg_for(70, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ent_shiny_static() {
        print_svg_for(70, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ent_regular_static() {
        print_svg_for(70, 0, 0);
    }

    // 71: Troll
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_troll_shiny_animated() {
        print_svg_for(71, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_troll_regular_animated() {
        print_svg_for(71, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_troll_shiny_static() {
        print_svg_for(71, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_troll_regular_static() {
        print_svg_for(71, 0, 0);
    }

    // 72: Bigfoot
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bigfoot_shiny_animated() {
        print_svg_for(72, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bigfoot_regular_animated() {
        print_svg_for(72, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bigfoot_shiny_static() {
        print_svg_for(72, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_bigfoot_regular_static() {
        print_svg_for(72, 0, 0);
    }

    // 73: Ogre
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ogre_shiny_animated() {
        print_svg_for(73, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ogre_regular_animated() {
        print_svg_for(73, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ogre_shiny_static() {
        print_svg_for(73, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_ogre_regular_static() {
        print_svg_for(73, 0, 0);
    }

    // 74: Orc
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_orc_shiny_animated() {
        print_svg_for(74, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_orc_regular_animated() {
        print_svg_for(74, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_orc_shiny_static() {
        print_svg_for(74, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_orc_regular_static() {
        print_svg_for(74, 0, 0);
    }

    // 75: Skeleton
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skeleton_shiny_animated() {
        print_svg_for(75, 1, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skeleton_regular_animated() {
        print_svg_for(75, 0, 1);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skeleton_shiny_static() {
        print_svg_for(75, 1, 0);
    }
    #[test]
    #[ignore]
    #[fork("mainnet")]
    fn generate_skeleton_regular_static() {
        print_svg_for(75, 0, 0);
    }

    fn get_regular_png_provider() -> ContractAddress {
        0x023445094e81c8c52b2a1577866eb4d72fd5cb4e239a44cd8d13b85e5ac5756e.try_into().unwrap()
    }
    fn get_shiny_png_provider() -> ContractAddress {
        0x034f55c6d1cbc500938c8bf13c5aa20c1d8eb1c937f7211a026d6d7179504f2b.try_into().unwrap()
    }
    fn get_regular_gif_provider() -> ContractAddress {
        0x04f7640b1fde95327da0e07d69a59249e144d2f644f1a605b4667316681b5e9f.try_into().unwrap()
    }
    fn get_shiny_gif_provider() -> ContractAddress {
        0x04d7ffd8cbb013f9b2dd186acc839665faf885d3e2a27693637690b73feedca6.try_into().unwrap()
    }
}
