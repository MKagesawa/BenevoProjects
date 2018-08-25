pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoProjects.sol";


contract TestBenevoProjects2 {
    BenevoToken bnt = BenevoToken(DeployedAddresses.BenevoToken());
    BenevoProjects project = BenevoProjects(DeployedAddresses.BenevoProjects());
    BenevoProjects donor = BenevoProjects(DeployedAddresses.BenevoProjects());
    
    /** @notice Token transfer deals with value so must be done correctly and securely */
    function testDonate(){
        uint expected = 600;
        project._createProject("Save Animals", 30000);
        uint result = project.donate(1, 600);
        Assert.equal(result, expected, "should have newBalance 600 after donation");
    }

    /** @notice When tokens are released, all currentBalance should be able to be withdrawn */
    function testReleaseDonation(){
        project._createProject("Save Animals", 30000);
        bool expectedSuccess = true;
        bool resultSuccess = donor.releaseDonation(1);
        Assert.equal(resultSuccess, expectedSuccess, "project property canWithdraw should be true now");
    }

    /** @notice When withdrawToken function is called all currentBalance should be sent to the project owner */
    function testWithdrawToken(){
        /*  After two donations made to project 1 it should have 1000 tokens.
            After 200 tokens are released and withdrawn, the project should have balance 800
            and the project owner should have 1200 toknes (1000 token unpon initialization + 200 withdrawn).
        */
        project.releaseDonation(1);
        uint expectedCurrentBalance = 0;
        uint expectedCurrentAmount = 600;
        uint resultCurrentBalance = project.withdrawToken();
        var (resultName, resultGoalAmount, resultCurrentAmount, CurrentBalance, resultOwnerAddress, 
        resultProjectAddress, canWithdraw) = project.getProject(1);
        Assert.equal(resultCurrentBalance, expectedCurrentBalance, "current balance should be 0 after withdraw");
        Assert.equal(resultCurrentAmount, expectedCurrentAmount, "current amount should be 600");
    }

    /** @notice the previous donation of 600 tokens + this 700 token donation should total 1300 tokens */
    function testDonate2(){
        uint expectedCurrentAmount = 1300;
        uint resultCurrentAmount = project.donate(1, 700);
        Assert.equal(resultCurrentAmount, expectedCurrentAmount, "should have current amount 1300 after 2 donations");
    }
}