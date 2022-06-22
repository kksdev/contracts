const KSMaterial = artifacts.require("KSMaterial");
const KSEquip = artifacts.require("KSEquip");
const KSToken = artifacts.require("KSToken");
const KSNFT = artifacts.require("KSNFT");

const Factory =  artifacts.require("Factory");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const signer = '0x14D4bf29EBB5F4E04e23a0C21FA2Eefe50dc03Cc'

module.exports = async function (deployer, network, accounts) {
  const factory = await deployProxy(Factory, [KSMaterial.address, KSEquip.address, KSNFT.address, KSToken.address, signer, accounts[0]], {deployer});
 
  const eqtuip = await KSEquip.deployed();
  const nft = await KSNFT.deployed();
  const material = await KSMaterial.deployed();
  const token = await KSToken.deployed();

  await eqtuip.setOperator(factory.address);
  await nft.setFactoryAddress(factory.address);
  await material.setOperator(factory.address);
  await token.approve(factory.address, web3.utils.toWei('999999999', 'ether'),{from:accounts[0]});
  await factory.setStone(210001,[2,5,15,25,50]);

  console.log("material address:", KSMaterial.address);
  console.log("equip address:", KSEquip.address);
  console.log("factory address:", factory.address);
}
