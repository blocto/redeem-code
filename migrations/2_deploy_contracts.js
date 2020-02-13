const RedeemCode = artifacts.require("RedeemCode");

module.exports = function(deployer) {
  deployer.deploy(RedeemCode);
};
