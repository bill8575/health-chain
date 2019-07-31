While the current implementation of "Health-chain" is not handling gas or eth, I have very few security measures. I would discuss a couple here that I would have considered if and when "Health-chain" was to be implemented as a production system.

Common Attacks

Re-entrancy Attacks:

Make sure the handling of gas or eth transfer are settled after the fulfilling of conditions on which the transaction depends. Rapid calling of the contract function could have the fund transfer code called numerous times while the supposely coupled set condition was never reached. This could create a draining of "funds" when rogue contracts manipulating the gas calculation were used as the system gets dragged into a recursive loop.

Denial of Services:

Attackers could discover the reversion conditions established by the vulerable smart contract. Rogue contracts can be used to perpetually cause the reversion by breaking the threshold of these requirements. Set up an eth and/or looping limits to prevent the system from overtaken by DoS attackers.

Contract writing best practice, preventing attacks

Circuit Breaker:

// Use code similar to the snippet below
//   when attack was discovered, pause all function
//   by setting contractPaused = true;
//   via calling the circuitBreaker() function

bool public contractPaused = false;

function circuitBreaker() public onlyOwner 
{ // onlyOwner can call
  	if (contractPaused == false) { 
  		contractPaused = true; 
  	}
    else { contractPaused = false; }

}

// If the contract is paused, stop the modified function
// Attach this modifier to all public functions
modifier checkIfPaused() {
    require(contractPaused == false);
    _;
}