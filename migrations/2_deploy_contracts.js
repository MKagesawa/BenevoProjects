var BenevoProjects = artifacts.require("BenevoProjects.sol");
var BenevoTokne    = artifacts.require("BenevoToken.sol")

module.exports = function(deployer){
    deployer.deploy(BenevoProjects)
};
