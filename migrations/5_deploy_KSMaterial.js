const KSMaterial = artifacts.require("KSMaterial");
const NFTMarket = artifacts.require("NFTMarket");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

module.exports = async function (deployer, network, accounts) {
  const material = await deployProxy(KSMaterial, ["ipfs:/ksmaterial"], {deployer});
  const market = await NFTMarket.deployed();
  await market.setTokenTax(material.address,500);
};
