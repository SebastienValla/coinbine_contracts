#[starknet::interface]
trait IScoreContract<TContractState> {
    fn setScore(ref self: TContractState, id: felt252, value: u256);
    fn getScore(self: @TContractState, id: felt252) -> u256;
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
    #[abi(embed_v0)]
    impl ScoreContractImpl of super::IScoreContract<ContractState> {
  
        fn setScore(ref self: ContractState, id: felt252, value: u256) {
            self.id_to_value.entry(id).write(value);
        }
       
        fn getScore(self: @ContractState, id: felt252) -> u256 {
            self.id_to_value.entry(id).read()
        }
    }
}
