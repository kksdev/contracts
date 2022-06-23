const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const Factory = artifacts.require("Factory");

module.exports = async function (deployer) {
  const factory = await Factory.deployed();

  await upgradeProxy(factory.address, Factory, { deployer });
};
