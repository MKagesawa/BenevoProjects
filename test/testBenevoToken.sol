pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BenevoToken.sol";

contract TestBenevoToken {
    
    /** @notice Some mining related functions in BenevoToken cannot be tested through solidity tests. 
                Basic functions of ERC20 tokens such as transfer are throughly tested
    */

    /** @notice All initialized accounts should start with 1000 tokens */
    function testInitialBalances(){
        BenevoToken bnv = new BenevoToken();
        uint expected = 1000;
        Assert.equal(bnv.balanceOf(this), expected, "Initialized account should have 1000 token");
    }

    /** @notice transfer of 500 tokens should reflect on the account balances */
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

    /** @notice mining difficulty should start off easy and gradually increase as more miners join */
    function testMiningDifficulty(){
        BenevoToken bnv = new BenevoToken();
        uint expected = 1;
        uint result = bnv.getMiningDifficulty();
        Assert.equal(result, expected, "Initial mining difficulty should be 1");
    }

    /** @notice Mining target initially should equal the maximum target */
    function testMiningTarget(){
        BenevoToken bnv = new BenevoToken();
        uint expected = 2**224;
        uint result = bnv.getMiningTarget();
        Assert.equal(result, expected, "Initial mining target should be 2**224");
    }

    /** @notice Total supply should equal to 7200000 */
    function testTotalSupply(){
        BenevoToken bnv = new BenevoToken();
        uint expected = 7200000;
        uint result = bnv.totalSupply();
        Assert.equal(result, expected, "Initial total supply should be 7200000");
    }

    /** @notice Approval function should work and return true */
    function testApprove(){
        BenevoToken user1 = new BenevoToken();
        BenevoToken user2 = new BenevoToken();
        bool expectedSuccess = true;
        bool resultSuccess = user1.approve(user2, 50);
        Assert.equal(resultSuccess, expectedSuccess, "User1 approving user2 spending 50 tokens should return true");
    }

    /** @notice should return address of the caller */
    function testGetAddress(){
        BenevoToken bnv = new BenevoToken();
        address expectedAddress = this;
        address resultAddress = bnv.getAddress();
        Assert.equal(resultAddress, expectedAddress, "getAddress function should return the address of the caller ");
    }

    /** @notice Initial mining reward should be 50 tokens */
    function testGetMiningReward(){
        BenevoToken bnv = new BenevoToken();
        uint expected = 50;
        uint result = bnv.getMiningReward();
        Assert.equal(result, expected, "Mining Reward should be 50 in the original era");
    }
}
