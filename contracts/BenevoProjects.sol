pragma solidity ^0.4.19;

import "node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "contracts/BenevoToken.sol";
import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

// pausable enables emergency stop
contract BenevoProjects is Pausable {

    //all arithmetic operation in this contract uses Openzeppelin's SafeMath library
    using SafeMath for uint;
    
    event NewProject(uint indexed projectId, string indexed name, uint goalAmount);
    event Donated(address indexed donor, uint projectId, uint amount);
    event Withdraw(address indexed from, address indexed to, uint tokens); 

    struct Project {
        uint id;
        string name;
        uint goalAmount;
        uint currentAmount;
        uint currentBalance;
        address ownerAddress;
        address projectAddress;
    }

    mapping (uint => Project) projects;

    uint public projectsCount = 0;

    /** @dev Create a new project with a BenevoToken contractAccount
      * @param _name The name of the project
      * @param _goalAmount Goal amount of BenevoToken to be donated
    */
    
    function _createProject(string _name, uint _goalAmount) 
    public whenNotPaused returns(uint, string, uint, uint, uint, address, address){
        projectsCount ++;
        projects[projectsCount] = Project(projectsCount, _name, _goalAmount, 0, 0, msg.sender, address(ripemd160(abi.encodePacked(msg.sender))));
        emit NewProject(projectsCount, _name, _goalAmount);
        return (projectsCount, _name, _goalAmount, 0, 0, msg.sender, address(ripemd160(abi.encodePacked(msg.sender))));
    }

    /** @dev Donate BenevoToken to the project
      * @param _id The id of the project
      * @param amountToDonate Amount of BenevoToken to donate to the project
    */
    function donate(uint _id, uint amountToDonate) public whenNotPaused {
        BenevoToken bnt;
        bnt.transferFrom(msg.sender, projects[_id].projectAddress, amountToDonate);
        projects[_id].currentAmount += amountToDonate;
    }

    /** @dev Release the escrowed donation to the project owner 
        @param _projectId Project ID
        @param _amountToWithdraw Amount of BenevoToken to be released
    */
    function releaseDonation(uint _projectId, uint _amountToWithdraw) public whenNotPaused returns (bool success){
        BenevoToken bnt;
        require(_amountToWithdraw <= projects[_projectId].currentAmount, "cannot withdraw more than current project balance");
        require(msg.sender == projects[_projectId].ownerAddress, "only project creator can withdraw");
        //Subtract withdraw amount before releasing token to prevent re-entrancy attack
        projects[_projectId].currentAmount.sub(_amountToWithdraw);
        bnt.transferFrom(projects[_projectId].projectAddress, projects[_projectId].ownerAddress, _amountToWithdraw);
        return true;
    }

    /**
        @notice Eth payable fallback
    */

    function () public payable {
        revert("Don't accept ETH");
    }

    //kill the smart contract
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}