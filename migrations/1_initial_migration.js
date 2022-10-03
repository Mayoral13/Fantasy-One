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
  await deployer.deploy(player,squadaddr);
  console.log("Fan Address is: ",fanaddr);
  console.log("Squad Address is: ",squadaddr);
  console.log("League Address is: ",League.address);
  console.log("Market Address is: ",player.address);

  /*
Fan Address is:  0x8517b9d207dBC306453ca90D7C3dA01DfF157f76
Squad Address is:  0xE88C866C6e7a69d6DB6292481dE0de8D90296aAd
League Address is:  0xAF88564e239e3Df6e0B6249987189feD7CfDD2d7
Market Address is:  0xde9fB1f9D2B799e1aeC917060F6b75Bbf7D051B2
  */
};
