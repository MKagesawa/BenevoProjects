pragma solidity ^0.4.19;

import "node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "contracts/BenevoToken.sol";

// pausable enables emergency stop
contract BenevoProjects is Pausable {

    BenevoToken bnt;

    //all arithmetic operation in this contract uses Openzeppelin's SafeMath library
    using SafeMath for uint;
    
    event NewProject(uint indexed projectId, string indexed name, uint goalAmount, address owner);
    event Donated(address indexed donor, uint projectId, uint amount);
    event Withdraw(address indexed from, address indexed to, uint tokens); 

    //currentAmount is total amount of token donated. currentBalnace is currentAmount minus tokens the owner already withdrew
    struct Project {
        uint id;
        string name;
        uint goalAmount;
        uint currentAmount;
        uint currentBalance;
        address ownerAddress;
        address projectAddress;
        bool canWithdraw;
    }

    mapping (uint => Project) projects;
    mapping (address => Project) owners;

    uint public projectsCount = 0;

    /** @dev Project getter
        @param _id Project id
    */
    function getProject(uint _id) public view returns (string, uint, uint, uint, address, address, bool){
        Project memory project = projects[_id];
        return (project.name, project.goalAmount, project.currentAmount, project.currentBalance, 
        project.ownerAddress, project.projectAddress, project.canWithdraw);
    }

    /** @dev Create a new project with a BenevoToken contractAccount
      * @param _name The name of the project
      * @param _goalAmount Goal amount of BenevoToken to be donated
    */
    
    function _createProject(string _name, uint _goalAmount) 
    public whenNotPaused returns(uint, string, uint, uint, uint, address, address){
        projectsCount ++;
        projects[projectsCount] = Project(projectsCount, _name, _goalAmount, 0, 0, msg.sender,
            address(ripemd160(abi.encodePacked(msg.sender))), false);
        owners[msg.sender] = projects[projectsCount];
        emit NewProject(projectsCount, _name, _goalAmount, msg.sender);
        return (projectsCount, _name, _goalAmount, 0, 0, msg.sender, address(ripemd160(abi.encodePacked(msg.sender))));
    }

    /** @dev Donate BenevoToken to the project
      * @param _id The id of the project
      * @param amountToDonate Amount of BenevoToken to donate to the project
    */
    function donate(uint _id, uint amountToDonate) public whenNotPaused returns (uint newBalance){
        require(_id > 0 && _id <= projectsCount, "not a valid project address");
        //bnt.transferFrom(msg.sender, projects[_id].projectAddress, amountToDonate);
        bnt = BenevoToken(msg.sender);
        bnt.transfer(projects[_id].projectAddress, amountToDonate);
        newBalance = projects[_id].currentAmount += amountToDonate;
        return newBalance;
    }

    /** @dev Release the escrowed donation to the project owner 
        @param _projectId Project ID
        @param amountToRelease Amount of BenevoToken to be released
    */

    function releaseDonation(uint _projectId, uint amountToRelease) public whenNotPaused returns (bool success){
        Project memory project = projects[_projectId];
        require(amountToRelease <= project.currentAmount, "cannot withdraw more than current project balance");
        require(msg.sender != project.ownerAddress, "only non-project owner can call release Donation");
        project.canWithdraw = true;
        return true;
    }

    /** @dev project owner can withdraw all the tokens that were released
     */

    function withdrawToken() external{
        require(msg.sender == project.ownerAddress, "only project creator can call withdraw");
        Project memory project = owners[msg.sender];
        require(project.canWithdraw == true, "donation not released for withdrawal");
        uint withdrawAmount = project.currentBalance;
        //Subtract withdraw amount before releasing token to for best practice
        project.currentBalance = 0;
        bnt.transferFrom(project.projectAddress, project.ownerAddress, withdrawAmount);
    }

    /** @dev Eth payable fallback
    */

    function () public payable {
        revert("Don't accept ETH");
    }

    /** @dev kill the contract
    */
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}