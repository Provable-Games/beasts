use super::pack::PackableBeast;
use super::beast_svg::BeastSvgTrait;
use super::beast_manager::BeastManagerTrait;
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
    pub attributes: Array<Attribute>
}

/// Single attribute for metadata
#[derive(Drop)]
pub struct Attribute {
    pub trait_type: ByteArray,
    pub value: ByteArray
}

#[generate_trait]
pub impl MetadataGeneratorImpl of MetadataGeneratorTrait {
    /// Generates complete metadata JSON for a beast
    fn generate_metadata(token_id: u256, beast: PackableBeast) -> ByteArray {
        let components = Self::build_metadata_components(token_id, beast);
        Self::components_to_json(components)
    }

    /// Builds metadata components from beast data
    fn build_metadata_components(token_id: u256, beast: PackableBeast) -> MetadataComponents {
        // Build name
        let mut name: ByteArray = "";
        name.append(@"Beast #");
        name.append(@format!("{}", token_id));

        // Description
        let description = "A fearsome beast from the Loot Survivor universe";

        // Image
        let image = BeastSvgTrait::generate_svg_data_uri(beast);

        // Build attributes
        let mut attributes = array![];
        
        // Get beast names
        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        
        // Beast name attribute
        attributes.append(Attribute {
            trait_type: "Beast",
            value: felt252_to_byte_array(beast_name)
        });

        // Get other attributes
        let beast_attrs = BeastManagerTrait::get_beast_attributes(beast);
        
        // Type attribute
        attributes.append(Attribute {
            trait_type: "Type",
            value: felt252_to_byte_array(beast_attrs.beast_type)
        });

        // Tier attribute
        attributes.append(Attribute {
            trait_type: "Tier",
            value: felt252_to_byte_array(beast_attrs.tier)
        });

        // Prefix attribute (if exists)
        if beast.prefix > 0 {
            attributes.append(Attribute {
                trait_type: "Prefix",
                value: felt252_to_byte_array(prefix_name)
            });
        }

        // Suffix attribute (if exists)
        if beast.suffix > 0 {
            attributes.append(Attribute {
                trait_type: "Suffix",
                value: felt252_to_byte_array(suffix_name)
            });
        }

        // Level attribute
        let mut level_value: ByteArray = "";
        level_value.append(@format!("{}", beast_attrs.level));
        attributes.append(Attribute {
            trait_type: "Level",
            value: level_value
        });

        // Health attribute
        let mut health_value: ByteArray = "";
        health_value.append(@format!("{}", beast_attrs.health));
        attributes.append(Attribute {
            trait_type: "Health",
            value: health_value
        });

        MetadataComponents {
            name,
            description,
            image,
            attributes
        }
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

    /// Generates a simple text description of a beast
    fn generate_description(beast: PackableBeast) -> ByteArray {
        let (prefix_name, beast_name, suffix_name) = BeastManagerTrait::get_full_beast_name(beast);
        let attrs = BeastManagerTrait::get_beast_attributes(beast);
        
        let mut description: ByteArray = "";
        
        // Add prefix if exists
        if beast.prefix > 0 {
            description.append(@felt252_to_byte_array(prefix_name));
            description.append(@" ");
        }
        
        // Add beast name
        description.append(@felt252_to_byte_array(beast_name));
        
        // Add suffix if exists
        if beast.suffix > 0 {
            description.append(@" ");
            description.append(@felt252_to_byte_array(suffix_name));
        }
        
        // Add type and tier
        description.append(@" - ");
        description.append(@felt252_to_byte_array(attrs.beast_type));
        description.append(@" Tier ");
        description.append(@felt252_to_byte_array(attrs.tier));
        
        // Add level and health
        description.append(@" (Level ");
        description.append(@format!("{}", attrs.level));
        description.append(@", HP ");
        description.append(@format!("{}", attrs.health));
        description.append(@")");
        
        description
    }
}

#[cfg(test)]
mod tests {
    use super::{MetadataGeneratorTrait, PackableBeast, Attribute};

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
    fn test_generate_metadata() {
        let beast = PackableBeast { id: 3, prefix: 1, suffix: 2, level: 42, health: 1337 };
        let metadata = MetadataGeneratorTrait::generate_metadata(123, beast);
        
        // Check JSON structure
        assert(find_substring(@metadata, @"{\"name\":\"Beast #123\""), 'Should have name');
        assert(find_substring(@metadata, @"\"description\":\"A fearsome beast"), 'Should have description');
        assert(find_substring(@metadata, @"\"image\":\"data:image/svg+xml,"), 'Should have image');
        assert(find_substring(@metadata, @"\"attributes\":["), 'Should have attributes');
        
        // Check attributes
        assert(find_substring(@metadata, @"\"Beast\",\"value\":\"Jiangshi\""), 'Should have beast name');
        assert(find_substring(@metadata, @"\"Type\",\"value\":\"Magical\""), 'Should have type');
        assert(find_substring(@metadata, @"\"Tier\",\"value\":\"1\""), 'Should have tier');
        assert(find_substring(@metadata, @"\"Prefix\",\"value\":\"Agony\""), 'Should have prefix');
        assert(find_substring(@metadata, @"\"Suffix\",\"value\":\"Root\""), 'Should have suffix');
        assert(find_substring(@metadata, @"\"Level\",\"value\":\"42\""), 'Should have level');
        assert(find_substring(@metadata, @"\"Health\",\"value\":\"1337\""), 'Should have health');
    }

    #[test]
    fn test_generate_metadata_no_prefix_suffix() {
        let beast = PackableBeast { id: 1, prefix: 0, suffix: 0, level: 1, health: 100 };
        let metadata = MetadataGeneratorTrait::generate_metadata(1, beast);
        
        // Should not have prefix/suffix attributes
        assert(!find_substring(@metadata, @"\"Prefix\""), 'Should not have prefix');
        assert(!find_substring(@metadata, @"\"Suffix\""), 'Should not have suffix');
        
        // Should have other attributes
        assert(find_substring(@metadata, @"\"Beast\",\"value\":\"Warlock\""), 'Should have beast name');
        assert(find_substring(@metadata, @"\"Level\",\"value\":\"1\""), 'Should have level');
    }

    #[test]
    fn test_build_metadata_components() {
        let beast = PackableBeast { id: 3, prefix: 1, suffix: 2, level: 42, health: 1337 };
        let components = MetadataGeneratorTrait::build_metadata_components(123, beast);
        
        assert(components.name == "Beast #123", 'Name mismatch');
        assert(components.description == "A fearsome beast from the Loot Survivor universe", 'Description mismatch');
        assert(components.attributes.len() == 7, 'Should have 7 attributes');
    }

    #[test]
    fn test_generate_description() {
        let beast = PackableBeast { id: 3, prefix: 1, suffix: 2, level: 42, health: 1337 };
        let description = MetadataGeneratorTrait::generate_description(beast);
        
        assert(description == "Agony Jiangshi Root - Magical Tier 1 (Level 42, HP 1337)", 'Description mismatch');
    }

    #[test]
    fn test_generate_description_no_prefix_suffix() {
        let beast = PackableBeast { id: 1, prefix: 0, suffix: 0, level: 10, health: 500 };
        let description = MetadataGeneratorTrait::generate_description(beast);
        
        assert(description == "Warlock - Magical Tier 1 (Level 10, HP 500)", 'Description mismatch');
    }

    #[test]
    fn test_components_to_json_formatting() {
        let mut attributes = array![];
        attributes.append(Attribute { trait_type: "Test", value: "Value" });
        attributes.append(Attribute { trait_type: "Another", value: "Thing" });
        
        let components = super::MetadataComponents {
            name: "Test Beast",
            description: "A test beast",
            image: "data:test",
            attributes
        };
        
        let json = MetadataGeneratorTrait::components_to_json(components);
        
        // Check proper JSON formatting
        assert(find_substring(@json, @"{\"name\":\"Test Beast\""), 'Should start with name');
        assert(find_substring(@json, @"\"attributes\":[{"), 'Should have attributes array');
        assert(find_substring(@json, @"},{"), 'Should have comma between attrs');
        assert(find_substring(@json, @"}]}"), 'Should end properly');
    }
}