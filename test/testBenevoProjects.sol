pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoProjects.sol";


contract TestBenevoProjects {

    BenevoToken bnt = BenevoToken(DeployedAddresses.BenevoToken());
    BenevoProjects project = BenevoProjects(DeployedAddresses.BenevoProjects());
    
    /** @notice when a project is created, it is important all properties are correct. 
        The hashing function also must output correctly.
    */

    function test_CreateProject1(){
        uint expectedId = 1;
        var expectedName = "Save Animals";
        uint expectedGoalAmount = 30000;
        uint expectedCurrentAmount = 0;
        var (resultId, resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
        resultProjectAddress) = project._createProject("Save Animals", 30000);
        
        Assert.equal(resultId,   expectedId,   "should have Id 1");
        Assert.equal(resultName, expectedName, "should have name 'Save Animals'");
        Assert.equal(resultGoalAmount, expectedGoalAmount, "should have goal amount 30000 imals'");
        Assert.equal(resultCurrentAmount, expectedCurrentAmount, "should have current amount 0");
    }

    function test_CreateProject2(){
        uint expectedCurrentBalance = 0;
        address expectedOwnerAddress = this;
        address expectedProjectAddress = address(ripemd160(abi.encodePacked(this)));
        var (resultId, resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
        resultProjectAddress) = project._createProject("Save Animals", 30000);

        Assert.equal(resultCurrentBalance, expectedCurrentBalance, "should have current balance 0");
        Assert.equal(resultOwnerAddress, expectedOwnerAddress, "should have owner address of the sender");
        Assert.equal(resultProjectAddress, expectedProjectAddress, "should have project address the hash of the address of the sender");
    }
}