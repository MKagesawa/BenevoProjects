var BenevoProjects = artifacts.require("BenevoProjects.sol");
var BenevoToken    = artifacts.require("BenevoToken.sol");
var SHA1           = artifacts.require("SHA1.sol");

module.exports = function(deployer){
    deployer.deploy(BenevoProjects);
    deployer.deploy(BenevoToken);
    deployer.deploy(SHA1);
};
