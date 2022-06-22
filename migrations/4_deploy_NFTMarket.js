const NFTMarket = artifacts.require("NFTMarket");
const KSToken = artifacts.require("KSToken");
const KSNFT = artifacts.require("KSNFT");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

module.exports = async function (deployer, network, accounts) {
  const market = await deployProxy(NFTMarket, [accounts[0]], {deployer});
  const gameAdmin = await market.GAME_ADMIN();
  await market.grantRole(gameAdmin, accounts[0]);
  await market.setTokenTax(KSNFT.address,500);
  console.log("token address:", KSToken.address);
  console.log("nft address:", KSNFT.address);
  console.log("market address:", market.address);
};
