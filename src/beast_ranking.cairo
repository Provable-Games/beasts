use starknet::storage::{
    StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry, StoragePointerReadAccess,
    StoragePointerWriteAccess,
};
use starknet::syscalls::emit_event_syscall;
use core::result::ResultTrait;
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
    ) {
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
        self.beast_token_ranks.write(token_id, insertion_rank);
        self.beast_counts.write(beast_id, current_count + 1);
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
        let mut count = 0;

        let update_count = current_rank - from_rank;
        if update_count >= 800 {
            self.beast_update_count.entry(beast_id).write(update_count - 800);
        }

        loop {
            if current_rank < from_rank {
                break;
            }

            let token_id = self.beast_species_lists.entry(beast_id).entry(current_rank).read();
            if token_id != 0 {
                // Move entry down one rank
                self.beast_species_lists.entry(beast_id).entry(current_rank + 1).write(token_id);
                self.beast_token_ranks.write(token_id, current_rank + 1);

                // Clear old position
                self.beast_species_lists.entry(beast_id).entry(current_rank).write(0);

                // Emit metadata update using syscall
                if (current_rank - from_rank) < 800 {
                    let keys = array!['MetadataUpdate'];
                    let data = array![token_id.try_into().unwrap()];
                    emit_event_syscall(keys.span(), data.span()).unwrap();
                }

                count += 1;
            }

            if current_rank == 0 {
                break;
            }
            current_rank -= 1;
        };
    }

    /// Gets the rank of a specific token (only function needed for tokenURI)
    fn get_beast_rank(state: @super::beasts_nft::ContractState, token_id: u256) -> u16 {
        // Genesis beasts (token IDs 1-75) are not part of ranking system
        if token_id <= 75 {
            return 0; // Genesis beasts have no rank
        }

        state.beast_token_ranks.read(token_id)
    }
}

#[cfg(test)]
mod tests {
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, declare, start_cheat_caller_address,
        stop_cheat_caller_address,
    };
    use starknet::ContractAddress;
    use super::super::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};

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

    #[test]
    fn test_ranking_20_shifts() {
        // Test worst case: inserting strongest beast when 20 weaker ones exist
        let (beasts, contract_address, recipient, minter) = deploy_contract();
        start_cheat_caller_address(contract_address, minter);

        // Mint 20 beasts with valid prefix/suffix combinations (token IDs start at 76 after
        // genesis)
        let mut prefix = 1_u8;
        let mut suffix = 1_u8;
        let mut count = 1_u256;

        loop {
            if prefix > 69_u8 {
                break;
            }

            loop {
                if suffix > 18_u8 {
                    break;
                }

                if count > 20_u256 {
                    break;
                }

                let power: u16 = count.try_into().unwrap();
                beasts.mint(recipient, 1_u8, prefix, suffix, power, power / 2, 0, 0);

                count += 1;
                suffix += 1;
            };

            if count > 20_u256 {
                break;
            }

            suffix = 1_u8;
            prefix += 1;
        };

        // Verify we have 75 genesis + 20 custom = 95 beasts
        assert(beasts.total_supply() == 95_u256, 'Should have 95 beasts');

        // Now mint the ultimate beast that will trigger 20 shifts
        beasts.mint(recipient, 1_u8, 69_u8, 18_u8, 65535_u16, 65535_u16, 0, 0);

        // Verify the ultimate beast got rank 1
        assert(beasts.get_beast_rank(96_u256) == 1_u16, 'Ultimate beast rank 1');

        // Verify total supply increased
        assert(beasts.total_supply() == 96_u256, 'Should have 96 beasts');

        // Verify some shifted rankings (previous strongest was token 125 with power 50)
        assert(beasts.get_beast_rank(95_u256) == 2_u16, 'Previous strongest shifted');

        stop_cheat_caller_address(contract_address);
    }
}

