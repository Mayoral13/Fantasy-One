const League = artifacts.require("League");
const Baller = artifacts.require("Baller");
const Fan = artifacts.require("Fan");
const Squad = artifacts.require("Squad");

module.exports = async (deployer) => {
  await deployer.deploy(League);
  await deployer.deploy(Baller);
  await deployer.deploy(Fan);
  const fanaddr = Fan.address;
  await deployer.deploy(Squad,fanaddr);
 
};
