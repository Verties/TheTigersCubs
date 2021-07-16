var TheTigersGuild = artifacts.require("./TheTigersGuild.sol");
module.exports = function(deployer) {
	deployer.deploy(TheTigersGuild, "https://thetigersguild.com/api/v1/metadata/");
}
