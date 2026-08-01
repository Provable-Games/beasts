use super::beast_definitions;
use super::pack::{PackableBeast, get_hash};

/// Highest species ID backed by the baked-in `beast_definitions` tables.
/// Community species registered through `beast_registry` start at 76.
pub const GENESIS_SPECIES_MAX: u64 = 75;

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
    /// Validates a beast ID is structurally usable. Species *existence* is
    /// resolved by the contract, not here: `beast_definitions` answers for
    /// genesis species 1-75, the registry for community species 76+. Zero is
    /// never a species, and `decode_token_id` rejects it too.
    fn validate_beast_id(beast_id: u64) -> BeastResult<()> {
        if beast_id >= 1 {
            BeastResult::Ok(())
        } else {
            BeastResult::Err('Invalid beast ID')
        }
    }

    /// True for the 75 species baked into `beast_definitions`. Community
    /// species live above this line and resolve through the registry.
    fn is_genesis_species(beast_id: u64) -> bool {
        beast_id >= 1 && beast_id <= GENESIS_SPECIES_MAX
    }

    /// Validates contract-resolved species traits. These are never
    /// caller-supplied, but a registry read is still external input to the
    /// NFT, and `encode_token_id` would silently truncate out-of-range
    /// values into a different beast.
    fn validate_species_traits(tier: u8, beast_type: u8) -> BeastResult<()> {
        if tier == 0 || tier > 5 {
            return BeastResult::Err('Invalid tier');
        }
        if beast_type > 2 {
            return BeastResult::Err('Invalid beast type');
        }
        BeastResult::Ok(())
    }

    /// Validates beast attributes are within valid ranges.
    /// The (id, 0, 0) affix slot is reserved for the species' Genesis Beast,
    /// so regular mints require both prefix and suffix >= 1.
    fn validate_beast_attributes(
        prefix: u8, suffix: u8, shiny: u8, animated: u8,
    ) -> BeastResult<()> {
        // Prefix validation (1-69 based on beast_definitions)
        if prefix == 0 || prefix > 69 {
            return BeastResult::Err('Invalid prefix');
        }

        // Suffix validation (1-18 based on beast_definitions)
        if suffix == 0 || suffix > 18 {
            return BeastResult::Err('Invalid suffix');
        }

        // Shiny validation (0 or 1 only)
        if shiny > 1 {
            return BeastResult::Err('Invalid shiny value');
        }

        // Animated validation (0 or 1 only)
        if animated > 1 {
            return BeastResult::Err('Invalid animated value');
        }

        BeastResult::Ok(())
    }

    /// Creates a new beast from caller-supplied attributes plus species
    /// traits the contract has already resolved (tables for genesis species,
    /// registry for community species). Tier and type are never
    /// caller-supplied, so the values encoded into the token ID are
    /// trustworthy.
    fn create_beast_with_traits(
        beast_id: u64,
        prefix: u8,
        suffix: u8,
        level: u16,
        health: u16,
        shiny: u8,
        animated: u8,
        tier: u8,
        beast_type: u8,
    ) -> BeastResult<PackableBeast> {
        match Self::validate_beast_id(beast_id) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); },
        }

        match Self::validate_beast_attributes(prefix, suffix, shiny, animated) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); },
        }

        match Self::validate_species_traits(tier, beast_type) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); },
        }

        let beast = PackableBeast {
            id: beast_id, prefix, suffix, level, health, shiny, animated, tier, beast_type,
        };
        BeastResult::Ok(beast)
    }

    /// Genesis-species convenience wrapper: resolves tier/type from
    /// `beast_definitions`. Rejects community species, which have no table
    /// entry.
    fn create_beast(
        beast_id: u64, prefix: u8, suffix: u8, level: u16, health: u16, shiny: u8, animated: u8,
    ) -> BeastResult<PackableBeast> {
        if !Self::is_genesis_species(beast_id) {
            return BeastResult::Err('Invalid beast ID');
        }

        let (tier, beast_type) = Self::resolve_species_traits(beast_id);
        Self::create_beast_with_traits(
            beast_id, prefix, suffix, level, health, shiny, animated, tier, beast_type,
        )
    }

    /// Creates a Genesis Beast — the (id, 0, 0) affix slot reserved as the
    /// artist/creator token — from contract-resolved species traits.
    fn create_genesis_beast_with_traits(
        beast_id: u64, tier: u8, beast_type: u8,
    ) -> BeastResult<PackableBeast> {
        match Self::validate_beast_id(beast_id) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); },
        }

        match Self::validate_species_traits(tier, beast_type) {
            BeastResult::Ok(_) => {},
            BeastResult::Err(e) => { return BeastResult::Err(e); },
        }

        BeastResult::Ok(Self::genesis_beast(beast_id, tier, beast_type))
    }

    /// The canonical Genesis Beast of a species: the reserved `(id, 0, 0)`
    /// affix slot, always level 1, health 100, shiny and animated.
    ///
    /// Pure and shared on purpose. Its token ID identifies the species'
    /// creator token, and the registry derives that ID to answer "who is the
    /// artist" — so the shape must have exactly one definition or the two
    /// sides would compute different tokens.
    fn genesis_beast(beast_id: u64, tier: u8, beast_type: u8) -> PackableBeast {
        PackableBeast {
            id: beast_id,
            prefix: 0,
            suffix: 0,
            level: 1,
            health: 100,
            shiny: 1,
            animated: 1,
            tier,
            beast_type,
        }
    }

    /// Genesis-species convenience wrapper for the constructor batch.
    fn create_genesis_beast(beast_id: u64) -> BeastResult<PackableBeast> {
        if !Self::is_genesis_species(beast_id) {
            return BeastResult::Err('Invalid beast ID');
        }

        let (tier, beast_type) = Self::resolve_species_traits(beast_id);
        Self::create_genesis_beast_with_traits(beast_id, tier, beast_type)
    }

    /// Resolves the static tier/type for a genesis species from the baked-in
    /// tables. Community species (76+) resolve through the registry instead;
    /// callers must have checked `is_genesis_species` first.
    fn resolve_species_traits(beast_id: u64) -> (u8, u8) {
        let species: u8 = beast_id.try_into().expect('not a genesis species');
        (beast_definitions::get_tier(species), beast_definitions::get_type_code(species))
    }

    /// Species display name for a genesis species. Community species names
    /// live in the registry.
    fn resolve_species_name(beast_id: u64) -> felt252 {
        let species: u8 = beast_id.try_into().expect('not a genesis species');
        beast_definitions::get_beast_name(species)
    }

    /// Generates a unique hash for a beast combination
    fn get_beast_hash(beast_id: u64, prefix: u8, suffix: u8) -> felt252 {
        get_hash(beast_id, prefix, suffix)
    }

    /// Affix names for a beast. Prefix and suffix tables are shared by every
    /// species, genesis and community alike, so this stays a pure lookup.
    /// Zero means "no affix", which only the Genesis Beast has.
    fn get_affix_names(beast: PackableBeast) -> (felt252, felt252) {
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

        (prefix_name, suffix_name)
    }

    /// Full name of a genesis-species beast. Community species need the
    /// registry for the base name, so the renderer resolves it separately and
    /// pairs it with `get_affix_names`.
    fn get_full_beast_name(beast: PackableBeast) -> (felt252, felt252, felt252) {
        let base_name = Self::resolve_species_name(beast.id);
        let (prefix_name, suffix_name) = Self::get_affix_names(beast);

        (prefix_name, base_name, suffix_name)
    }

    /// Gets beast metadata attributes.
    /// Tier and type come from the decoded token ID — pure, no table reads.
    fn get_beast_attributes(beast: PackableBeast) -> BeastAttributes {
        BeastAttributes {
            beast_type: beast_definitions::type_name(beast.beast_type),
            tier: beast.tier,
            level: beast.level,
            health: beast.health,
            shiny: beast.shiny,
            animated: beast.animated,
            power: Self::get_beast_power(beast),
        }
    }

    /// Pure function of the token ID: power = level * (6 - tier).
    fn get_beast_power(beast: PackableBeast) -> u16 {
        let multiplier: u16 = (6 - beast.tier.into());

        if beast.level > 65535_u16 / multiplier {
            65535_u16
        } else {
            beast.level * multiplier
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
    pub shiny: u8,
    pub animated: u8,
    pub power: u16,
}

#[cfg(test)]
mod tests {
    use super::{BeastManagerTrait, BeastResult, PackableBeast};

    #[test]
    fn test_validate_beast_id_valid() {
        assert(
            BeastManagerTrait::validate_beast_id(1) == BeastResult::Ok(()), 'ID 1 should be valid',
        );
        assert(
            BeastManagerTrait::validate_beast_id(42) == BeastResult::Ok(()),
            'ID 42 should be valid',
        );
        assert(
            BeastManagerTrait::validate_beast_id(75) == BeastResult::Ok(()),
            'ID 75 should be valid',
        );
    }

    #[test]
    fn test_validate_beast_id_invalid() {
        assert(
            BeastManagerTrait::validate_beast_id(0) == BeastResult::Err('Invalid beast ID'),
            'ID 0 should be invalid',
        );
    }

    #[test]
    fn test_validate_beast_id_accepts_community_range() {
        // Existence of a community species is the registry's call, not this
        // function's — it only rejects structurally impossible IDs.
        assert(BeastManagerTrait::validate_beast_id(76) == BeastResult::Ok(()), 'ID 76 accepted');
        assert(
            BeastManagerTrait::validate_beast_id(1_000_000) == BeastResult::Ok(()),
            'Large ID accepted',
        );
    }

    #[test]
    fn test_is_genesis_species() {
        assert(BeastManagerTrait::is_genesis_species(1), 'ID 1 is genesis');
        assert(BeastManagerTrait::is_genesis_species(75), 'ID 75 is genesis');
        assert(!BeastManagerTrait::is_genesis_species(76), 'ID 76 is community');
        assert(!BeastManagerTrait::is_genesis_species(0), 'ID 0 is not a species');
    }

    #[test]
    fn test_validate_species_traits() {
        assert(
            BeastManagerTrait::validate_species_traits(1, 0) == BeastResult::Ok(()),
            'T1 Magic valid',
        );
        assert(
            BeastManagerTrait::validate_species_traits(5, 2) == BeastResult::Ok(()),
            'T5 Brute valid',
        );
        assert(
            BeastManagerTrait::validate_species_traits(0, 0) == BeastResult::Err('Invalid tier'),
            'Tier 0 invalid',
        );
        assert(
            BeastManagerTrait::validate_species_traits(6, 0) == BeastResult::Err('Invalid tier'),
            'Tier 6 invalid',
        );
        assert(
            BeastManagerTrait::validate_species_traits(
                1, 3,
            ) == BeastResult::Err('Invalid beast type'),
            'Type 3 invalid',
        );
    }

    #[test]
    fn test_create_beast_with_traits_community_species() {
        // Community species carry registry-supplied traits and never touch
        // the genesis tables.
        match BeastManagerTrait::create_beast_with_traits(9_000, 4, 7, 30, 500, 1, 1, 2, 1) {
            BeastResult::Ok(beast) => {
                assert(beast.id == 9_000, 'Beast ID mismatch');
                assert(beast.tier == 2, 'Tier mismatch');
                assert(beast.beast_type == 1, 'Type mismatch');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); },
        }
    }

    #[test]
    fn test_create_beast_with_traits_rejects_bad_tier() {
        match BeastManagerTrait::create_beast_with_traits(9_000, 4, 7, 30, 500, 0, 0, 9, 1) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid tier', 'Wrong error'); },
        }
    }

    #[test]
    fn test_create_beast_rejects_community_species() {
        // The genesis wrapper has no table entry for 76+.
        match BeastManagerTrait::create_beast(76, 1, 1, 10, 100, 0, 0) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid beast ID', 'Wrong error'); },
        }
    }

    #[test]
    fn test_create_genesis_beast_with_traits() {
        match BeastManagerTrait::create_genesis_beast_with_traits(500, 3, 2) {
            BeastResult::Ok(beast) => {
                assert(beast.id == 500, 'Beast ID mismatch');
                assert(beast.prefix == 0, 'Prefix should be 0');
                assert(beast.suffix == 0, 'Suffix should be 0');
                assert(beast.shiny == 1, 'Shiny should be 1');
                assert(beast.animated == 1, 'Animated should be 1');
                assert(beast.tier == 3, 'Tier mismatch');
                assert(beast.beast_type == 2, 'Type mismatch');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); },
        }
    }

    #[test]
    fn test_validate_beast_attributes_valid() {
        assert(
            BeastManagerTrait::validate_beast_attributes(1, 1, 0, 0) == BeastResult::Ok(()),
            'Attrs 1,1,0,0 should be valid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(69, 18, 1, 1) == BeastResult::Ok(()),
            'Max attrs should be valid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(10, 5, 0, 1) == BeastResult::Ok(()),
            'Mid attrs should be valid',
        );
    }

    #[test]
    fn test_validate_beast_attributes_invalid() {
        assert(
            BeastManagerTrait::validate_beast_attributes(
                70, 1, 0, 0,
            ) == BeastResult::Err('Invalid prefix'),
            'Prefix 70 invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                1, 19, 0, 0,
            ) == BeastResult::Err('Invalid suffix'),
            'Suffix 19 invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                255, 255, 0, 0,
            ) == BeastResult::Err('Invalid prefix'),
            'Max values invalid',
        );
    }

    #[test]
    fn test_validate_beast_attributes_zero_affixes_invalid() {
        // (id, 0, 0) is reserved for the Genesis Beast; regular mints
        // require both affixes >= 1.
        assert(
            BeastManagerTrait::validate_beast_attributes(
                0, 0, 0, 0,
            ) == BeastResult::Err('Invalid prefix'),
            'Zero affixes invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                0, 5, 0, 0,
            ) == BeastResult::Err('Invalid prefix'),
            'Zero prefix invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                5, 0, 0, 0,
            ) == BeastResult::Err('Invalid suffix'),
            'Zero suffix invalid',
        );
    }

    #[test]
    fn test_validate_beast_attributes_shiny_animated_invalid() {
        assert(
            BeastManagerTrait::validate_beast_attributes(
                1, 1, 2, 0,
            ) == BeastResult::Err('Invalid shiny value'),
            'Shiny 2 invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                1, 1, 0, 2,
            ) == BeastResult::Err('Invalid animated value'),
            'Animated 2 invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                1, 1, 255, 0,
            ) == BeastResult::Err('Invalid shiny value'),
            'Shiny 255 invalid',
        );
        assert(
            BeastManagerTrait::validate_beast_attributes(
                1, 1, 0, 255,
            ) == BeastResult::Err('Invalid animated value'),
            'Animated 255 invalid',
        );
    }

    #[test]
    fn test_create_beast_valid() {
        match BeastManagerTrait::create_beast(3, 1, 2, 100, 1000, 0, 0) {
            BeastResult::Ok(beast) => {
                assert(beast.id == 3, 'Beast ID mismatch');
                assert(beast.prefix == 1, 'Prefix mismatch');
                assert(beast.suffix == 2, 'Suffix mismatch');
                assert(beast.level == 100, 'Level mismatch');
                assert(beast.health == 1000, 'Health mismatch');
                assert(beast.shiny == 0, 'Shiny mismatch');
                assert(beast.animated == 0, 'Animated mismatch');
                assert(beast.tier == 1, 'Tier mismatch');
                assert(beast.beast_type == 0, 'Type mismatch');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); },
        }
    }

    #[test]
    fn test_create_beast_zero_affixes_rejected() {
        match BeastManagerTrait::create_beast(3, 0, 0, 100, 1000, 0, 0) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid prefix', 'Wrong error'); },
        }
    }

    #[test]
    fn test_create_beast_invalid_id() {
        match BeastManagerTrait::create_beast(0, 1, 2, 100, 1000, 0, 0) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid beast ID', 'Wrong error'); },
        }
    }

    #[test]
    fn test_create_beast_invalid_attributes() {
        match BeastManagerTrait::create_beast(5, 100, 2, 100, 1000, 0, 0) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid prefix', 'Wrong error'); },
        }
    }

    #[test]
    fn test_create_beast_invalid_shiny() {
        match BeastManagerTrait::create_beast(5, 1, 2, 100, 1000, 2, 0) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid shiny value', 'Wrong error'); },
        }
    }

    #[test]
    fn test_create_beast_invalid_animated() {
        match BeastManagerTrait::create_beast(5, 1, 2, 100, 1000, 0, 2) {
            BeastResult::Ok(_) => { assert(false, 'Should fail'); },
            BeastResult::Err(e) => { assert(e == 'Invalid animated value', 'Wrong error'); },
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
                assert(beast.shiny == 1, 'Shiny should be 1');
                assert(beast.animated == 1, 'Animated should be 1');
                assert(beast.tier == 4, 'Tier should be 4');
                assert(beast.beast_type == 1, 'Type should be Hunter');
            },
            BeastResult::Err(_) => { assert(false, 'Should not fail'); },
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
        let beast = PackableBeast {
            id: 3,
            prefix: 1,
            suffix: 2,
            level: 42,
            health: 1337,
            shiny: 0,
            animated: 0,
            tier: 1,
            beast_type: 0,
        };
        let (prefix, name, suffix) = BeastManagerTrait::get_full_beast_name(beast);

        assert(name == 'Jiangshi', 'Beast name mismatch');
        assert(prefix == 'Agony', 'Prefix name mismatch');
        assert(suffix == 'Root', 'Suffix name mismatch');
    }

    #[test]
    fn test_get_full_beast_name_no_prefix_suffix() {
        let beast = PackableBeast {
            id: 1,
            prefix: 0,
            suffix: 0,
            level: 1,
            health: 100,
            shiny: 0,
            animated: 0,
            tier: 1,
            beast_type: 0,
        };
        let (prefix, name, suffix) = BeastManagerTrait::get_full_beast_name(beast);

        assert(name == 'Warlock', 'Beast name mismatch');
        assert(prefix == 0, 'Prefix should be 0');
        assert(suffix == 0, 'Suffix should be 0');
    }

    #[test]
    fn test_get_beast_attributes() {
        let beast = PackableBeast {
            id: 3,
            prefix: 1,
            suffix: 2,
            level: 42,
            health: 1337,
            shiny: 0,
            animated: 0,
            tier: 1,
            beast_type: 0,
        };
        let attrs = BeastManagerTrait::get_beast_attributes(beast);

        assert(attrs.beast_type == 'Magic', 'Type mismatch');
        assert(attrs.tier == 1, 'Tier mismatch');
        assert(attrs.level == 42, 'Level mismatch');
        assert(attrs.health == 1337, 'Health mismatch');
        assert(attrs.power == 42 * 5, 'Power mismatch');
        assert(attrs.shiny == 0, 'Shiny mismatch');
        assert(attrs.animated == 0, 'Animated mismatch');
    }
}
