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

    /** @notice Token transfer deals with value so must be done correctly and securely.
        First donating 4000 then 6000 should total 10000
    */

    function testDonate(){
        uint expected = 10000;
        project.donate(1, 4000);
        Assert.equal(project.donate(1, 6000), expected, "should have newBalance 10000 after two donations");
    }

    /** @notice When tokens are released, it should be able to be withdrawn
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