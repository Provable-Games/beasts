use super::pack::{PackableBeast, get_hash};
use super::beast_definitions;

/// Result type for beast operations
#[derive(Drop, Copy, Serde, PartialEq)]
pub enum BeastResult<T> {
    Ok: T,
    Err: felt252,
}

/// Manages beast validation and business logic
#[derive(Drop)]
pub struct BeastManager {}

#[generate_trait]
pub impl BeastManagerImpl of BeastManagerTrait {
    /// Validates a beast ID is within valid range
    fn validate_beast_id(beast_id: u8) -> BeastResult<()> {
        if beast_id >= 1 && beast_id <= 75 {
            BeastResult::Ok(())
        } else {
            BeastResult::Err('Invalid beast ID')
        }
    }

    /// Validates beast attributes are within valid ranges
    fn validate_beast_attributes(prefix: u8, suffix: u8) -> BeastResult<()> {
        // Prefix validation (0-69 based on beast_definitions)
        if prefix > 69 {
            return BeastResult::Err('Invalid prefix');
        }
        
        // Suffix validation (0-18 based on beast_definitions)
        if suffix > 18 {
            return BeastResult::Err('Invalid suffix');
        }
        
        BeastResult::Ok(())
    }

    /// Creates a new beast with validation
    fn create_beast(
        beast_id: u8,
        prefix: u8,
        suffix: u8,
        level: u16,
        health: u16
    ) -> BeastResult<PackableBeast> {
        // Validate beast ID
        match Self::validate_beast_id(beast_id) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); }
        }
        
        // Validate attributes
        match Self::validate_beast_attributes(prefix, suffix) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); }
        }
        
        // Create the beast
        let beast = PackableBeast { id: beast_id, prefix, suffix, level, health };
        BeastResult::Ok(beast)
    }

    /// Creates a genesis beast with default attributes
    fn create_genesis_beast(beast_id: u8) -> BeastResult<PackableBeast> {
        // Validate beast ID
        match Self::validate_beast_id(beast_id) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); }
        }
        
        // Create genesis beast with default attributes
        let beast = PackableBeast { 
            id: beast_id, 
            prefix: 0, 
            suffix: 0, 
            level: 1, 
            health: 100 
        };
        BeastResult::Ok(beast)
    }

    /// Generates a unique hash for a beast combination
    fn get_beast_hash(beast_id: u8, prefix: u8, suffix: u8) -> felt252 {
        get_hash(beast_id, prefix, suffix)
    }

    /// Gets the beast name including prefix and suffix
    fn get_full_beast_name(beast: PackableBeast) -> (felt252, felt252, felt252) {
        let base_name = beast_definitions::get_beast_name(beast.id);
        let prefix_name = if beast.prefix > 0 {
            beast_definitions::get_prefix(beast.prefix)
        } else {
            0
        };
        let suffix_name = if beast.suffix > 0 {
            beast_definitions::get_suffix(beast.suffix)
        } else {
            0
        };
        
        (prefix_name, base_name, suffix_name)
    }

    /// Gets beast metadata attributes
    fn get_beast_attributes(beast: PackableBeast) -> BeastAttributes {
        let tier = beast_definitions::get_tier(beast.id);

        BeastAttributes {
            beast_type: beast_definitions::get_type(beast.id),
            tier: tier,
            level: beast.level,
            health: beast.health,
            power: beast.level * (6 - tier.into())
        }
    }
}

/// Beast attributes for metadata
#[derive(Drop, Copy, Serde)]
pub struct BeastAttributes {
    pub beast_type: felt252,
    pub tier: u8,
    pub level: u16,
    pub health: u16,
    pub power: u16,
}

#[cfg(test)]
mod tests {
    use super::{BeastManagerTrait, BeastResult, PackableBeast};

    #[test]
    fn test_validate_beast_id_valid() {
        assert(BeastManagerTrait::validate_beast_id(1) == BeastResult::Ok(()), 'ID 1 should be valid');
        assert(BeastManagerTrait::validate_beast_id(42) == BeastResult::Ok(()), 'ID 42 should be valid');
        assert(BeastManagerTrait::validate_beast_id(75) == BeastResult::Ok(()), 'ID 75 should be valid');
    }

    #[test]
    fn test_validate_beast_id_invalid() {
        assert(BeastManagerTrait::validate_beast_id(0) == BeastResult::Err('Invalid beast ID'), 'ID 0 should be invalid');
        assert(BeastManagerTrait::validate_beast_id(76) == BeastResult::Err('Invalid beast ID'), 'ID 76 should be invalid');
        assert(BeastManagerTrait::validate_beast_id(255) == BeastResult::Err('Invalid beast ID'), 'ID 255 should be invalid');
    }

    #[test]
    fn test_validate_beast_attributes_valid() {
        assert(BeastManagerTrait::validate_beast_attributes(0, 0) == BeastResult::Ok(()), 'Attrs 0,0 should be valid');
        assert(BeastManagerTrait::validate_beast_attributes(69, 18) == BeastResult::Ok(()), 'Max attrs should be valid');
        assert(BeastManagerTrait::validate_beast_attributes(10, 5) == BeastResult::Ok(()), 'Mid attrs should be valid');
    }

    #[test]
    fn test_validate_beast_attributes_invalid() {
        assert(BeastManagerTrait::validate_beast_attributes(70, 0) == BeastResult::Err('Invalid prefix'), 'Prefix 70 invalid');
        assert(BeastManagerTrait::validate_beast_attributes(0, 19) == BeastResult::Err('Invalid suffix'), 'Suffix 19 invalid');
        assert(BeastManagerTrait::validate_beast_attributes(255, 255) == BeastResult::Err('Invalid prefix'), 'Max values invalid');
    }

    #[test]
    fn test_create_beast_valid() {
        match BeastManagerTrait::create_beast(3, 1, 2, 100, 1000) {
            BeastResult::Ok(beast) => {
                assert(beast.id == 3, 'Beast ID mismatch');
                assert(beast.prefix == 1, 'Prefix mismatch');
                assert(beast.suffix == 2, 'Suffix mismatch');
                assert(beast.level == 100, 'Level mismatch');
                assert(beast.health == 1000, 'Health mismatch');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); }
        }
    }

    #[test]
    fn test_create_beast_invalid_id() {
        match BeastManagerTrait::create_beast(0, 1, 2, 100, 1000) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid beast ID', 'Wrong error'); }
        }
    }

    #[test]
    fn test_create_beast_invalid_attributes() {
        match BeastManagerTrait::create_beast(5, 100, 2, 100, 1000) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid prefix', 'Wrong error'); }
        }
    }

    #[test]
    fn test_create_genesis_beast() {
        match BeastManagerTrait::create_genesis_beast(42) {
            BeastResult::Ok(beast) => {
                assert(beast.id == 42, 'Beast ID mismatch');
                assert(beast.prefix == 0, 'Prefix should be 0');
                assert(beast.suffix == 0, 'Suffix should be 0');
                assert(beast.level == 1, 'Level should be 1');
                assert(beast.health == 100, 'Health should be 100');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); }
        }
    }

    #[test]
    fn test_get_beast_hash() {
        let hash1 = BeastManagerTrait::get_beast_hash(1, 2, 3);
        let hash2 = BeastManagerTrait::get_beast_hash(1, 2, 3);
        let hash3 = BeastManagerTrait::get_beast_hash(1, 2, 4);
        
        assert(hash1 == hash2, 'Same inputs should match');
        assert(hash1 != hash3, 'Different inputs should differ');
    }

    #[test]
    fn test_get_full_beast_name() {
        let beast = PackableBeast { id: 3, prefix: 1, suffix: 2, level: 42, health: 1337 };
        let (prefix, name, suffix) = BeastManagerTrait::get_full_beast_name(beast);
        
        assert(name == 'Jiangshi', 'Beast name mismatch');
        assert(prefix == 'Agony', 'Prefix name mismatch');
        assert(suffix == 'Root', 'Suffix name mismatch');
    }

    #[test]
    fn test_get_full_beast_name_no_prefix_suffix() {
        let beast = PackableBeast { id: 1, prefix: 0, suffix: 0, level: 1, health: 100 };
        let (prefix, name, suffix) = BeastManagerTrait::get_full_beast_name(beast);
        
        assert(name == 'Warlock', 'Beast name mismatch');
        assert(prefix == 0, 'Prefix should be 0');
        assert(suffix == 0, 'Suffix should be 0');
    }

    #[test]
    fn test_get_beast_attributes() {
        let beast = PackableBeast { id: 3, prefix: 1, suffix: 2, level: 42, health: 1337 };
        let attrs = BeastManagerTrait::get_beast_attributes(beast);
        
        assert(attrs.beast_type == 'Magical', 'Type mismatch');
        assert(attrs.tier == 1, 'Tier mismatch');
        assert(attrs.level == 42, 'Level mismatch');
        assert(attrs.health == 1337, 'Health mismatch');
        assert(attrs.power == 42 * 5, 'Power mismatch');
    }
}