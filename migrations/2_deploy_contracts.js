var SafeMath    = artifacts.require("node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol");
var Pausable    = artifacts.require("node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol");
var Ownable    = artifacts.require("node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol");
var BenevoProjects = artifacts.require("BenevoProjects");
var _BenevoToken    = artifacts.require("_BenevoToken");

module.exports = function(deployer){
    deployer.deploy(SafeMath);
    deployer.deploy(Pausable);
    deployer.deploy(Ownable);
    deployer.deploy(BenevoProjects);
    deployer.deploy(_BenevoToken);
};