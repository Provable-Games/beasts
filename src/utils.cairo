use core::byte_array::ByteArrayTrait;

/// Convert a short string felt252 to ByteArray
/// This handles Cairo's short string encoding
pub fn felt252_to_byte_array(value: felt252) -> ByteArray {
    let mut result = "";

    // Handle empty/zero case
    if value == 0 {
        return result;
    }

    // Convert felt252 to u256 for integer operations
    let mut data: u256 = value.into();
    let mut chars = array![];

    // Extract bytes from felt252 (up to 31 bytes for short strings)
    loop {
        if data == 0 {
            break;
        }
        let byte = data % 256;
        chars.append(byte.try_into().unwrap());
        data = data / 256;
    };

    // Reverse the array since we extracted bytes in reverse order
    let mut i = chars.len();
    loop {
        if i == 0 {
            break;
        }
        i -= 1;
        let char: u8 = *chars.at(i);
        if char != 0 {
            result.append_byte(char);
        }
    };

    result
}
