# health-chain
Ethereum DAPP Contracts (written in Solidity)

# Description
A "Blockchain" clinic with members are care providers(doctors) and patients. There are also admins (2 were preset). There are some functions that can only be called by admins such as deleteDoctor().

- Any member can enrol as a doctor
- Only admins can delete a doctor
- Any member can register with a doctor 
- Registration creates a registry struct with a MRN generated
- MRN is a global counter tracking number of patient-doctor registration mappings 
- Only doctor can submit a MedicalRecord for its own patients which means there exists a patient-doctor registration mapping
- MedicalRecord is created with _verified attribute set False
- A Patient is identified by a MRN in the MedicalRecord struct

# Tools required to run 
1. Node and npm installed 
2. truffle installed
3. A local Ethereum development server such as ganache
4. Metamask is added to Chrome 

# How to run
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

- Finally, to complete the rest of the tests
- review the test script, health-chain/test/healthchainTest.js
- run "truffle test"

