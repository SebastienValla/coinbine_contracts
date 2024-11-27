#[starknet::interface]
trait IScoreContract<TContractState> {
    fn set(ref self: TContractState, id: felt252, value: u256);
    fn get(self: @TContractState, id: felt252) -> u256;
}

#[starknet::contract]
mod ScoreContract {
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map,
    };

    #[storage]
    struct Storage {
        id_to_value: Map<felt252, u256>,
    }

    impl IdValueMapImpl of super::IScoreContract<ContractState> {
      
        fn set(ref self: ContractState, id: felt252, value: u256) {
            self.id_to_value.entry(id).write(value);
        }

        fn get(self: @ContractState, id: felt252) -> u256 {
            self.id_to_value.entry(id).read()
        }
    }
}
