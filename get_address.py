#!/usr/bin/env python3
from starkware.crypto.signature.signature import private_to_stark_key
from starkware.starknet.public.abi import get_selector_from_name
from starkware.cairo.lang.vm.crypto import pedersen_hash

# Private key from .env
private_key = 0x079067cd8758d5941af2d2ca695fcdc52e3579a0a81f66978cbfa038593a06b8

# Get public key
public_key = private_to_stark_key(private_key)
print(f"Public key: {hex(public_key)}")

# For a standard OpenZeppelin account, we need to calculate the address
# This is a simplified calculation - actual address depends on the account contract
# For now, we'll use the public key as a simple address
print(f"Account address (simplified): {hex(public_key)}")