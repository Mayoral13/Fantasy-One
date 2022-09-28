const League = artifacts.require("League");
const Fan = artifacts.require("Fan");
const Squad = artifacts.require("Squad");
const player = artifacts.require("PlayerMarketplace");

module.exports = async (deployer) => {
  await deployer.deploy(Fan);
  const fanaddr = Fan.address;
  await deployer.deploy(League,fanaddr);
  await deployer.deploy(Squad,fanaddr);
  const squadaddr = Squad.address;
  await deployer.deploy(player,squadaddr)
 
};
