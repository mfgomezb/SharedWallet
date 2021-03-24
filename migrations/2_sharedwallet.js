const Sharedwallet = artifacts.require("Sharedwallet");

module.exports = function (deployer) {
  deployer.deploy(Sharedwallet);
};
