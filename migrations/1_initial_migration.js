const League = artifacts.require("League");
const Fan = artifacts.require("Fan");
const Squad = artifacts.require("Squad");
const player = artifacts.require("PlayerMarketplace");
//const POTWNFT = artifacts.require("POTWNFT");
//const POTWMarket = artifacts.require("POTWMarket");

module.exports = async (deployer) => {
  await deployer.deploy(Fan);
  const fanaddr = Fan.address;
  await deployer.deploy(League,fanaddr);
  await deployer.deploy(Squad,fanaddr);
  const squadaddr = Squad.address;
  await deployer.deploy(player,squadaddr);
  //await deployer.deploy(POTWMarket,fanaddr);
  //const marketaddr = POTWMarket.address;
  //await deployer.deploy(POTWNFT,marketaddr);
  //console.log("POTW NFT Address is: ",POTWNFT.address);
  //console.log("POTW Market Address is: ",POTWMarket.address);
  console.log("Fan Address is: ",fanaddr);
  console.log("Squad Address is: ",squadaddr);
  console.log("League Address is: ",League.address);
  console.log("Market Address is: ",player.address);

};
