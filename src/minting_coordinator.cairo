use super::beast_manager::{BeastManagerTrait, BeastResult};
use super::pack::{PackableBeast, encode_token_id};

/// Represents a mint request
#[derive(Drop, Copy, Serde)]
pub struct MintRequest {
    pub beast_id: u8,
    pub prefix: u8,
    pub suffix: u8,
    pub level: u16,
    pub health: u16,
    pub shiny: u8,
    pub animated: u8,
}

/// Result of a mint operation
#[derive(Drop, Copy, Serde)]
pub struct MintData {
    pub beast: PackableBeast,
    pub hash: felt252,
    pub token_id: u256,
}

/// Coordinates minting operations
#[derive(Drop)]
pub struct MintingCoordinator {}

#[generate_trait]
pub impl MintingCoordinatorImpl of MintingCoordinatorTrait {
    /// Validates and prepares data for minting
    fn prepare_mint(request: MintRequest) -> BeastResult<MintData> {
        // Create and validate the beast
        match BeastManagerTrait::create_beast(
            request.beast_id,
            request.prefix,
            request.suffix,
            request.level,
            request.health,
            request.shiny,
            request.animated,
        ) {
            BeastResult::Ok(beast) => {
                // Generate hash for uniqueness checking
                let hash = BeastManagerTrait::get_beast_hash(
                    request.beast_id, request.prefix, request.suffix,
                );

                let token_id = encode_token_id(beast);

                // Return mint data
                BeastResult::Ok(MintData { beast, hash, token_id })
            },
            BeastResult::Err(e) => BeastResult::Err(e),
        }
    }

    /// Prepares data for genesis mint
    fn prepare_genesis_mint(beast_id: u8) -> BeastResult<MintData> {
        // Create genesis beast
        match BeastManagerTrait::create_genesis_beast(beast_id) {
            BeastResult::Ok(beast) => {
                // Genesis beasts have no prefix/suffix, so hash is simpler
                let hash = BeastManagerTrait::get_beast_hash(beast_id, 0, 0);
                let token_id = encode_token_id(beast);

                BeastResult::Ok(MintData { beast, hash, token_id })
            },
            BeastResult::Err(e) => BeastResult::Err(e),
        }
    }

    /// Prepares the genesis beast ids.
    fn prepare_genesis_batch() -> Array<u8> {
        let mut results = array![];
        let mut beast_id: u8 = 1;

        loop {
            if beast_id > 75 {
                break;
            }

            results.append(beast_id);

            beast_id += 1;
        }

        results
    }

    /// Validates that a mint won't create a duplicate
    fn validate_uniqueness(
        beast_id: u8, prefix: u8, suffix: u8, existing_hashes: @Array<felt252>,
    ) -> bool {
        let hash = BeastManagerTrait::get_beast_hash(beast_id, prefix, suffix);

        let mut i = 0;
        let len = existing_hashes.len();
        loop {
            if i >= len {
                break true; // Not found, so unique
            }

            if *existing_hashes.at(i) == hash {
                break false; // Found duplicate
            }

            i += 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::super::pack::{PackableBeast, encode_token_id};
    use super::{BeastResult, MintRequest, MintingCoordinatorTrait};

    #[test]
    fn test_prepare_mint_valid() {
        let request = MintRequest {
            beast_id: 3, prefix: 1, suffix: 2, level: 100, health: 1000, shiny: 0, animated: 1,
        };

        match MintingCoordinatorTrait::prepare_mint(request) {
            BeastResult::Ok(data) => {
                let expected_beast = PackableBeast {
                    id: 3, prefix: 1, suffix: 2, level: 100, health: 1000, shiny: 0, animated: 1,
                };
                assert(data.beast == expected_beast, 'Beast mismatch');
                assert(data.beast.id == 3, 'Beast ID mismatch');
                assert(data.beast.prefix == 1, 'Prefix mismatch');
                assert(data.beast.suffix == 2, 'Suffix mismatch');
                assert(data.beast.level == 100, 'Level mismatch');
                assert(data.beast.health == 1000, 'Health mismatch');
                assert(data.beast.shiny == 0, 'Shiny mismatch');
                assert(data.beast.animated == 1, 'Animated mismatch');
                assert(data.token_id == encode_token_id(expected_beast), 'Token ID mismatch');
                assert(data.hash != 0, 'Hash should not be zero');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); },
        }
    }

    #[test]
    fn test_prepare_mint_invalid_id() {
        let request = MintRequest {
            beast_id: 0, prefix: 1, suffix: 2, level: 100, health: 1000, shiny: 0, animated: 0,
        };

        match MintingCoordinatorTrait::prepare_mint(request) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid beast ID', 'Wrong error'); },
        }
    }

    #[test]
    fn test_prepare_genesis_mint() {
        match MintingCoordinatorTrait::prepare_genesis_mint(25) {
            BeastResult::Ok(data) => {
                let expected_beast = PackableBeast {
                    id: 25, prefix: 0, suffix: 0, level: 1, health: 100, shiny: 1, animated: 1,
                };
                assert(data.beast == expected_beast, 'Beast mismatch');
                assert(data.beast.id == 25, 'Beast ID mismatch');
                assert(data.beast.prefix == 0, 'Prefix should be 0');
                assert(data.beast.suffix == 0, 'Suffix should be 0');
                assert(data.beast.level == 1, 'Level should be 1');
                assert(data.beast.health == 100, 'Health should be 100');
                assert(data.beast.shiny == 1, 'Shiny should be 1');
                assert(data.beast.animated == 1, 'Animated should be 1');
                assert(data.token_id == encode_token_id(expected_beast), 'Token ID mismatch');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); },
        }
    }

    #[test]
    fn test_prepare_genesis_batch() {
        let batch = MintingCoordinatorTrait::prepare_genesis_batch();

        assert(batch.len() == 75, 'Should have 75 beasts');

        assert(*batch.at(0) == 1, 'First beast should be ID 1');
        assert(*batch.at(74) == 75, 'Last beast should be ID 75');
    }

    #[test]
    fn test_validate_uniqueness_unique() {
        let existing_hashes = array![123, 456, 789];

        assert(
            MintingCoordinatorTrait::validate_uniqueness(1, 2, 3, @existing_hashes),
            'Should be unique',
        );
    }

    #[test]
    fn test_validate_uniqueness_duplicate() {
        // First, get the hash for beast 1, prefix 2, suffix 3
        let request = MintRequest {
            beast_id: 1, prefix: 2, suffix: 3, level: 100, health: 1000, shiny: 0, animated: 0,
        };

        let hash = match MintingCoordinatorTrait::prepare_mint(request) {
            BeastResult::Ok(data) => data.hash,
            BeastResult::Err(_) => 0,
        };

        let existing_hashes = array![123, hash, 789];

        assert(
            !MintingCoordinatorTrait::validate_uniqueness(1, 2, 3, @existing_hashes),
            'Should not be unique',
        );
    }
}
