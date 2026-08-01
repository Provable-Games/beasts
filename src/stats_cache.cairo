//! Cached combat stats for community species tokens.
//!
//! Community species draw live stats from an artist-nominated `IBeastStats`
//! source, which is an untrusted contract. Starknet cannot catch a failed
//! external call, so reading one from `token_uri` would let any artist brick
//! rendering for their entire species — permanently, since `lock_art` does
//! not freeze the stats pointer. Stats are therefore pulled by an explicit,
//! permissionless `refresh_stats` call and cached here; `token_uri` only ever
//! reads storage and can never revert because of a third-party contract.
//!
//! Genesis species (1-75) keep the original live Death Mountain reads: that
//! dispatcher is set by the contract owner, not by a permissionless caller.

use starknet::storage_access::StorePacking;

#[derive(Drop, Copy, Serde, PartialEq, Default)]
pub struct CachedStats {
    pub adventurers_killed: u64,
    pub last_killed_by: u64,
    pub last_killed_timestamp: u64,
}

const TWO_POW_64: u256 = 0x10000000000000000;
const TWO_POW_128: u256 = 0x100000000000000000000000000000000;

/// Three u64s = 192 bits, comfortably inside one felt252 storage slot.
pub impl CachedStatsStorePacking of StorePacking<CachedStats, felt252> {
    fn pack(value: CachedStats) -> felt252 {
        let packed: u256 = value.adventurers_killed.into()
            + value.last_killed_by.into() * TWO_POW_64
            + value.last_killed_timestamp.into() * TWO_POW_128;
        packed.try_into().expect('pack cached stats')
    }

    fn unpack(value: felt252) -> CachedStats {
        let mut packed: u256 = value.into();

        let adventurers_killed: u64 = (packed % TWO_POW_64).try_into().expect('unpack killed');
        packed = packed / TWO_POW_64;
        let last_killed_by: u64 = (packed % TWO_POW_64).try_into().expect('unpack killed by');
        packed = packed / TWO_POW_64;
        let last_killed_timestamp: u64 = (packed % TWO_POW_64).try_into().expect('unpack ts');
        packed = packed / TWO_POW_64;

        assert(packed == 0, 'invalid cached stats');

        CachedStats { adventurers_killed, last_killed_by, last_killed_timestamp }
    }
}

#[cfg(test)]
mod tests {
    use super::{CachedStats, CachedStatsStorePacking};

    #[test]
    fn test_round_trip() {
        let stats = CachedStats {
            adventurers_killed: 42, last_killed_by: 1337, last_killed_timestamp: 1715558400,
        };
        let unpacked = CachedStatsStorePacking::unpack(CachedStatsStorePacking::pack(stats));
        assert(unpacked == stats, 'stats round trip');
    }

    #[test]
    fn test_round_trip_max_values() {
        let max = 0xffffffffffffffff_u64;
        let stats = CachedStats {
            adventurers_killed: max, last_killed_by: max, last_killed_timestamp: max,
        };
        let unpacked = CachedStatsStorePacking::unpack(CachedStatsStorePacking::pack(stats));
        assert(unpacked == stats, 'max round trip');
    }

    #[test]
    fn test_zero_slot_decodes_to_default() {
        let unpacked = CachedStatsStorePacking::unpack(0);
        assert(unpacked == Default::default(), 'empty slot is default');
    }
}
