const KSToken = artifacts.require("KSToken");

module.exports = function (deployer) {
  deployer.deploy(KSToken, "KSToken", "KSToken", 1000000000);
};
