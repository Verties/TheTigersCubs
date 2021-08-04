var TheBlockchainHamstersSquad = artifacts.require("./TheBlockchainHamstersSquad.sol");
module.exports = function(deployer) {
	deployer.deploy(TheBlockchainHamstersSquad, "https://thetigersguild.com/api/v1/metadata/");
}
