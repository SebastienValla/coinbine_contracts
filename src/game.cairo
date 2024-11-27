%lang starknet

@contract
mod ScoreContract {
    // Necessary imports
    use starknet::ContractAddress;
    use starknet::context::get_caller_address;
    use starknet::storage::Mapping;
    use core::array::ArrayTrait;  // For using array methods
    use core::integer::u256;

    #[storage]
    struct Storage {
        scores: Mapping::<felt252, u256>,  // Mapping to store scores
        cheaters: Mapping::<felt252, bool>,  // Mapping to store cheater flags
        admin: ContractAddress,  // Admin address
    }

    #[constructor]
    fn constructor(ref self: Storage) {
        // Set the caller as the admin during contract deployment
        let caller: ContractAddress = get_caller_address();
        self.admin.write(caller);
    }

    #[external]
    fn register_score(ref self: Storage, id: felt252, increment: u256) {
        // Read the current score for the given ID
        let current_score = match self.scores.get(id) {
            Option::Some(score) => score,
            Option::None => u256::from(0),  // Default to 0 if no score exists
        };
        // Calculate the new score
        let new_score = current_score + increment;
        // Save the updated score
        self.scores.insert(id, new_score);
    }

    // New function to register scores in batch
    #[external]
    fn register_scores_batch(ref self: Storage, ids_len: usize, ids: Span<felt252>, increments_len: usize, increments: Span<u256>) {
        // Ensure both arrays have the same length
        if ids_len != increments_len {
            panic("The lengths of ids and increments arrays must be equal");
        }

        // Iterate over the ids and increments arrays
        for i in 0..ids_len {
            let id = ids.at(i);
            let increment = increments.at(i);

            // Read the current score for the ID
            let current_score = match self.scores.get(id) {
                Option::Some(score) => score,
                Option::None => u256::from(0),  // Default to 0 if no score exists
            };
            // Calculate the new score
            let new_score = current_score + increment;
            // Save the updated score
            self.scores.insert(id, new_score);
        }
    }

    #[external]
    fn set_cheater(ref self: Storage, id: felt252, cheater_flag: bool) {
        // Get the caller's address
        let caller: ContractAddress = get_caller_address();
        // Read the admin's address
        let admin_address = self.admin.read();

        // Ensure the caller is the admin
        if caller != admin_address {
            panic("Only the admin can call this function");
        }

        // Set the cheater flag for the given ID
        self.cheaters.insert(id, cheater_flag);
    }
}
