pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoToken.sol";

contract TestBenevoToken {

    function testInitialBalances(){
        BenevoToken bnt = new BenevoToken();
        uint expected = 1000;
        Assert.equal(bnt.balanceOf(this), expected, "Initialized account should have 1000 token");
    }

    function testTransfer(){
        BenevoToken user1 = new BenevoToken();
        BenevoToken user2 = new BenevoToken();
        uint expectedUser1 = 500;
        uint expectedUser2 = 1500;
        bool expectedSuccess = true;
        bool success = user1.transfer(user2, 500);
        Assert.equal(success, expectedSuccess, "transfer should succeed");
        Assert.equal(user1.balanceOf(this), expectedUser1, "User1 should have 500 tokens");
    }

    //Mining difficulty initially should be 1
    function testMiningDifficulty(){
        BenevoToken bnt = new BenevoToken();
        uint expected = 1;
        uint result = bnt.getMiningDifficulty();
        Assert.equal(result, expected, "Initial mining difficulty should be 1");
    }

    //Mining target initially should equal the maximum target (start with a block easy to solve
    // and gradually become more difficult to solve as more miners join)
    function testMiningTarget(){
        BenevoToken bnt = new BenevoToken();
        uint expected = 2**224;
        uint result = bnt.getMiningTarget();
        Assert.equal(result, expected, "Initial mining target should be 2**224");
    }

    //Total supply should equal to 720000000000000
    function testTotalSupply(){
        BenevoToken bnt = new BenevoToken();
        uint expected = 720000000000000;
        uint result = bnt.totalSupply();
        Assert.equal(result, expected, "Initial total supply should be 720000000000000");
    }

    //Approval should return true
    function testApprove(){
        BenevoToken user1 = new BenevoToken();
        BenevoToken user2 = new BenevoToken();
        bool expectedSuccess = true;
        bool resultSuccess = user1.approve(user2, 50);
        Assert.equal(resultSuccess, expectedSuccess, "User1 approving user2 spending 50 tokens should return true");
    }

    //should return address of the caller
    function testGetAddress(){
        BenevoToken bnt = new BenevoToken();
        address expectedAddress = this;
        address resultAddress = bnt.getAddress();
        Assert.equal(resultAddress, expectedAddress, "getAddress function should return the address of the caller ");
    }

    //Mining difficulty initially should be 1
    function testGetMiningReward(){
        BenevoToken bnt = new BenevoToken();
        uint expected = 5000000000;
        uint result = bnt.getMiningReward();
        Assert.equal(result, expected, "Mining Reward should be 5000000000 in the original era");
    }
}
