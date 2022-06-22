var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "";
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
     },
    // rinkeby: {
    //  provider: () => new HDWalletProvider("", `https://rinkeby.infura.io/v3/{token}`),
    //   network_id: 4,       // Ropsten's id
    //   gas: 5500000,        // Ropsten has a lower block limit than mainnet
    //  confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    //  timeoutBlocks: 10000,  // # of blocks before a deployment times out  (minimum/default: 50)
    //  networkCheckTimeout: 1000000000,
    //  skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    // },
    bsctestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-1-s3.binance.org:8545/`),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 10000,
      gas: 10000000,//8000000,
      skipDryRun: true,
      networkCheckTimeout: 100000,
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.10",    // Fetch exact version from solc-bin (default: truffle's version)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
      }
    }
  }
};