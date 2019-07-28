var HealthChainContract = artifacts.require('./HealthChain.sol')

module.exports = function (deployer, network, accounts) {
  const owners = [accounts[1], accounts[2], accounts[3], accounts[4], accounts[5]]

  // deployer.deploy(SimpleStorage)
  /// deployer.deploy(MultiSig, owners, 2)
  deployer.deploy(HealthChainContract, owners)
}
