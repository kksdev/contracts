const HeroConfig =  artifacts.require("HeroConfig");
const Factory = artifacts.require("Factory");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(HeroConfig);
  
  const hero = await HeroConfig.deployed();
  const factory = await Factory.deployed();

  await factory.setHeroConfigAddress(hero.address);
  console.log("heroConfig address:", hero.address);
}
