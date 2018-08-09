pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoProjects.sol";

contract testBenevoProjects {

    BenevoToken bnt = BenevoToken(DeployedAddresses.BenevoToken());
    BenevoProjects project = BenevoProjects(DeployedAddresses.BenevoProjects());
    struct Project {
        uint id;
        string name;
        uint goalAmount;
        uint currentAmount;
        uint currentBalance;
        address ownerAddress;
        address projectAddress;
    }
    // 'Before hook' setups before all tests
    function beforeAll(){
    }
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
        
        Assert.equal(resultId,   expectedId,   "Project should have Id 1");
        Assert.equal(resultName, expectedName, "First Project should have name 'Save Animals'");
        Assert.equal(resultGoalAmount, expectedGoalAmount, "Project should have goal amount 30000 imals'");
        Assert.equal(resultCurrentAmount, expectedCurrentAmount, "Project should have current amount 0");
    }

    function test_CreateProject2(){
        uint expectedCurrentBalance = 0;
        address expectedOwnerAddress = this;
        address expectedProjectAddress = address(ripemd160(abi.encodePacked(this)));
        var (resultId, resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
        resultProjectAddress) = project._createProject("Save Animals", 30000);

        Assert.equal(resultCurrentBalance, expectedCurrentBalance, "Project should have current balance 0");
        Assert.equal(resultOwnerAddress, expectedOwnerAddress, "Project should have owner address of the sender");
        Assert.equal(resultProjectAddress, expectedProjectAddress, "Project should have project address the hash of the address of the sender");
    }

    /** @notice when a project is created, it is important all properties are correct and
        all parameters fired are correct. The hashing function also must output correctly.
    */

    function testDonate(){
        
    }

    /** @notice when a project is created, it is important all properties are correct and
        all parameters fired are correct. The hashing function also must output correctly.
    */

    function testReleaseDonation(){
        
    }

    /** @notice when a project is created, it is important all properties are correct and
        all parameters fired are correct. The hashing function also must output correctly.
    */

    function test_Cr(){
        
    }

    /** @notice when a project is created, it is important all properties are correct and
        all parameters fired are correct. The hashing function also must output correctly.
    */

    function test_C(){
        
    }
}