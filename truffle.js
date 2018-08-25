var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "";
module.exports = {
  //https://truffleframework.com/docs/advanced/configuration
  networks: {
    // development: {
    //   host: "127.0.0.1",
    //   port: 8545,
    //   network_id: "*",
    //   gas: 6700000
    // },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/")
      },
      network_id: "4", // Rinkeby ID 4
      gas: 6712390
     }
  }
};
