use core::starknet::ContractAddress;

#[starknet::interface]
trait IScoreContract<TContractState> {
    fn setScore(ref self: TContractState, id: felt252, value: u256);
    fn getScore(self: @TContractState, id: felt252) -> u256;
    fn setCheater(ref self: TContractState, id: felt252, isCheater: bool);
    fn getCheater(self: @TContractState, id: felt252) -> bool;
    fn getOwner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod ScoreContract {
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map,
    };
    use core::starknet::ContractAddress;
    use core::starknet::get_caller_address;

    #[storage]
    struct Storage {
        id_to_value: Map<felt252, u256>,
        id_to_bool: Map<felt252, bool>,
        admin: ContractAddress,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, admin : ContractAddress
    ) {
        self.admin.write(admin);
    }

    #[abi(embed_v0)]
    impl ScoreContractImpl of super::IScoreContract<ContractState> {
  
        fn setScore(ref self: ContractState, id: felt252, value: u256) {  
            let current_score = self.id_to_value.entry(id).read();
            self.id_to_value.entry(id).write(current_score + value)
        }
       
        fn getScore(self: @ContractState, id: felt252) -> u256 {
            self.id_to_value.entry(id).read()
        }

        fn getOwner(self: @ContractState) -> ContractAddress {
            self.admin.read()
        }

        fn setCheater(ref self: ContractState, id: felt252, isCheater: bool) {
            let caller_address = get_caller_address();
            let admin_address = self.admin.read();
            assert(caller_address == admin_address, 'Only admin');
            self.id_to_bool.entry(id).write(isCheater)
        }
        fn getCheater(self: @ContractState, id: felt252) -> bool{
            self.id_to_bool.entry(id).read()
        }
    }

    #[generate_trait]
    pub impl InternalImpl of InternalTrait {
        fn setOwner(ref self: ContractState, newOwner: ContractAddress) {
            let caller: ContractAddress = get_caller_address();
            assert!(caller == self.getOwner(), "Only the owner can set ownership");
            self.admin.write(newOwner);
        }
    }
}
