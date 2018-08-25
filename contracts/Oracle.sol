pragma solidity ^0.4.18;

import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";

/**
    @title  Oracle - using Oraclize to make external API calls
    @notice There are not tests for functions using Oracle such as getPollution() and __callback() 
            because these functions require an external call to Oraclize and cannot be tested with solidty tests.
    @dev    Currently the contract calls WolframAlpha for the current US pollution data
*/

contract Oracle is usingOraclize{
    string public pollution;
    bytes32 public oraclizeID;

    /*** EVENTS ***/
    event LogConstructorInitiated(string nextStep);
    event LogPollutionUpdated(string unit);
    event LogUpdate(string description);

    /** @dev constructor emitting initiation event*/
    constructor () public{
        //During production the OAR is automatically fetched
        emit LogConstructorInitiated("Constructor was initiated. Call 'getPullution()' to send the Oraclize Query.");
    }

    /** @dev pausable enables emergency stop */
    function getPollution() public payable {
        // get ID for debugging purposes
        oraclizeID = oraclize_query("WolframAlpha", "greenhouse gas emissions United States");
    }

    /** @dev callback for Oraclize to return the queried data
        @param _oraclizeID ID of the Oraclize query
        @param result the result of the query
    */
    function __callback(bytes32 _oraclizeID, string result) public{
        //prevent anyone other than Oracle from calling the function
        if (msg.sender != oraclize_cbAddress()) revert("function callner not from oraclize_cbAddress");
        pollution = result;
        emit LogPollutionUpdated(result);
    }

    function getBalance() public returns (uint _balance){
        return address(this).balance;
    }
}