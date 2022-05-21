const { ethers, upgrades } = require('hardhat');

async function main() {

  const firstNFT = await ethers.getContractFactory("FirstNFT");
  const firstNFTContract = await upgrades.deployProxy(firstNFT, [10000000], { initializer: 'initialize'});
  console.log("FirstNFT deployed to:", firstNFTContract.address);

  const secondNFT = await ethers.getContractFactory("SecondNFT");
  const secondNFTContract = await upgrades.deployProxy(secondNFT, [], { initializer: 'initialize'});
  console.log("SecondNFT deployed to:", secondNFTContract.address);

}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});