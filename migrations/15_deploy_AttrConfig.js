const AttrConfig =  artifacts.require("AttrConfig");
const KSNFT = artifacts.require("KSNFT");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(AttrConfig);
  
  const attr = await AttrConfig.deployed();
  const nft = await KSNFT.deployed();
  
  nft.setAttrConfigAddress(attr.address);
  console.log("attrConfig address:", attr.address);
}
