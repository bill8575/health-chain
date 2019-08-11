# health-chain
Ethereum DAPP Contracts (written in Solidity)

# Description
A "Blockchain" clinic with members being care providers(doctors) and patients. There are also admins (2 have been preset when deploying locally). Some functions can only be called by admins such as deleting a doctor.

- Any member can enrol as a doctor
- Only admins can delete doctors
- Any member can register with a doctor 
- Registration creates a registry struct entry with a MRN generated
- MRN is a global counter tracking number of the patient-doctor registration mappings 
- Only doctor can submit a Medical Record for its own patients which means there must exist a patient-doctor registration mapping
- Medical Record is created with the "verified" attribute set False
- A Patient is identified by a MRN in the Medical Record struct
- The "verified" flag must and can only be set (to true) by the patient represented by the MRN in the Medical Record 

# Tools required to run 
1. Node and npm installed 
2. truffle installed
3. A local Ethereum development server such as ganache
4. Metamask is added to Chrome 

# How to run the UI client
(The UI demonstrates the enrolling of a doctor. You will see the added doctor and its doctorId included in the list of doctors)
- Run the local Ethereum development server, I use ganache-cli
- From a terminal/command prompt, fire up ganache-cli
- git clone https://github.com/bill8575/health-chain.git 
- Check truffle-config.js to ensure your network setting 
- I use below for my local development server  
    development: {
      host: '127.0.0.1',
      port: '8545',
      network_id: '*'
    },
- On another terminal, cd into the local health-chain folder
- from health-chain$ 
- (npm install)
- (npm init)
- truffle migrate --reset
- cd into the "client" folder
- npm start 
(Install npm if you have not done so already)
(You may need to do "npm init" from the current folder)
- Assume node is properly set up in this "client" folder
- Will see similar to ... 
Compiled successfully!

You can now view client in the browser.

  Local:            http://localhost:3000/
  On Your Network:  http://10.97.84.26:3000/

Note that the development build is not optimized.
To create a production build, use yarn build.
- Go to Chrome and fire up http://localhost:3000/
- Make sure MetaMask is set to the local development server 
- Follow the included video to run the UI
(You should be running the UI as accounts[0] as accounts[1] through accounts[3] have already been added by the contract's constructor)
- Finally, to complete the rest of the tests
(Only the enrolDoctor, getDoctors, getTotalDoctors solidity functions are included in this UI test, more functionalities are tested by the healthchainTest script in the test/ folder.)
- review the test script, health-chain/test/healthchainTest.js
- run "truffle test"

# Design pattern 
See design_pattern_decisions.md 

# Security Measure / Avoid Common Attacks
See avoiding_common_attacks.md 

# Use of Library (inherits from another contract) in a contract 
I did not use library in the health-chain contract. Created a LibraryDemo truffle project and contract (LibraryDemo.sol) to demonstrate the use of a simple custom Library (TestLib.sol)

https://github.com/bill8575/LibraryDemo.git

To test the using of library TestLib.sol, a test contract is created in the test/ folder. To run the test script, do "truffle test"

# Deploying to Rinkeby 

3_deploy_healthchain_contract.js
================================

   Deploying 'HealthChain'
   -----------------------
   > transaction hash:    0x4b248a2dd0c6343c3ab6f8f2bf5f51d2694910e55f1df4cbba61aa4825e991d3
   > Blocks: 0            Seconds: 9
   > contract address:    0x582B658394e00EcEF7024777D918bfd2f9bB9430
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   > block number:        4813736
   > block timestamp:     1564335962
   > account:             0x56c413b9DF155DB41f48cDDbb68e7e3Ebd12a2fc
   > balance:             2.918861362
   > gas used:            988816
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.01977632 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.01977632 ETH

   
   20190808

   First Name Email Address Link to Project Code  Link to Project Demo  Group
