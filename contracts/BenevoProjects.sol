pragma solidity ^0.4.24;

// import "node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
// import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
// import "contracts/BenevoToken.sol";
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
library ExtendedMath {
    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {
        if(a > b) return b;
        return a;
    }
}

contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


contract BenevoToken is ERC20Interface, Pausable {
    //all arithmetic operation in this contract uses Openzeppelin's SafeMath library
    using SafeMath for uint;
    using ExtendedMath for uint;
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    // uint public latestDifficultyPeriodStarted;
    //number of 'blocks' mined
    // uint public epochCount; 
    // uint public _BLOCKS_PER_READJUSTMENT = 1024;
    //Larger the target, easier to solve the block
    uint public _MINIMUM_TARGET = 2**16;
    uint public _MAXIMUM_TARGET = 2**224;
    uint public miningTarget;
    //generate a new one when a new reward is minted
    // bytes32 public challengeNumber;
    uint public rewardEra;
    // uint public maxSupplyForEra;
    // address public lastRewardTo;
    // uint public lastRewardAmount;
    // uint public lastRewardEthBlockNumber;
    // uint public tokensMinted;
    // bool locked = false;
   
    // mapping(bytes32 => bytes32) solutionForChallenge;
    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) private allowed;
    
    // event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);

    /**
        @notice Prevent ERC20 short address attack.
        @param size data length
    */

    // modifier onlyPayloadSize(uint256 size) {
    //     if(msg.data.length < size + 4) {
    //         revert("address too short");
    //     }
    //     _;
    // }

    /**
        @notice Deafault Constructor
    */

    constructor() public {
        symbol = "BNV";
        name = "BenevoToken";
        decimals = 8;
        //population of the world on Aug 2018 (7.2 billion) divided by 1000
        _totalSupply = 7200000 * 10**uint(decimals);
        // if(locked) revert("must not be locked");
        // locked = false;
        //All BenevoToken must be mined publicly. No ICO or pre-mine
        // tokensMinted = 0;
        rewardEra = 0;
        // maxSupplyForEra = _totalSupply.div(2);
        miningTarget = _MAXIMUM_TARGET;
        // latestDifficultyPeriodStarted = block.number;
        //_startNewMiningEpoch();
        //All user given initial balance of 1000 for now. In the future, users will start 
        //with 0 balance must mine the token
        balances[msg.sender] = 1000;
    }

    // function mint(uint256 nonce, bytes32 challenge_digest) 
    // public whenNotPaused returns (bool success) {
    //     //the PoW must contain work that includes a recent ethereum block hash (challenge number) 
    //     //and the msg.sender's address to prevent MITM attacks
    //     bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
    //     if (digest != challenge_digest) revert("challenge digest must match the expected");
    //     if(uint256(digest) > miningTarget) revert("digest must be smaller than target");
    //     //only allow one reward for each challenge
    //     bytes32 solution = solutionForChallenge[challengeNumber];
    //     solutionForChallenge[challengeNumber] = digest;
    //     if(solution != 0x0) revert("Prevent awarding same answer twice");
    //     uint reward_amount = getMiningReward();
    //     balances[msg.sender] = balances[msg.sender].add(reward_amount);
    //     tokensMinted = tokensMinted.add(reward_amount);
    //     //Cannot mint more tokens than there are
    //     //assert(tokensMinted <= maxSupplyForEra);

    //     //set readonly diagnostics data
    //     lastRewardTo = msg.sender;
    //     lastRewardAmount = reward_amount;
    //     lastRewardEthBlockNumber = block.number;
    //     //_startNewMiningEpoch();
    //     emit Mint(msg.sender, reward_amount, epochCount, challengeNumber);
    //     return true;
    // }

    // function _startNewMiningEpoch() whenNotPaused internal {
    //   //if max supply for the era will be exceeded next reward round then enter the new era before that happens
    //   //40 is the final reward era, almost all tokens minted
    //   //once the final era is reached, more tokens will not be given out because the assert function
    //     if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39) {
    //         rewardEra = rewardEra + 1;
    //     }
    //   //set the next minted supply at which the era will change
    //   // total supply is 720000000000000  because of 8 decimal places
    //     maxSupplyForEra = _totalSupply - _totalSupply.div(2**(rewardEra + 1));
    //     epochCount = epochCount.add(1);
    //     //every so often, readjust difficulty. Dont readjust when deploying
    //     if(epochCount % _BLOCKS_PER_READJUSTMENT == 0) {
    //         _reAdjustDifficulty();
    //     }
    //   //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
    //   //do this last since this is a protection mechanism in the mint() function
    //     challengeNumber = blockhash(block.number - 1);
    // }

    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days

    //readjust the target by 5 percent
    // function _reAdjustDifficulty() internal {
    //     uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
    //     //assume 360 ethereum blocks per hour
    //     //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch
    //     uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
    //     uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum

    //     //if there were less eth blocks passed in time than expected
    //     if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
    //     {
    //         uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div(ethBlocksSinceLastDifficultyPeriod);
    //         uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
    //         // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
    //         //make it harder
    //         miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
    //     }else{
    //         uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div(targetEthBlocksPerDiffPeriod);
    //         uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
    //         //make it easier
    //         miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
    //     }

    //     latestDifficultyPeriodStarted = block.number;
    //     if(miningTarget < _MINIMUM_TARGET) {
    //         miningTarget = _MINIMUM_TARGET;
    //     }
    //     if(miningTarget > _MAXIMUM_TARGET) {
    //         miningTarget = _MAXIMUM_TARGET;
    //     }
    // }


    // //this is a recent ethereum block hash, used to prevent pre-mining future blocks
    // function getChallengeNumber() public view returns (bytes32) {
    //     return challengeNumber;
    // }

    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
    function getMiningDifficulty() public view returns (uint) {
        return _MAXIMUM_TARGET.div(miningTarget);
    }

    function getMiningTarget() public view returns (uint) {
        return miningTarget;
    }

    function getAddress() public view returns (address) {
        return msg.sender;
    }

    //7.2m coins total
    //reward begins at 50 and is cut in half every reward era (as tokens are mined)
    function getMiningReward() public view returns (uint) {
        //once we get half way thru the coins, only get 25 per block
        //every reward era, the reward amount halves.
        return (50 * 10**uint(decimals)).div(2**rewardEra) ;
    }

    // //help debug mining software
    // function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) 
    // public view returns (bytes32 digesttest) {
    //     bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
    //     return digest;
    // }

    // //help debug mining software
    // function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) 
    // public view returns (bool success) {
    //     bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
    //     if(uint256(digest) > testTarget) revert("digest must not be higher than test Target");
    //     return (digest == challenge_digest);
    // }

    function totalSupply() 
    public view returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    /**
        @notice Get the token balance for the given address
        @param tokenOwner Address whose balance should be queried
        @return uint256 Represents the balance
    */
    function balanceOf(address tokenOwner) 
    public view returns (uint balance) {
        return balances[tokenOwner];
    }

    /**
        @notice Transfer token from token owner's account to 'to' account
        Owner account must have sufficient balance
        0 value transfers allowed
        @param to Address to transfer token to
        @param tokens Value to be transferred
    */

    function transfer(address to, uint tokens)
    public whenNotPaused
    returns (bool success) {
        //prevent Integer Underflow
        require(balances[msg.sender] - tokens <= balances[msg.sender]);
        //prevent Integer Overflow
        require(balances[to] + tokens >= balances[to]);
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    /**
        @notice Approve the 'spender address' to spend the specified amounts of
        tokens on behalf of msg.sender or token owner
        @param spender Spender of the funds
        @param tokens Amounf of tokens to be spent
    */

    function approve(address spender, uint tokens) 
    public whenNotPaused returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    /**
        @notice Transfer tokens from one account to another
        0 value transfers allowed
        @param from Source address, must have sufficient balance
        @param to Target address, must have sufficient allowance
        @param tokens Amount of tokens to be transferred
    */

    function transferFrom(address from, address to, uint tokens)
    public
    returns (bool success) {
        //prevent Integer Underflow
        require(balances[from] - tokens <= balances[from]);
        //prevent Integer Overflow
        require(balances[to] + tokens >= balances[to]);
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    /**
        @notice returns the amount of tokens allowed by owner that can be 
        transferred to spender's account
        @param tokenOwner Token owner's address
        @param spender Spender's address
        @return uint256 Amount of tokens available to the spender
    */
    
    function allowance(address tokenOwner, address spender) 
    public whenNotPaused
    view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    //Assume you want to send tokens to a serviceContract to pay for a service. 
    //Because the contracts in general do not receive events, even if you transfer 
    //the tokens, the serviceContract will never know that you sent the tokens.
    //The solution is then to approve serviceContract to take the amount required 
    //from your token balance (that and not more!) first, and then execute a function 
    //in serviceContract to move the approved tokens form your token balance to the balance 
    //of serviceContract, and provide you with the service because they are now sure that 
    //you paid.
    function approveAndCall(address spender, uint tokens, bytes data) 
    public whenNotPaused returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    /**
        @notice Eth payable fallback
    */

    function () public payable {
        revert("Don't accept ETH");
    }

    // Owner can transfer out any accidentally sent ERC20 tokens
    function transferAnyERC20Token(address tokenAddress, uint tokens) 
    public returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }

    //kill the smart contract
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}
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

    constructor () public{
        BenevoToken bnt = new BenevoToken();
    }

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
        // require(_id > 0 && _id <= projectsCount, "not a valid project address");
        BenevoToken bnt = new BenevoToken();
        //prevent Integer Overflow
        require(projects[_id].currentAmount + amountToDonate >= projects[_id].currentAmount);
        require(projects[_id].currentBalance + amountToDonate >= projects[_id].currentBalance);
        bnt.transfer(projects[_id].projectAddress, amountToDonate);
        newBalance = projects[_id].currentAmount += amountToDonate;
        projects[_id].currentBalance += amountToDonate; 
        return newBalance;
    }

    /** @dev Release the escrowed donation to the project owner 
        @param _projectId Project ID
    */

    function releaseDonation(uint _projectId) public whenNotPaused returns (bool success){
        Project memory project = projects[_projectId];
        //require(msg.sender != project.ownerAddress, "only non-project owner can call release Donation");
        project.canWithdraw = true;
        return true;
    }

    /** @dev project owner can withdraw all the tokens that were released
     */

    function withdrawToken() external returns (uint _currentBalance){
        // require(msg.sender == project.ownerAddress, "only project creator can call withdraw");
        Project memory project = owners[msg.sender];
        //require(project.canWithdraw == true, "donation not released for withdrawal");
        uint withdrawAmount = project.currentBalance;
        //Subtract withdraw amount before releasing token to for best practice
        _currentBalance = project.currentBalance = 0;
        //project.transfer(project.ownerAddress, withdrawAmount);
        return _currentBalance;
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
