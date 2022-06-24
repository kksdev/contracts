const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const KSNFT = artifacts.require("KSNFT");

module.exports = async function (deployer) {
  const nft = await KSNFT.deployed();

  await upgradeProxy(nft.address, KSNFT, { deployer });
};
