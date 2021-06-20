
const Tokens = artifacts.require("Contents");

module.exports = async function(deployer) {
  await deployer.deploy(Tokens);
};
