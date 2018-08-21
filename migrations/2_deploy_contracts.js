var SafeMath    = artifacts.require("node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol");
var Pausable    = artifacts.require("node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol");
var Ownable    = artifacts.require("node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol");
var BenevoProjects = artifacts.require("BenevoProjects");
var BenevoToken    = artifacts.require("BenevoToken");
var Oracle = artifacts.require("Oracle");

module.exports = function(deployer){
    deployer.deploy(SafeMath);
    deployer.deploy(Pausable);
    deployer.deploy(Ownable);
    deployer.deploy(BenevoProjects);
    deployer.deploy(BenevoToken);
    deployer.deploy(Oracle);
};