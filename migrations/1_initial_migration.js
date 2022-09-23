const League = artifacts.require("League");

module.exports = function (deployer) {
  deployer.deploy(League);
};
