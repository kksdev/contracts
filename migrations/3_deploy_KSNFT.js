const KSNFT = artifacts.require("KSNFT");
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

module.exports = async function (deployer) {
  const nft = await deployProxy(KSNFT, ["ipfs:/ksnft", 65535], {deployer});
};
