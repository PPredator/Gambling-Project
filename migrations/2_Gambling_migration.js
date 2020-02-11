const Gambling = artifacts.require("Gambling");

module.exports = function(deployer) {
  deployer.deploy(Gambling);
};
