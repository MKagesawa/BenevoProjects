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
    }

    mapping (uint => Project) public projects;

    uint public projectsCount;

    /** @dev Create a new project with a BenevoToken contractAccount
      * @param _name The name of the project
      * @param _goalAmount Goal amount of BenevoToken to be donated
    */
    
    function _createProject(string _name, uint _goalAmount) private whenNotPaused returns(string){
        projectsCount ++;
        projects[projectsCount] = Project(projectsCount, _name, _goalAmount, 0, 0, msg.sender);
        emit NewProject(projectsCount, _name, _goalAmount);
        return _name;
    }

    //Donate BenevoToken to the project
    function donate(uint _id, uint amount) public whenNotPaused {
        _BenevoToken bt;
        bt.transferFrom(msg.sender, projects[_id].ownerAddress, amount);
        projects[_id].currentAmount += amount;
    }

    /** @dev Release the escrowed donation to the project owner 
        @param _projectId Project ID
        @param _amountToWithdraw Amount of BenevoToken to be released
    */
    function releaseDonation(uint _projectId, uint _amountToWithdraw) public whenNotPaused returns (bool success){
        Project project = projects[_projectId];
        require(_amountToWithdraw <= project.currentAmount, "cannot withdraw more than current project balance");
        require(msg.sender == project.ownerAddress, "only project creator can withdraw");
        //projects[_id].currentAmount.sub(_amountToWithdraw);
        //TODO
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