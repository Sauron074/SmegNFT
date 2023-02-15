require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: '0.8.17',
  networks: {
    goerli: {
      url: "NODE_URL",
      accounts: ["PRIVATE_KEY_WALLET"],

      
    },
  },
};
