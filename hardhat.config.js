require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const KEY = process.env.KEY;
const URL = process.env.URL;

module.exports = {
  solidity: '0.8.4',
  networks: {
    goerli: {
      url: URL,
      accounts: [KEY],
    },
  },
};