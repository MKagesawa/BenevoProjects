pragma solidity ^0.4.19;

import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";

/**@notice There are not tests for functions using Oracle such as getPollution() and __callback() 
because these functions require an external call to Oraclize and cannot be tested with solidty 
tests. */


contract Oracle is usingOraclize{
    string public pollution;
    bytes32 public oraclizeID;
    
    event LogConstructorInitiated(string nextStep);
    event LogPollutionUpdated(string unit);
    event LogUpdate(string description);

    constructor () public{
        //During production the OAR is automatically fetched
        emit LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function getPollution() public payable {
        oraclizeID = oraclize_query("WolframAlpha", "greenhouse gas emissions United States");
    }
    
    function __callback(bytes32 myid, string result) public{
        //prevent anyone other than Oracle from calling the function
        if (msg.sender != oraclize_cbAddress()) revert();
        pollution = result;
        emit LogPollutionUpdated(result);
    }

    function getBalance() public returns (uint _balance){
        return address(this).balance;
    }
}