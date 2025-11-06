use starknet::storage::{
    StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry, StoragePointerReadAccess,
    StoragePointerWriteAccess,
};
use super::beast_manager::BeastManagerTrait;
use super::pack::PackableBeast;

/// Manages beast rankings efficiently with minimal storage
#[derive(Drop)]
pub struct BeastRankingManager {}

#[generate_trait]
pub impl BeastRankingManagerImpl of BeastRankingManagerTrait {
    /// Efficiently calculates and stores rank using minimal storage approach
    /// Uses binary search on species-specific sorted lists to avoid massive loops
    fn calculate_and_store_rank(
        ref self: super::beasts_nft::ContractState, beast: PackableBeast, token_id: u256,
    ) -> u16 {
        let beast_id = beast.id;
        let power = BeastManagerTrait::get_beast_power(beast);
        let health = beast.health;

        // Get current count of this beast species
        let current_count = self.beast_counts.read(beast_id);

        // Find insertion rank using binary search on species list
        let insertion_rank = Self::find_insertion_rank_binary(
            @self, beast_id, power, health, current_count,
        );

        // Shift existing entries down to make room
        if insertion_rank <= current_count {
            Self::shift_species_list_down(ref self, beast_id, insertion_rank, current_count);
        }

        // Insert new beast into sorted list and update mappings
        self.beast_species_lists.entry(beast_id).entry(insertion_rank).write(token_id);
        self.beast_counts.write(beast_id, current_count + 1);
        insertion_rank
    }

    /// Uses binary search to find insertion rank within species-specific list
    fn find_insertion_rank_binary(
        state: @super::beasts_nft::ContractState, beast_id: u8, power: u16, health: u16, count: u16,
    ) -> u16 {
        if count == 0 {
            return 1; // First beast of this species
        }

        let mut left = 1_u16;
        let mut right = count + 1;

        // Binary search through species list
        loop {
            if left >= right {
                break;
            }

            let mid = left + (right - left) / 2;

            if mid > count {
                right = mid;
                continue;
            }

            // Get existing beast at mid position
            let existing_token_id = state.beast_species_lists.entry(beast_id).entry(mid).read();
            let existing_beast = state.beasts.read(existing_token_id);
            let existing_power = BeastManagerTrait::get_beast_power(existing_beast);
            let existing_health = existing_beast.health;

            // Compare: power (desc), then health (desc)
            if power > existing_power || (power == existing_power && health > existing_health) {
                right = mid;
            } else {
                left = mid + 1;
            }
        };

        left
    }

    /// Shifts entries in species list down from insertion point
    fn shift_species_list_down(
        ref self: super::beasts_nft::ContractState, beast_id: u8, from_rank: u16, count: u16,
    ) {
        // Shift from the end to avoid overwriting
        let mut current_rank = count;

        loop {
            if current_rank < from_rank {
                break;
            }

            let token_id = self.beast_species_lists.entry(beast_id).entry(current_rank).read();

            // Move entry down one rank
            self.beast_species_lists.entry(beast_id).entry(current_rank + 1).write(token_id);

            current_rank -= 1;
        };
    }

    /// Gets the rank of a specific token (only function needed for tokenURI)
    fn get_beast_rank(state: @super::beasts_nft::ContractState, token_id: u256) -> u16 {
        // Genesis beasts (token IDs 1-75) are not part of ranking system
        if token_id <= 75 {
            return 0; // Genesis beasts have no rank
        }

        let beast = state.beasts.entry(token_id).read();
        let mut rank = Self::find_insertion_rank_binary(
            state,
            beast.id,
            BeastManagerTrait::get_beast_power(beast),
            beast.health,
            state.beast_counts.read(beast.id),
        );

        // If multiple beasts have the same power and health, find the correct rank
        while state.beast_species_lists.entry(beast.id).entry(rank).read() != token_id && rank > 1 {
            rank -= 1;
        };

        rank
    }
}

#[cfg(test)]
mod tests {
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, map_entry_address,
        start_cheat_caller_address, stop_cheat_caller_address, store, spy_events, EventSpyTrait,
    };
    use starknet::ContractAddress;
    use core::traits::TryInto;
    use super::super::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};
    use super::super::pack::{PackableBeast, PackableBeastStorePacking};
    use super::super::beast_definitions::{WARLOCK, PREFIX_SHIMMERING, SUFFIX_MOON};
    use super::super::constants::MAX_EVENTS;

    fn deploy_contract() -> (IBeastsDispatcher, ContractAddress, ContractAddress, ContractAddress) {
        let regular_png_provider = declare("beast_png_regular_data").unwrap().contract_class();
        let (regular_png_provider_address, _) = regular_png_provider.deploy(@array![]).unwrap();
        let shiny_png_provider = declare("beast_png_shiny_data").unwrap().contract_class();
        let (shiny_png_provider_address, _) = shiny_png_provider.deploy(@array![]).unwrap();
        let regular_gif_provider = declare("beast_gif_regular_data").unwrap().contract_class();
        let (regular_gif_provider_address, _) = regular_gif_provider.deploy(@array![]).unwrap();
        let shiny_gif_provider = declare("beast_gif_shiny_data").unwrap().contract_class();
        let (shiny_gif_provider_address, _) = shiny_gif_provider.deploy(@array![]).unwrap();

        let contract = declare("beasts_nft").unwrap().contract_class();
        let owner: ContractAddress = 0x123.try_into().unwrap();
        let recipient: ContractAddress = 0x456.try_into().unwrap();
        let minter: ContractAddress = 0x789.try_into().unwrap();
        let royalty_receiver: ContractAddress = 0xabc.try_into().unwrap();
        let royalty_fraction: u128 = 500;

        let mut constructor_data = array![];
        let name: ByteArray = "Beasts";
        let symbol: ByteArray = "BEAST";

        // Serialize constructor parameters in correct order
        name.serialize(ref constructor_data);
        symbol.serialize(ref constructor_data);
        owner.serialize(ref constructor_data);
        royalty_receiver.serialize(ref constructor_data);
        royalty_fraction.serialize(ref constructor_data);
        regular_png_provider_address.serialize(ref constructor_data);
        shiny_png_provider_address.serialize(ref constructor_data);
        regular_gif_provider_address.serialize(ref constructor_data);
        shiny_gif_provider_address.serialize(ref constructor_data);
        0.serialize(ref constructor_data);
        0.serialize(ref constructor_data);

        let (contract_address, _) = contract.deploy(@constructor_data).unwrap();
        let dispatcher = IBeastsDispatcher { contract_address };

        start_cheat_caller_address(contract_address, owner);
        dispatcher.set_dungeon_address(minter);
        stop_cheat_caller_address(contract_address);

        (dispatcher, contract_address, recipient, minter)
    }

    const BEASTS_SELECTOR: felt252 = selector!("beasts");
    const BEAST_SPECIES_LISTS_SELECTOR: felt252 = selector!("beast_species_lists");
    const BEAST_COUNTS_SELECTOR: felt252 = selector!("beast_counts");
    const TOKEN_COUNTER_SELECTOR: felt252 = selector!("token_counter");
    const BOOKMARK_SELECTOR: felt252 = selector!("beast_metadata_refresh_bookmark");

    fn store_packable_beast(
        contract_address: ContractAddress, token_id: u256, beast: PackableBeast,
    ) {
        let packed = PackableBeastStorePacking::pack(beast);
        let mut key = array![];
        token_id.serialize(ref key);
        let address = map_entry_address(BEASTS_SELECTOR, key.span());
        store(contract_address, address, array![packed].span());
    }

    fn store_species_rank(
        contract_address: ContractAddress, beast_id: u8, rank: u16, token_id: u256,
    ) {
        let mut keys = array![];
        beast_id.serialize(ref keys);
        rank.serialize(ref keys);
        let address = map_entry_address(BEAST_SPECIES_LISTS_SELECTOR, keys.span());
        store(contract_address, address, array![token_id.low.into(), token_id.high.into()].span());
    }

    fn store_beast_count(contract_address: ContractAddress, beast_id: u8, count: u16) {
        let mut keys = array![];
        beast_id.serialize(ref keys);
        let address = map_entry_address(BEAST_COUNTS_SELECTOR, keys.span());
        store(contract_address, address, array![count.into()].span());
    }

    fn store_token_counter(contract_address: ContractAddress, value: u256) {
        store(
            contract_address,
            TOKEN_COUNTER_SELECTOR,
            array![value.low.into(), value.high.into()].span(),
        );
    }

    fn stage_beasts(contract_address: ContractAddress, beast_id: u8, staged_count: u16) {
        assert(beast_id > 0, 'Beast ID must be > 0');
        assert(beast_id <= 75, 'Beast ID must be <= 75');
        assert(staged_count > 0, 'Staged count must be > 0');
        assert(staged_count <= 1024, 'Staged count must be <= 1024');

        const GENESIS_SUPPLY: u256 = 75;
        let mut index = 0;
        let mut token_id = GENESIS_SUPPLY + 1;

        loop {
            if index >= staged_count {
                break;
            }

            let level = index + 1_u16;
            let health = level / 2_u16;
            let prefix: u8 = (1_u16 + (index % 5_u16)).try_into().unwrap();
            let suffix: u8 = (1_u16 + (index % 3_u16)).try_into().unwrap();

            let beast = PackableBeast {
                id: beast_id, prefix, suffix, level, health, shiny: 0, animated: 0,
            };

            store_packable_beast(contract_address, token_id, beast);

            let rank = staged_count - index;
            store_species_rank(contract_address, beast_id, rank, token_id);

            index += 1_u16;
            token_id += 1_u256;
        };

        store_beast_count(contract_address, beast_id, staged_count);
        store_token_counter(contract_address, GENESIS_SUPPLY + staged_count.into());
    }

    #[test]
    fn test_ranking_system_basic() {
        // Test basic ranking functionality
        let (beasts, contract_address, recipient, minter) = deploy_contract();
        start_cheat_caller_address(contract_address, minter);

        // Genesis beasts are already minted (tokens 1-75), so new mints start at 76
        // Genesis beasts should have rank 0 (not part of ranking)
        assert(beasts.get_beast_rank(1_u256) == 0_u16, 'Genesis has no rank');

        // Mint first custom beast
        beasts.mint(recipient, 1_u8, 1_u8, 1_u8, 100_u16, 50_u16, 0, 0);
        assert(beasts.get_beast_rank(76_u256) == 1_u16, 'First custom beast rank 1');

        // Mint stronger beast
        beasts.mint(recipient, 1_u8, 1_u8, 2_u8, 200_u16, 80_u16, 0, 0);
        assert(beasts.get_beast_rank(77_u256) == 1_u16, 'Strong beast rank 1');
        assert(beasts.get_beast_rank(76_u256) == 2_u16, 'Weak beast rank 2');

        // Mint weakest beast
        beasts.mint(recipient, 1_u8, 1_u8, 3_u8, 50_u16, 30_u16, 0, 0);
        assert(beasts.get_beast_rank(78_u256) == 3_u16, 'Weakest rank 3');

        stop_cheat_caller_address(contract_address);
    }

    #[test]
    fn test_max_shift() {
        let (beasts, contract_address, recipient, minter) = deploy_contract();

        // Seed ranking state without minting by staging the storage slots directly
        let existing_beast_count = 1023;
        stage_beasts(contract_address, WARLOCK, existing_beast_count);

        // set internal token counter to 1098 (75 genesis beasts + 1023 beasts)
        let initial_supply = 1098;
        store_token_counter(contract_address, initial_supply.into());
        assert!(
            beasts.total_supply() == initial_supply.into(),
            "Wrong total supply. Expected {}, got {}",
            initial_supply,
            beasts.total_supply(),
        );

        // mint the last Warlock as rank 1 which will derank 1023 existing Beasts
        start_cheat_caller_address(contract_address, minter);
        let mut spy = spy_events();
        let (king_warlock_token_id, insertion_rank, bookmark_set) = beasts
            .mint(recipient, WARLOCK, PREFIX_SHIMMERING, SUFFIX_MOON, 65535, 1023, 0, 0);
        stop_cheat_caller_address(contract_address);

        let events = spy.get_events();

        // verify contract emitted MAX_EVENTS metadata update events
        assert!(
            events.events.len() == MAX_EVENTS.into(),
            "Wrong number of events. Expected {}, got {}",
            MAX_EVENTS,
            events.events.len(),
        );
        // assert bookmark was set
        assert(bookmark_set, 'Bookmark was not set');
        // check bookmark value
        let bookmark = beasts.get_beast_metadata_bookmark(WARLOCK);
        let expected_bookmark = MAX_EVENTS + 1;
        assert!(
            bookmark == expected_bookmark,
            "Wrong bookmark value. Expected {}, got {}",
            expected_bookmark,
            bookmark,
        );
        // assert insertion rank is 1
        assert!(insertion_rank == 1, "Insertion rank is not 1. Expected 1, got {}", insertion_rank);

        // verify the minted warlock is rank 1
        let king_warlock_rank = beasts.get_beast_rank(king_warlock_token_id);
        assert!(
            king_warlock_rank == 1, "Wrong Warlock Rank. Expected 1, got {}", king_warlock_rank,
        );
        // verify the total supply is 1076 (75 genesis beasts + 1001 beasts)
        let total_supply = beasts.total_supply();
        assert!(
            total_supply == 1099.into(), "Wrong total supply. Expected 1099, got {}", total_supply,
        );
        // verify the previous strongest Warlock is rank 2
        let previous_strongest_warlock_rank = beasts.get_beast_rank(king_warlock_token_id - 1);
        assert!(
            previous_strongest_warlock_rank == 2,
            "Previous strongest shifted. Expected 2, got {}",
            previous_strongest_warlock_rank,
        );
    }

    #[test]
    fn test_ranking_health_tiebreaker() {
        // Test health tiebreaker for same power
        let (beasts, contract_address, recipient, minter) = deploy_contract();
        start_cheat_caller_address(contract_address, minter);

        // Same level, different health (token IDs start at 76 after genesis)
        beasts.mint(recipient, 1_u8, 1_u8, 1_u8, 100_u16, 30_u16, 0, 0);
        beasts.mint(recipient, 1_u8, 1_u8, 2_u8, 100_u16, 80_u16, 0, 0);

        // Higher health should win tiebreaker
        assert(beasts.get_beast_rank(77_u256) == 1_u16, 'Higher health rank 1');
        assert(beasts.get_beast_rank(76_u256) == 2_u16, 'Lower health rank 2');

        stop_cheat_caller_address(contract_address);
    }

    #[test]
    fn test_ranking_species_isolation() {
        // Test that different species have separate rankings
        let (beasts, contract_address, recipient, minter) = deploy_contract();
        start_cheat_caller_address(contract_address, minter);

        // Species 1 beasts (token IDs start at 76 after genesis)
        beasts.mint(recipient, 1_u8, 1_u8, 1_u8, 100_u16, 50_u16, 0, 0);
        beasts.mint(recipient, 1_u8, 1_u8, 2_u8, 80_u16, 40_u16, 0, 0);

        // Species 2 beast (should start at rank 1)
        beasts.mint(recipient, 2_u8, 1_u8, 1_u8, 90_u16, 45_u16, 0, 0);

        // Verify species isolation
        assert(beasts.get_beast_rank(76_u256) == 1_u16, 'Species 1 strongest');
        assert(beasts.get_beast_rank(77_u256) == 2_u16, 'Species 1 weaker');
        assert(beasts.get_beast_rank(78_u256) == 1_u16, 'Species 2 starts rank 1');

        stop_cheat_caller_address(contract_address);
    }

    #[test]
    fn test_ranking_multiple_shifts() {
        // Test inserting strongest when multiple weaker exist
        let (beasts, contract_address, recipient, minter) = deploy_contract();
        start_cheat_caller_address(contract_address, minter);

        // Insert 5 weaker beasts (token IDs start at 76 after genesis)
        beasts.mint(recipient, 1_u8, 1_u8, 1_u8, 10_u16, 30_u16, 0, 0);
        beasts.mint(recipient, 1_u8, 1_u8, 2_u8, 20_u16, 40_u16, 0, 0);
        beasts.mint(recipient, 1_u8, 1_u8, 3_u8, 30_u16, 50_u16, 0, 0);
        beasts.mint(recipient, 1_u8, 1_u8, 4_u8, 40_u16, 60_u16, 0, 0);
        beasts.mint(recipient, 1_u8, 1_u8, 5_u8, 50_u16, 70_u16, 0, 0);

        // Insert strongest (should shift all 5 down)
        beasts.mint(recipient, 1_u8, 1_u8, 6_u8, 200_u16, 100_u16, 0, 0);

        // Verify all rankings
        assert(beasts.get_beast_rank(81_u256) == 1_u16, 'Strongest rank 1');
        assert(beasts.get_beast_rank(80_u256) == 2_u16, 'Previous strongest rank 2');
        assert(beasts.get_beast_rank(76_u256) == 6_u16, 'Weakest rank 6');
        assert(beasts.total_supply() == 81_u256, 'Should have 81 beasts');

        stop_cheat_caller_address(contract_address);
    }

    #[test]
    fn test_ranking_equal_power_and_health() {
        // Test ranking when both power and health are exactly the same
        let (beasts, contract_address, recipient, minter) = deploy_contract();
        start_cheat_caller_address(contract_address, minter);

        // Mint first beast with power 100, health 50 (token IDs start at 76 after genesis)
        beasts.mint(recipient, 1_u8, 1_u8, 1_u8, 100_u16, 50_u16, 0, 0);
        assert(beasts.get_beast_rank(76_u256) == 1_u16, 'First beast rank 1');

        // Mint second beast with identical power and health
        beasts.mint(recipient, 1_u8, 1_u8, 2_u8, 100_u16, 50_u16, 0, 0);

        // First beast should maintain rank 1, second beast gets rank 2
        assert(beasts.get_beast_rank(76_u256) == 1_u16, 'First beast keeps rank 1');
        assert(beasts.get_beast_rank(77_u256) == 2_u16, 'Second beast gets rank 2');

        // Mint third beast with same stats
        beasts.mint(recipient, 1_u8, 1_u8, 3_u8, 100_u16, 50_u16, 0, 0);
        assert(beasts.get_beast_rank(78_u256) == 3_u16, 'Third beast gets rank 3');

        // Verify all rankings remain stable
        assert(beasts.get_beast_rank(76_u256) == 1_u16, 'First still rank 1');
        assert(beasts.get_beast_rank(77_u256) == 2_u16, 'Second still rank 2');

        stop_cheat_caller_address(contract_address);
    }
}
