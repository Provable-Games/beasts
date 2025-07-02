use core::poseidon::poseidon_hash_span;

#[derive(Drop, Copy, Serde, PartialEq)]
pub struct PackableBeast {
    pub id: u8,
    pub prefix: u8,
    pub suffix: u8,
    pub level: u16,
    pub health: u16,
}

pub fn get_hash(id: u8, prefix: u8, suffix: u8) -> felt252 {
    let mut data = array![];
    data.append(id.into());
    data.append(prefix.into());
    data.append(suffix.into());
    poseidon_hash_span(data.span())
}

// Storage packing implementation for PackableBeast
pub impl PackableBeastStorePacking of starknet::storage_access::StorePacking<PackableBeast, felt252> {
    fn pack(value: PackableBeast) -> felt252 {
        let id: felt252 = value.id.into();
        let prefix: felt252 = value.prefix.into();
        let suffix: felt252 = value.suffix.into();
        let level: felt252 = value.level.into();
        let health: felt252 = value.health.into();
        
        // Pack: health (16 bits) | level (16 bits) | suffix (8 bits) | prefix (8 bits) | id (8 bits)
        health * 0x100000000_u128.into() + level * 0x10000_u128.into() + suffix.into() * 0x100_u128.into() + prefix.into() * 0x1_u128.into() + id.into()
    }

    fn unpack(value: felt252) -> PackableBeast {
        let value_u256: u256 = value.into();
        let value_u128: u128 = value_u256.low;
        
        let id = (value_u128 & 0xFF).try_into().unwrap();
        let prefix = ((value_u128 / 0x100) & 0xFF).try_into().unwrap();
        let suffix = ((value_u128 / 0x10000) & 0xFF).try_into().unwrap();
        let level = ((value_u128 / 0x1000000) & 0xFFFF).try_into().unwrap();
        let health = ((value_u128 / 0x100000000) & 0xFFFF).try_into().unwrap();
        
        PackableBeast { id, prefix, suffix, level, health }
    }
}