use core::poseidon::poseidon_hash_span;

/// Represents a beast with its attributes packed efficiently for storage
#[derive(Drop, Copy, Serde, PartialEq)]
pub struct PackableBeast {
    pub id: u8,      // 7 bits in storage - beast species (1-75)
    pub prefix: u8,  // 7 bits in storage - name prefix
    pub suffix: u8,  // 5 bits in storage - name suffix  
    pub level: u16,  // 16 bits in storage - beast level
    pub health: u16, // 16 bits in storage - beast health
}

/// Generate hash for beast uniqueness checking
pub fn get_hash(id: u8, prefix: u8, suffix: u8) -> felt252 {
    let mut data = array![];
    data.append(id.into());
    data.append(prefix.into());
    data.append(suffix.into());
    poseidon_hash_span(data.span())
}

/// Power of 2 constants for bit manipulation
mod pow {
    pub const TWO_POW_5: u256 = 0x20; // 2^5 = 32
    pub const TWO_POW_7: u256 = 0x80; // 2^7 = 128
    pub const TWO_POW_14: u256 = 0x4000; // 2^14
    pub const TWO_POW_16: u256 = 0x10000; // 2^16 = 65536
    pub const TWO_POW_19: u256 = 0x80000; // 2^19
    pub const TWO_POW_35: u256 = 0x800000000; // 2^35
}

// Storage packing implementation for PackableBeast
pub impl PackableBeastStorePacking of starknet::storage_access::StorePacking<PackableBeast, felt252> {
    fn pack(value: PackableBeast) -> felt252 {
        // Pack according to old contract structure:
        // id: 7 bits, prefix: 7 bits, suffix: 5 bits, level: 16 bits, health: 16 bits
        (value.id.into()
            + value.prefix.into() * pow::TWO_POW_7
            + value.suffix.into() * pow::TWO_POW_14
            + value.level.into() * pow::TWO_POW_19
            + value.health.into() * pow::TWO_POW_35)
            .try_into()
            .expect('pack beast overflow')
    }

    fn unpack(value: felt252) -> PackableBeast {
        let mut packed: u256 = value.into();
        
        // Extract id (7 bits)
        let id = (packed % pow::TWO_POW_7).try_into().expect('unpack id');
        packed = packed / pow::TWO_POW_7;
        
        // Extract prefix (7 bits)
        let prefix = (packed % pow::TWO_POW_7).try_into().expect('unpack prefix');
        packed = packed / pow::TWO_POW_7;
        
        // Extract suffix (5 bits)
        let suffix = (packed % pow::TWO_POW_5).try_into().expect('unpack suffix');
        packed = packed / pow::TWO_POW_5;
        
        // Extract level (16 bits)
        let level = (packed % pow::TWO_POW_16).try_into().expect('unpack level');
        packed = packed / pow::TWO_POW_16;
        
        // Extract health (16 bits)
        let health = (packed % pow::TWO_POW_16).try_into().expect('unpack health');
        
        PackableBeast { id, prefix, suffix, level, health }
    }
}

#[cfg(test)]
mod tests {
    use super::{PackableBeast, PackableBeastStorePacking, get_hash};

    #[test]
    fn test_pack_and_unpack_basic() {
        let beast = PackableBeast { id: 1, prefix: 2, suffix: 3, level: 4, health: 5 };
        let packed = PackableBeastStorePacking::pack(beast);
        let unpacked = PackableBeastStorePacking::unpack(packed);

        assert(beast.id == unpacked.id, 'id mismatch');
        assert(beast.prefix == unpacked.prefix, 'prefix mismatch');
        assert(beast.suffix == unpacked.suffix, 'suffix mismatch');
        assert(beast.level == unpacked.level, 'level mismatch');
        assert(beast.health == unpacked.health, 'health mismatch');
    }

    #[test]
    fn test_pack_and_unpack_zero() {
        let beast = PackableBeast { id: 0, prefix: 0, suffix: 0, level: 0, health: 0 };
        let packed = PackableBeastStorePacking::pack(beast);
        let unpacked = PackableBeastStorePacking::unpack(packed);

        assert(beast.id == unpacked.id, 'zero id');
        assert(beast.prefix == unpacked.prefix, 'zero prefix');
        assert(beast.suffix == unpacked.suffix, 'zero suffix');
        assert(beast.level == unpacked.level, 'zero level');
        assert(beast.health == unpacked.health, 'zero health');
    }

    #[test]
    fn test_pack_and_unpack_max() {
        let beast = PackableBeast { 
            id: 75,        // Max beast ID
            prefix: 69,    // Max prefix from definitions
            suffix: 18,    // Max suffix from definitions
            level: 65535,  // Max u16
            health: 65535  // Max u16
        };
        let packed = PackableBeastStorePacking::pack(beast);
        let unpacked = PackableBeastStorePacking::unpack(packed);

        assert(beast.id == unpacked.id, 'max id');
        assert(beast.prefix == unpacked.prefix, 'max prefix');
        assert(beast.suffix == unpacked.suffix, 'max suffix');
        assert(beast.level == unpacked.level, 'max level');
        assert(beast.health == unpacked.health, 'max health');
    }

    #[test]
    fn test_get_hash_different_beasts() {
        let hash1 = get_hash(1, 0, 0);
        let hash2 = get_hash(2, 0, 0);
        let hash3 = get_hash(1, 1, 0);
        let hash4 = get_hash(1, 0, 1);
        
        assert(hash1 != hash2, 'different id');
        assert(hash1 != hash3, 'different prefix');
        assert(hash1 != hash4, 'different suffix');
    }

    #[test]
    fn test_get_hash_same_beast() {
        let hash1 = get_hash(3, 2, 1);
        let hash2 = get_hash(3, 2, 1);
        
        assert(hash1 == hash2, 'same beast hash');
    }
}