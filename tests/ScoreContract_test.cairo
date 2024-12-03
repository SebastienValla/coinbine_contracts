// use snforge_std::{
//     declare, ContractClassTrait, DeclareResultTrait, Env, Account, felt252, u256,
// };
// use score_contract::IScoreContractDispatcher;
// use core::starknet::get_caller_address;

// fn deploy_score_contract() -> IScoreContractDispatcher {
//     let contract = declare("score_contract").unwrap().contract_class();
//     let (contract_address, _) = contract
//         .deploy()
//         .expect("Failed to deploy ScoreContract");

//     IScoreContractDispatcher { contract_address }
// }

// #[test]
// fn test_score_contract() {
  
 

//     // Deploy the contract
//     let score_contract = deploy_score_contract();

//     // Get the initial owner address
//     let owner = score_contract.get_owner().call().unwrap();

//     // Verify that the owner is the deployer
//     assert_eq!(
//         owner,
//         env.get_caller_address(),
//         "The owner should be the deployer"
//     );

//     // Define an ID and a score value
//     let id = "123456";
//     let value = u256::from(1000);

//     // Update the score
//     score_contract.set_score(id, value).invoke().unwrap();

//     // Retrieve the score
//     let score = score_contract.get_score(id).call().unwrap();

//     // Verify the score
//     assert_eq!(score, value, "The score should be 10");

//     // Mark a user as a cheater (by the owner)
//     score_contract.set_cheater(id, true).invoke().unwrap();

//     // Verify that the user is marked as a cheater
//     let is_cheater = score_contract.get_cheater(id).call().unwrap();
//     assert!(is_cheater, "The user should be marked as a cheater");

//     // Attempt to mark a user as not a cheater by a non-owner
//     let non_owner_account = Account::new(env);
//     let non_owner_contract = score_contract.with_account(&non_owner_account);

//     let result = non_owner_contract.set_cheater(id, false).invoke();

//     // Verify that the call fails with the expected error message
//     assert!(
//         result.is_err(),
//         "The call should fail when called by a non-owner"
//     );

//     if let Err(e) = result {
//         assert_eq!(
//             e.to_string(),
//             "Only admin can set cheater status",
//             "Expected error: Only admin can set cheater status"
//         );
//     }

//     // Change the owner
//     let new_owner_account = Account::new(env);
//     let new_owner_address = new_owner_account.address();

//     score_contract
//         .set_owner(new_owner_address)
//         .invoke()
//         .unwrap();

//     // Verify that the owner has changed
//     let new_owner = score_contract.get_owner().call().unwrap();
//     assert_eq!(
//         new_owner, new_owner_address,
//         "The owner should be updated"
//     );

//     // Attempt the previous owner to mark a user as not a cheater
//     let result = score_contract.set_cheater(id, false).invoke();

//     assert!(
//         result.is_err(),
//         "The previous owner should not be able to call set_cheater"
//     );

//     // The new owner marks the user as not a cheater
//     let new_owner_contract = score_contract.with_account(&new_owner_account);
//     new_owner_contract.set_cheater(id, false).invoke().unwrap();

//     let is_cheater_after = new_owner_contract.get_cheater(id).call().unwrap();
//     assert!(
//         !is_cheater_after,
//         "The cheater flag should be set to false"
//     );
// }
