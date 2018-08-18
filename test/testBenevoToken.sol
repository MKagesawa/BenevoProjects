pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoToken.sol";

contract testBenevoToken {

    function testInitialBalances(){
        BenevoToken bnt = new BenevoToken();
        uint expected = 1000;
        Assert.equal(bnt.balanceOf(this), expected, "Initialized account should have 1000 token");
    }

    function testTransfer(){
        BenevoToken user1 = new BenevoToken();
        BenevoToken user2 = BenevoToken(DeployedAddresses.BenevoToken());
        uint expectedUser1 = 500;
        uint expectedUser2 = 1500;
        bool expectedSuccess = true;
        user1.transfer(user2, 500);
        //Assert.equal(success, expectedSuccess, "transfer should succeed")
        Assert.equal(user1.balanceOf(this), expectedUser1, "User1 should have 500 tokens");
        Assert.equal(user2.balanceOf(this), expectedUser2, "User2 should have 1500 tokens");
    }

    function testTransferFrom(){
        BenevoToken user1 = new BenevoToken();
        BenevoToken user2 = BenevoToken(DeployedAddresses.BenevoToken());
        uint expectedUser1 = 600;
        uint expectedUser2 = 1400;
        bool expectedSuccess = true;
        //user1.approve(user2, 400);
        user1.transferFrom(user1, user2, 400);
        //Assert.equal(success, expectedSuccess, "transfer should succeed")
        Assert.equal(user1.balanceOf(this), expectedUser1, "User1 should have 500 tokens");
        Assert.equal(user2.balanceOf(this), expectedUser2, "User2 should have 1500 tokens");
    }   
}