
const hre = require("hardhat");

async function main() {
  const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners();
  const CB = await hre.ethers.getContractFactory("ChainBattles");
  const ChBt = await CB.deploy();
  await ChBt.deployed();
  console.log("Deployed to:", ChBt.address);

  const addresses = [owner.address, tipper.address, ChBt.address];
  
  const memos = await ChBt.random(100);
  console.log("Random Number : ",memos);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
