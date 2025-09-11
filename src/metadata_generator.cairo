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
        // Build name
        let mut name: ByteArray = "";
        name.append(@"Beast #");
        name.append(@format!("{}", token_id));

        // Description
        let description =
            "The Beasts are a collection of digital-native creatures, born onchain and built for battle.

            With 1,243 variants across 75 species, the fixed supply of 93,225 Beasts strikes a balance between abundance and scarcity: ample supply for onchain fun, paired with distinctive visual and non-visual traits that give collectors endless reasons to obsess over this rich collection.

            Beasts carry two sets of traits: visual and combat.
            Visual traits make collecting exciting, with Shiny and Animated forms that activate unique, pixel-perfect effects. Each Beast also features live traits, such as a built-in ranking system that places every Beast between 1 and 1,243 based on its power relative to others of its species. Rankings update automatically with each newly minted Beast until all 1,243 of that species are collected, at which point a King Beast is crowned.

            When collected, a Beast is minted with its level and health. Combined with its type and tier, these traits define a combat profile that allows Beasts to canonically battle onchain using the same combat system that first brought them into the world - Loot Survivor. Beasts also evolve through live traits such as the number of Adventurers they have slain, the last Adventurer who defeated them, and the timestamp of that defeat. These provide long-term, credibly neutral building blocks for future systems of growth and leveling, intentionally omitted from the base layer to support and promote emergence.

            Beasts are not purchased, they are earned by worthy Adventurers in the dungeons of Loot Survivor, a fully onchain game powered by verifiable randomness. The story of every Beast begins not at its mint, but with the Adventurer who braved the dungeon. It is the combination of decisions and chance that ultimately leads to the creation of each Beast. Every step of that journey is etched onto an incorruptible, indestructible ledger, ensuring those stories remain accessible as long as the network exists.

            For collectors, Beasts offer a generative art collection with verifiable scarcity, issuance, and provenance. For players, Beasts deliver endless opportunities for onchain fun.

            Beast artwork courtesy of the legends at 1337 Skulls (:5ku11u73:)";
        // Get beast names
        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        );
        let image = format!("data:image/svg+xml;base64,{}", bytes_base64_encode(svg));

        // Build attributes
        let mut attributes = array![];

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
                Attribute {
                    trait_type: "Last Killed By Adventurer", value: last_killed_by_adventurer_value,
                },
            );

        // Last killed timestamp attribute
        let mut last_killed_timestamp_value: ByteArray = "";
        last_killed_timestamp_value.append(@format!("{}", last_killed_timestamp));
        attributes
            .append(
                Attribute {
                    trait_type: "Last Killed Timestamp", value: last_killed_timestamp_value,
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
    use snforge_std::{start_mock_call};
    use starknet::ContractAddress;

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

        assert(components.name == "Beast #123", 'Name mismatch');
        assert(components.attributes.len() == 15, 'Should have 15 attributes');
        assert!(components.attributes.at(0).trait_type == @"Beast", "Should have Beast trait");
        assert!(components.attributes.at(1).trait_type == @"Type", "Should have Type trait");
        assert!(components.attributes.at(2).trait_type == @"Tier", "Should have Tier trait");
        assert!(components.attributes.at(3).trait_type == @"Prefix", "Should have Prefix trait");
        assert!(components.attributes.at(4).trait_type == @"Suffix", "Should have Suffix trait");
        assert!(components.attributes.at(5).trait_type == @"Level", "Should have Level trait");
        assert!(components.attributes.at(6).trait_type == @"Health", "Should have Health trait");
        assert!(components.attributes.at(7).trait_type == @"Power", "Should have Power trait");
        assert!(components.attributes.at(8).trait_type == @"Rank", "Should have Rank trait");
        assert!(
            components.attributes.at(9).trait_type == @"Adventurers Killed",
            "Should have Adventurers Killed trait",
        );
        assert!(
            components.attributes.at(10).trait_type == @"Last Killed By Adventurer",
            "Should have Last Killed By Adventurer trait",
        );
        assert!(
            components.attributes.at(11).trait_type == @"Last Killed Timestamp",
            "Should have Last Killed Timestamp trait",
        );
        assert!(components.attributes.at(12).trait_type == @"Shiny", "Should have Shiny trait");
        assert!(
            components.attributes.at(13).trait_type == @"Animated", "Should have Animated trait",
        );
        assert!(components.attributes.at(14).trait_type == @"Genesis", "Should have Genesis trait");
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
    #[fork("sepolia")]
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
    #[fork("sepolia")]
    fn fork_gif_provider_returns_data_uri() {
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_regular_gif_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "GIF provider must return data URI");
    }

    #[test]
    #[fork("sepolia")]
    fn fork_shiny_png_provider_returns_data_uri() {
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_shiny_png_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "Shiny PNG provider must return data URI");
    }

    #[test]
    #[fork("sepolia")]
    fn fork_shiny_gif_provider_returns_data_uri() {
        let beast_id: u8 = 1;
        let provider = IBeastImageDataProviderDispatcher {
            contract_address: get_shiny_gif_provider(),
        };
        let uri = provider.get_data_uri(beast_id);
        assert!(uri.len() != 0, "Shiny GIF provider must return data URI");
    }

    #[test]
    #[fork("sepolia")]
    fn generate_warlock_shiny_animated() {
        let beast: PackableBeast = PackableBeast {
            id: 1, prefix: 3, suffix: 7, level: 25, health: 100, shiny: 1, animated: 1,
        };

        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        let rank = 1;

        let image_data_provider = IBeastImageDataProviderDispatcher {
            contract_address: get_shiny_gif_provider(),
        };

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        );

        println!("{}", svg);
    }

    #[test]
    #[fork("sepolia")]
    fn generate_warlock_regular_animated() {
        let beast: PackableBeast = PackableBeast {
            id: 1, prefix: 6, suffix: 12, level: 25, health: 100, shiny: 0, animated: 1,
        };

        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        let rank = 2;

        let image_data_provider = IBeastImageDataProviderDispatcher {
            contract_address: get_regular_gif_provider(),
        };

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        );

        println!("{}", svg);
    }

    #[test]
    #[fork("sepolia")]
    fn generate_warlock_shiny_static() {
        let beast: PackableBeast = PackableBeast {
            id: 3, prefix: 2, suffix: 2, level: 20, health: 100, shiny: 1, animated: 0,
        };

        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        let rank = 1;

        let image_data_provider = IBeastImageDataProviderDispatcher {
            contract_address: get_shiny_png_provider(),
        };

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        );

        println!("{}", svg);
    }

    #[test]
    #[fork("sepolia")]
    fn generate_warlock_regular_static() {
        let beast: PackableBeast = PackableBeast {
            id: 4, prefix: 3, suffix: 3, level: 25, health: 100, shiny: 0, animated: 0,
        };

        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        let rank = 1;

        let image_data_provider = IBeastImageDataProviderDispatcher {
            contract_address: get_regular_png_provider(),
        };

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs, image_data_provider,
        );

        println!("{}", svg);
    }

    fn get_regular_png_provider() -> ContractAddress {
        0x0292d819758f7cc8f4ef01b019d9688cd53d2ee118b17937f0769cfde45d61d2.try_into().unwrap()
    }
    fn get_shiny_png_provider() -> ContractAddress {
        0x06461aebd8a28d171e2501be111d41bc7d95090c48babbb349bea8a82083c737.try_into().unwrap()
    }
    fn get_regular_gif_provider() -> ContractAddress {
        0x00b5d7d133217766a84b1328daaa5ee1f92df2e9a57794e4aa1e3eb183c5b7b8.try_into().unwrap()
    }
    fn get_shiny_gif_provider() -> ContractAddress {
        0x02d5e40e0234c4e504b9832426ed5377832121ba398ba006f70255ebc67acbc4.try_into().unwrap()
    }
}
