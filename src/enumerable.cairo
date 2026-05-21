#[starknet::component]
pub mod EnumerableComponent {
    use core::num::traits::Zero;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_introspection::src5::SRC5Component::InternalTrait as SRC5InternalTrait;
    use openzeppelin_token::erc721::ERC721Component;
    use openzeppelin_token::erc721::ERC721Component::{
        ERC721Impl, InternalImpl as ERC721InternalImpl,
    };
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use super::super::interfaces::{IBEASTS_OWNER_ENUMERABLE_ID, IBeastsOwnerEnumerable};

    #[storage]
    pub struct Storage {
        pub Enumerable_owned_tokens: Map<(ContractAddress, felt252), felt252>,
        pub Enumerable_owned_tokens_index: Map<felt252, felt252>,
    }

    pub mod Errors {
        pub const OUT_OF_BOUNDS_INDEX: felt252 = 'ERC721Enum: out of bounds index';
        pub const BURN_NOT_SUPPORTED: felt252 = 'ERC721Enum: burn not supported';
    }

    #[embeddable_as(EnumerableImpl)]
    pub impl Enumerable<
        TContractState,
        +HasComponent<TContractState>,
        impl ERC721: ERC721Component::HasComponent<TContractState>,
        +ERC721Component::ERC721HooksTrait<TContractState>,
        +SRC5Component::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of IBeastsOwnerEnumerable<ComponentState<TContractState>> {
        fn token_of_owner_by_index(
            self: @ComponentState<TContractState>, owner: ContractAddress, index: u256,
        ) -> u256 {
            let erc721_component = get_dep_component!(self, ERC721);
            assert(index < erc721_component.balance_of(owner), Errors::OUT_OF_BOUNDS_INDEX);
            let index_felt: felt252 = index.try_into().unwrap();
            self.Enumerable_owned_tokens.read((owner, index_felt)).into()
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        impl ERC721: ERC721Component::HasComponent<TContractState>,
        +ERC721Component::ERC721HooksTrait<TContractState>,
        impl SRC5: SRC5Component::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>) {
            let mut src5_component = get_dep_component_mut!(ref self, SRC5);
            src5_component.register_interface(IBEASTS_OWNER_ENUMERABLE_ID);
        }

        fn before_update(
            ref self: ComponentState<TContractState>, to: ContractAddress, token_id: u256,
        ) {
            assert(!to.is_zero(), Errors::BURN_NOT_SUPPORTED);

            let erc721_component = get_dep_component!(@self, ERC721);
            let previous_owner = erc721_component._owner_of(token_id);
            let token_id_felt: felt252 = token_id.try_into().unwrap();

            if !previous_owner.is_zero() && previous_owner != to {
                self._remove_token_from_owner_enumeration(previous_owner, token_id_felt);
            }

            if previous_owner != to {
                self._add_token_to_owner_enumeration(to, token_id_felt);
            }
        }

        fn _add_token_to_owner_enumeration(
            ref self: ComponentState<TContractState>, to: ContractAddress, token_id: felt252,
        ) {
            let erc721_component = get_dep_component!(@self, ERC721);
            let len: felt252 = erc721_component.balance_of(to).try_into().unwrap();
            self.Enumerable_owned_tokens.write((to, len), token_id);
            self.Enumerable_owned_tokens_index.write(token_id, len);
        }

        fn _remove_token_from_owner_enumeration(
            ref self: ComponentState<TContractState>, from: ContractAddress, token_id: felt252,
        ) {
            let erc721_component = get_dep_component!(@self, ERC721);
            let last_token_index: felt252 = (erc721_component.balance_of(from) - 1)
                .try_into()
                .unwrap();
            let this_token_index = self.Enumerable_owned_tokens_index.read(token_id);

            if this_token_index != last_token_index {
                let last_token_id = self.Enumerable_owned_tokens.read((from, last_token_index));
                self.Enumerable_owned_tokens.write((from, this_token_index), last_token_id);
                self.Enumerable_owned_tokens_index.write(last_token_id, this_token_index);
            }

            self.Enumerable_owned_tokens.write((from, last_token_index), 0);
            self.Enumerable_owned_tokens_index.write(token_id, 0);
        }
    }
}
