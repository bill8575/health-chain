var HealthChainContract = artifacts.require('./HealthChain.sol')

module.exports = function (deployer, network, accounts) {
  const starterDoctors = [accounts[1], accounts[2], accounts[3]]
  const admins = [accounts[0], accounts[1]]

  // deployer.deploy(SimpleStorage)
  /// deployer.deploy(MultiSig, owners, 2)
  deployer.deploy(HealthChainContract, starterDoctors, admins)
}
