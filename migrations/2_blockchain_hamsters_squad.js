var BlockchainHamstersSquad = artifacts.require("./BlockchainHamstersSquad.sol");
module.exports = function(deployer) {
	deployer.deploy(BlockchainHamstersSquad, "https://thetigersguild.com/api/v1/metadata/");
}
