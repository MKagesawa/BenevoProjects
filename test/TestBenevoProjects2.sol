pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoProjects.sol";


contract TestBenevoProjects2 {
    BenevoToken bnt = BenevoToken(DeployedAddresses.BenevoToken());
    BenevoProjects project = BenevoProjects(DeployedAddresses.BenevoProjects());

    /** @notice When tokens are released, all currentBalance should be able to be withdrawn
    */

    function testReleaseDonation(){
        BenevoProjects donor = BenevoProjects(DeployedAddresses.BenevoProjects());
        project._createProject("Save Animals", 30000);
        donor.donate(1, 600);
        bool expectedSuccess = true;
        bool resultSuccess = donor.releaseDonation(1, 200);
        Assert.equal(resultSuccess, expectedSuccess, "project property canWithdraw should be true now");
    }

    /** @notice When withdrawToken function is called all currentBalance should be sent to the project owner 
    */

    function testWithdrawToken(){
        /*  After two donations made to project 1 it should have 1000 tokens.
            After 200 tokens are released and withdrawn, the project should have balance 800
            and the project owner should have 1200 toknes (1000 token unpon initialization + 200 withdrawn).
        */
        BenevoProjects donor = BenevoProjects(DeployedAddresses.BenevoProjects());
        donor.releaseDonation(1, 500);
        uint expectedCurrentBalance = 0;
        uint expectedCurrentAmount = 600;
        project.withdrawToken;
        var (resultName, resultGoalAmount, resultCurrentAmount, resultCurrentBalance, resultOwnerAddress, 
        resultProjectAddress, canWithdraw) = project.getProject(1);
        Assert.equal(resultCurrentBalance, expectedCurrentBalance, "current balance should be 0 after withdraw");
        Assert.equal(resultCurrentAmount, expectedCurrentAmount, "current amount should be 600");
    }

    function testDonate2(){
        uint expectedCurrentAmount = 1300;
        uint resultCurrentAmount = project.donate(1, 700);
        Assert.equal(resultCurrentAmount, expectedCurrentAmount, "should have current amount 1300 after 2 donations");
    }
}