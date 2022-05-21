require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

const { API_URL, PRIVATE_KEY } = process.env;
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.14",
    settings: {
      optimizer: {
        enabled: true,
      }
    }
  },
  paths: {
    artifacts: './src/artifacts'
  },
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {},
    rinkeby: {
      url: API_URL,
      allowUnlimitedContractSize: true,
      accounts: [`0x${PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: {
      rinkeby : "SF48CCUR235F3S3J98WIF85PEVKR1JP5HV"
    }
  }
};
