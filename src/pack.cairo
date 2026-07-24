use core::poseidon::poseidon_hash_span;

/// Represents a beast with its attributes packed efficiently for storage
#[derive(Drop, Copy, Serde, PartialEq)]
pub struct PackableBeast {
    pub id: u64, // 64 bits in storage - beast species (1-75 genesis, 76+ community)
    pub prefix: u8, // 7 bits in storage - name prefix
    pub suffix: u8, // 5 bits in storage - name suffix
    pub level: u16, // 16 bits in storage - beast level
    pub health: u16, // 16 bits in storage - beast health
    pub shiny: u8, // 1 bit in storage - beast shiny
    pub animated: u8, // 1 bit in storage - beast animated
    pub tier: u8, // 3 bits in storage - tier (1-5), static per species
    pub beast_type: u8 // 3 bits in storage - type (0=Magic, 1=Hunter, 2=Brute)
}

/// Generate hash for beast uniqueness checking
pub fn get_hash(id: u64, prefix: u8, suffix: u8) -> felt252 {
    let mut data = array![];
    data.append(id.into());
    data.append(prefix.into());
    data.append(suffix.into());
    poseidon_hash_span(data.span())
}

/// Power of 2 constants for bit manipulation
mod pow {
    pub const TWO_POW_2: u256 = 0x4; // 2^2
    pub const TWO_POW_5: u256 = 0x20; // 2^5 = 32
    pub const TWO_POW_7: u256 = 0x80; // 2^7 = 128
    pub const TWO_POW_16: u256 = 0x10000; // 2^16 = 65536
    pub const TWO_POW_64: u256 = 0x10000000000000000; // 2^64
    pub const TWO_POW_71: u256 = 0x800000000000000000; // 2^71
    pub const TWO_POW_76: u256 = 0x10000000000000000000; // 2^76
    pub const TWO_POW_92: u256 = 0x100000000000000000000000; // 2^92
    pub const TWO_POW_108: u256 = 0x1000000000000000000000000000; // 2^108
    pub const TWO_POW_109: u256 = 0x2000000000000000000000000000; // 2^109
    pub const TWO_POW_110: u256 = 0x4000000000000000000000000000; // 2^110
    pub const TWO_POW_113: u256 = 0x20000000000000000000000000000; // 2^113
    pub const TWO_POW_116: u256 = 0x100000000000000000000000000000; // 2^116
}

fn pack_to_u256(value: PackableBeast) -> u256 {
    value.id.into()
        + value.prefix.into() * pow::TWO_POW_64
        + value.suffix.into() * pow::TWO_POW_71
        + value.level.into() * pow::TWO_POW_76
        + value.health.into() * pow::TWO_POW_92
        + value.shiny.into() * pow::TWO_POW_108
        + value.animated.into() * pow::TWO_POW_109
        + value.tier.into() * pow::TWO_POW_110
        + value.beast_type.into() * pow::TWO_POW_113
}

fn unpack_from_u256(value: u256) -> PackableBeast {
    let mut packed = value;

    // Extract id (64 bits)
    let id: u64 = (packed % pow::TWO_POW_64).try_into().expect('unpack id');
    packed = packed / pow::TWO_POW_64;

    // Extract prefix (7 bits)
    let prefix: u8 = (packed % pow::TWO_POW_7).try_into().expect('unpack prefix');
    packed = packed / pow::TWO_POW_7;

    // Extract suffix (5 bits)
    let suffix: u8 = (packed % pow::TWO_POW_5).try_into().expect('unpack suffix');
    packed = packed / pow::TWO_POW_5;

    // Extract level (16 bits)
    let level: u16 = (packed % pow::TWO_POW_16).try_into().expect('unpack level');
    packed = packed / pow::TWO_POW_16;

    // Extract health (16 bits)
    let health: u16 = (packed % pow::TWO_POW_16).try_into().expect('unpack health');
    packed = packed / pow::TWO_POW_16;

    // Extract shiny (1 bit)
    let shiny: u8 = (packed % 2_u256).try_into().expect('unpack shiny');
    packed = packed / 2_u256;

    // Extract animated (1 bit)
    let animated: u8 = (packed % 2_u256).try_into().expect('unpack animated');
    packed = packed / 2_u256;

    // Extract tier (3 bits)
    let tier: u8 = (packed % 8_u256).try_into().expect('unpack tier');
    packed = packed / 8_u256;

    // Extract beast type (3 bits)
    let beast_type: u8 = (packed % 8_u256).try_into().expect('unpack type');
    packed = packed / 8_u256;

    assert(packed == 0, 'invalid token id');

    // Format-level validation: only IDs the contract itself could have
    // encoded are accepted. Legacy 53-bit token IDs decode with tier 0 and
    // are rejected here.
    assert(id != 0, 'invalid beast id');
    assert(tier >= 1 && tier <= 5, 'invalid tier');
    assert(beast_type <= 2, 'invalid type');
    assert(prefix <= 69, 'invalid prefix');
    assert(suffix <= 18, 'invalid suffix');
    // Genesis beasts have both affixes zero; all others have both >= 1.
    // A mixed-zero combination is never a valid token.
    assert((prefix == 0) == (suffix == 0), 'invalid affix combo');

    PackableBeast { id, prefix, suffix, level, health, shiny, animated, tier, beast_type }
}

/// Encodes a beast into its deterministic token id.
pub fn encode_token_id(beast: PackableBeast) -> u256 {
    pack_to_u256(beast)
}

/// Decodes a deterministic token id back into its beast data.
pub fn decode_token_id(token_id: u256) -> PackableBeast {
    unpack_from_u256(token_id)
}

/// Returns true if the beast is the Genesis Beast of its species.
/// Genesis is derived, not stored: the (id, 0, 0) affix slot is reserved
/// for exactly one provenance token per species.
pub fn is_genesis(beast: PackableBeast) -> bool {
    beast.prefix == 0 && beast.suffix == 0
}

// Storage packing implementation for PackableBeast
pub impl PackableBeastStorePacking of starknet::storage_access::StorePacking<
    PackableBeast, felt252,
> {
    fn pack(value: PackableBeast) -> felt252 {
        // Pack according to structure:
        // id: 64 bits, prefix: 7 bits, suffix: 5 bits, level: 16 bits, health: 16 bits,
        // shiny: 1 bit, animated: 1 bit, tier: 3 bits, type: 3 bits (116 bits total)
        encode_token_id(value).try_into().expect('pack beast overflow')
    }

    fn unpack(value: felt252) -> PackableBeast {
        decode_token_id(value.into())
    }
}

#[cfg(test)]
mod tests {
    use super::{
        PackableBeast, PackableBeastStorePacking, decode_token_id, encode_token_id, get_hash,
        is_genesis,
    };

    #[test]
    fn test_pack_and_unpack_basic() {
        let beast = PackableBeast {
            id: 1,
            prefix: 2,
            suffix: 3,
            level: 4,
            health: 5,
            shiny: 0,
            animated: 1,
            tier: 1,
            beast_type: 0,
        };
        let packed = PackableBeastStorePacking::pack(beast);
        let unpacked = PackableBeastStorePacking::unpack(packed);

        assert(beast.id == unpacked.id, 'id mismatch');
        assert(beast.prefix == unpacked.prefix, 'prefix mismatch');
        assert(beast.suffix == unpacked.suffix, 'suffix mismatch');
        assert(beast.level == unpacked.level, 'level mismatch');
        assert(beast.health == unpacked.health, 'health mismatch');
        assert(beast.shiny == unpacked.shiny, 'shiny mismatch');
        assert(beast.animated == unpacked.animated, 'animated mismatch');
        assert(beast.tier == unpacked.tier, 'tier mismatch');
        assert(beast.beast_type == unpacked.beast_type, 'type mismatch');
    }

    #[test]
    fn test_pack_and_unpack_max() {
        let beast = PackableBeast {
            id: 0xffffffffffffffff, // Max u64 species ID
            prefix: 69, // Max prefix from definitions
            suffix: 18, // Max suffix from definitions
            level: 65535, // Max u16
            health: 65535, // Max u16
            shiny: 1, // Max boolean
            animated: 1, // Max boolean
            tier: 5, // Max tier
            beast_type: 2 // Max type (Brute)
        };
        let packed = PackableBeastStorePacking::pack(beast);
        let unpacked = PackableBeastStorePacking::unpack(packed);

        assert(beast.id == unpacked.id, 'max id');
        assert(beast.prefix == unpacked.prefix, 'max prefix');
        assert(beast.suffix == unpacked.suffix, 'max suffix');
        assert(beast.level == unpacked.level, 'max level');
        assert(beast.health == unpacked.health, 'max health');
        assert(beast.shiny == unpacked.shiny, 'max shiny');
        assert(beast.animated == unpacked.animated, 'max animated');
        assert(beast.tier == unpacked.tier, 'max tier');
        assert(beast.beast_type == unpacked.beast_type, 'max type');
    }

    #[test]
    fn test_encode_decode_token_id_round_trip() {
        let beast = PackableBeast {
            id: 3,
            prefix: 1,
            suffix: 2,
            level: 42,
            health: 1337,
            shiny: 0,
            animated: 1,
            tier: 1,
            beast_type: 0,
        };

        let token_id = encode_token_id(beast);
        let decoded = decode_token_id(token_id);

        assert(decoded == beast, 'token id round trip');
    }

    #[test]
    fn test_encode_token_id_fits_u128() {
        let beast = PackableBeast {
            id: 0xffffffffffffffff,
            prefix: 69,
            suffix: 18,
            level: 65535,
            health: 65535,
            shiny: 1,
            animated: 1,
            tier: 5,
            beast_type: 2,
        };

        let token_id = encode_token_id(beast);
        assert(token_id < 0x100000000000000000000000000000_u256, 'token id exceeds 116 bits');
        let _fits: u128 = token_id.try_into().expect('token id exceeds u128');
        assert(decode_token_id(token_id) == beast, 'max token id round trip');
    }

    #[test]
    fn test_community_species_round_trip() {
        let beast = PackableBeast {
            id: 76,
            prefix: 34,
            suffix: 9,
            level: 250,
            health: 511,
            shiny: 1,
            animated: 0,
            tier: 3,
            beast_type: 1,
        };

        let token_id = encode_token_id(beast);
        assert(decode_token_id(token_id) == beast, 'community round trip');
    }

    #[test]
    fn test_is_genesis_derived_from_affixes() {
        let genesis = PackableBeast {
            id: 42,
            prefix: 0,
            suffix: 0,
            level: 1,
            health: 100,
            shiny: 1,
            animated: 1,
            tier: 3,
            beast_type: 1,
        };
        let regular = PackableBeast {
            id: 42,
            prefix: 1,
            suffix: 1,
            level: 1,
            health: 100,
            shiny: 1,
            animated: 1,
            tier: 3,
            beast_type: 1,
        };

        assert(is_genesis(genesis), 'genesis should be genesis');
        assert(!is_genesis(regular), 'regular is not genesis');
        assert(decode_token_id(encode_token_id(genesis)) == genesis, 'genesis round trip');
    }

    #[test]
    #[should_panic(expected: 'invalid affix combo')]
    fn test_decode_rejects_mixed_zero_prefix() {
        let beast = PackableBeast {
            id: 5,
            prefix: 0,
            suffix: 7,
            level: 10,
            health: 100,
            shiny: 0,
            animated: 0,
            tier: 1,
            beast_type: 0,
        };
        decode_token_id(encode_token_id(beast));
    }

    #[test]
    #[should_panic(expected: 'invalid affix combo')]
    fn test_decode_rejects_mixed_zero_suffix() {
        let beast = PackableBeast {
            id: 5,
            prefix: 7,
            suffix: 0,
            level: 10,
            health: 100,
            shiny: 0,
            animated: 0,
            tier: 1,
            beast_type: 0,
        };
        decode_token_id(encode_token_id(beast));
    }

    #[test]
    #[should_panic(expected: 'invalid beast id')]
    fn test_decode_rejects_zero_id() {
        let beast = PackableBeast {
            id: 0,
            prefix: 1,
            suffix: 1,
            level: 1,
            health: 1,
            shiny: 0,
            animated: 0,
            tier: 1,
            beast_type: 0,
        };
        decode_token_id(encode_token_id(beast));
    }

    #[test]
    #[should_panic(expected: 'invalid tier')]
    fn test_decode_rejects_legacy_53_bit_token_id() {
        // A max-value token id from the previous 53-bit format decodes with
        // tier 0 under the new layout and must be rejected.
        decode_token_id(0x1fffffffffffff_u256);
    }

    #[test]
    #[should_panic(expected: 'invalid token id')]
    fn test_decode_rejects_residual_high_bits() {
        decode_token_id(0x200000000000000000000000000000_u256);
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

    #[test]
    fn test_get_hash_u64_matches_legacy_u8_values() {
        // Death Mountain continuity: hashes are poseidon over felts, so a
        // species id of 5 hashes identically whether it arrived as u8 or u64.
        let mut data = array![];
        data.append(5);
        data.append(3);
        data.append(2);
        let legacy_style = core::poseidon::poseidon_hash_span(data.span());

        assert(get_hash(5_u64, 3, 2) == legacy_style, 'hash continuity broken');
    }
}
