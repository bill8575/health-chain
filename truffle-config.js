const path = require('path')

const infuraURL = 'https://rinkeby.infura.io/v3/f96cee9283f045c98dd6b11181a843e0'

const HDWalletProvider = require('truffle-hdwallet-provider')
// const infuraKey = 'fj4jll3k.....'
const infuraKey = 'f96cee9283f045c98dd6b11181a843e0'
//
const fs = require('fs')
// const mnemonic = fs.readFileSync('.secret').toString().trim()

var HDWallet = require('truffle-hdwallet-provider')

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, 'client/src/contracts'),
  networks: {
    development: {
      host: '127.0.0.1',
      port: '8545',
      network_id: '*'
    },

    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, infuraURL),
      network_id: 4, // Rinkeby's network id
      gas: 5500000
    }

  }
}
