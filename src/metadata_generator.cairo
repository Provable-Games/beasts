use super::beast_manager::BeastManagerTrait;
use super::beast_svg::BeastSvgTrait;
use super::encoding::bytes_base64_encode;
use super::pack::PackableBeast;
use super::utils::felt252_to_byte_array;

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
    fn generate_metadata(token_id: u256, beast: PackableBeast, rank: u16) -> ByteArray {
        let components = Self::build_metadata_components(token_id, beast, rank);
        let json = Self::components_to_json(components);

        format!("data:application/json;base64,{}", bytes_base64_encode(json))
    }

    /// Builds metadata components from beast data
    fn build_metadata_components(
        token_id: u256, beast: PackableBeast, rank: u16,
    ) -> MetadataComponents {
        // Build name
        let mut name: ByteArray = "";
        name.append(@"Beast #");
        name.append(@format!("{}", token_id));

        // Description
        let description = "A fearsome beast from the Loot Survivor universe";
        // Get beast names
        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);

        // Image
        let svg = BeastSvgTrait::generate_svg(
            beast.id, prefix_name, suffix_name, beast_name, rank, beast_attrs,
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

        // Shiny attribute
        let mut shiny_value: ByteArray = "";
        shiny_value.append(@format!("{}", beast_attrs.shiny));
        attributes.append(Attribute { trait_type: "Shiny", value: shiny_value });

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
        }

        json.append(@"]");

        // Close JSON object
        json.append(@"}");

        json
    }
}

#[cfg(test)]
mod tests {
    use super::{Attribute, MetadataGeneratorTrait, PackableBeast};

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
            }

            if found {
                break true;
            }

            i += 1;
        }
    }

    #[test]
    fn test_generate_metadata() {
        let beast = PackableBeast {
            id: 75, prefix: 4, suffix: 4, level: 142, health: 123, shiny: true,
        };
        let metadata = MetadataGeneratorTrait::generate_metadata(123, beast, 1);
        println!("{}", @metadata);

        // Check JSON structure
        assert(find_substring(@metadata, @"{\"name\":\"Beast #123\""), 'Should have name');
        assert(
            find_substring(@metadata, @"\"description\":\"A fearsome beast"),
            'Should have description',
        );
        assert(find_substring(@metadata, @"\"image\":\"data:image/svg+xml,"), 'Should have image');
        assert(find_substring(@metadata, @"\"attributes\":["), 'Should have attributes');

        // Check attributes
        assert(
            find_substring(@metadata, @"\"Beast\",\"value\":\"Jiangshi\""),
            'Should have beast name',
        );
        assert(find_substring(@metadata, @"\"Type\",\"value\":\"Magical\""), 'Should have type');
        assert(find_substring(@metadata, @"\"Tier\",\"value\":\"1\""), 'Should have tier');
        assert(find_substring(@metadata, @"\"Prefix\",\"value\":\"Agony\""), 'Should have prefix');
        assert(find_substring(@metadata, @"\"Suffix\",\"value\":\"Root\""), 'Should have suffix');
        assert(find_substring(@metadata, @"\"Level\",\"value\":\"42\""), 'Should have level');
        assert(find_substring(@metadata, @"\"Health\",\"value\":\"1337\""), 'Should have health');
    }

    #[test]
    fn test_generate_metadata_no_prefix_suffix() {
        let beast = PackableBeast {
            id: 1, prefix: 0, suffix: 0, level: 1, health: 100, shiny: false,
        };
        let metadata = MetadataGeneratorTrait::generate_metadata(1, beast, 0);

        // Should not have prefix/suffix attributes
        assert(!find_substring(@metadata, @"\"Prefix\""), 'Should not have prefix');
        assert(!find_substring(@metadata, @"\"Suffix\""), 'Should not have suffix');

        // Should have other attributes
        assert(
            find_substring(@metadata, @"\"Beast\",\"value\":\"Warlock\""), 'Should have beast name',
        );
        assert(find_substring(@metadata, @"\"Level\",\"value\":\"1\""), 'Should have level');
    }

    #[test]
    fn test_build_metadata_components() {
        let beast = PackableBeast {
            id: 3, prefix: 1, suffix: 2, level: 42, health: 1337, shiny: false,
        };
        let components = MetadataGeneratorTrait::build_metadata_components(123, beast, 1);

        assert(components.name == "Beast #123", 'Name mismatch');
        assert(
            components.description == "A fearsome beast from the Loot Survivor universe",
            'Description mismatch',
        );
        assert(components.attributes.len() == 10, 'Should have 10 attributes');
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
}
