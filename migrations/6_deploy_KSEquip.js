const KSEquip = artifacts.require("KSEquip");
const NFTMarket = artifacts.require("NFTMarket");
const KSNFT = artifacts.require("KSNFT");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const signer = '0x14D4bf29EBB5F4E04e23a0C21FA2Eefe50dc03Cc'
module.exports = async function (deployer, network, accounts) {
  const equip = await deployProxy(KSEquip, [signer], {deployer});
  const market = await NFTMarket.deployed();
  await market.setTokenTax(equip.address,500);
  const nft = await KSNFT.deployed();
  nft.setKSEquipAddress(equip.address);
};
