pragma solidity ^0.4.24;

import "node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title BenevoToken - Web browser Mineable ERC20 Token implementing EIP 918

 * @notice
   Inspired by 0xBitcoin Token
   Many part of this contract is commented out due to "out of gas" error, further optimization needs to be done
   Mining JavaScript software and many features of the tokens a yet to be implemented.
*/

/** @dev Safe '>' implemented */
library ExtendedMath {
    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {
        if(a > b) return b;
        return a;
    }
}

/** @dev BenevoToken contract extends the ERC20 Interface */
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

/** @dev Used for token transfer as contracts generally do not receive events */
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

/** @dev Extends ERC20 interface and implements emergency stop */
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
    uint public _BLOCKS_PER_READJUSTMENT = 1024;
    //Larger the target, easier to solve the block
    uint public _MINIMUM_TARGET = 2**16;
    uint public _MAXIMUM_TARGET = 2**224;
    uint public miningTarget;
    //generate a new one when a new reward is minted
    bytes32 public challengeNumber;
    uint public rewardEra;
    uint public maxSupplyForEra;
    // address public lastRewardTo;
    // uint public lastRewardAmount;
    // uint public lastRewardEthBlockNumber;
    // uint public tokensMinted;
    bool locked;
   
    // mapping(bytes32 => bytes32) solutionForChallenge;
    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) private allowed;
    
    // event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);

    /** @dev Deafault Constructor */
    constructor() public {
        symbol = "BNV";
        name = "BenevoToken";
        decimals = 1;
        //population of the world on Aug 2018 (7.2 billion) divided by 1000
        _totalSupply = 720000 * 10**uint(decimals);
        // locked = false;
        // if(locked) revert("must not be locked");
        //All BenevoToken must be mined publicly. No ICO or pre-mine
        // tokensMinted = 0;
        rewardEra = 0;
        // maxSupplyForEra = _totalSupply.div(2);
        miningTarget = _MAXIMUM_TARGET;
        // latestDifficultyPeriodStarted = block.number;
        //_startNewMiningEpoch();
        /**@notice All user given initial balance of 1000 now for testing purposes. 
                   In the future, users will start with 0 balance must mine the token */
        balances[msg.sender] = 1000;
    }

    /** @dev Getter for the current mining difficulty */
    function getMiningDifficulty() public view returns (uint) {
        return _MAXIMUM_TARGET.div(miningTarget);
    }

    /** @dev Getter for the current mining target */
    function getMiningTarget() public view returns (uint) {
        return miningTarget;
    }

    /** @dev Getter for the address of caller. Used for testing and debugging purposes. */
    function getAddress() public view returns (address) {
        return msg.sender;
    }

    /** @dev Getter for the current mining reward
        @notice There will be 7.2 million coins in total. 
                The reward begins at 50 and is cut in half every reward era */
    function getMiningReward() public view returns (uint) {
        return (5 * 10**uint(decimals)).div(2**rewardEra) ;
    }

    /** @dev Getter for the total supply */
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    /**
        @notice Get the token balance for the given address
        @param tokenOwner Address whose balance will be queried
        @return uint256 Represents the balance
    */
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    /**
        @notice Transfer token from token owner's account to 'to' account.
        Owner account must have sufficient balance.
        @param to Address to transfer token to
        @param tokens Value to be transferred
    */
    function transfer(address to, uint tokens) public whenNotPaused
    returns (bool success) {
        require(balances[msg.sender].sub(tokens) <= balances[msg.sender], "token sender balance IntegerUnderflow");
        require(balances[to].add(tokens) >= balances[to], "token receiver balance IntegerOveflow");
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    /**
        @notice Approve the 'spender address' to spend the specified amounts of
        tokens on behalf of msg.sender or token owner
        @param spender Spender of the funds
        @param tokens Amount of tokens to be spent
    */
    function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    /**
        @notice Transfer tokens from one account to another
        @param from Source address, must have sufficient balance
        @param to Target address, must have sufficient allowance
        @param tokens Amount of tokens to be transferred
    */
    function transferFrom(address from, address to, uint tokens) public
    returns (bool success) {
        require(balances[from].sub(tokens) <= balances[from], "token sender balance IntegerUnderflow");
        require(balances[to].add(tokens) >= balances[to], "token receiver balance IntegerOveflow");
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    /**
        @notice returns the amount of tokens allowed by owner that can be transferred to spender's account
        @param tokenOwner Token owner's address
        @param spender Spender's address
        @return uint256 Amount of tokens available to the spender
    */
    function allowance(address tokenOwner, address spender) public whenNotPaused
    view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    /**
        @notice Token owner can approve for 'spender' to transferFrom() 'tokens' from the token owner's account.
                The 'spender' contract function 'receiveApproval()' is then executed
        @param spender token spender's address
        @param tokens number of tokens to be approved
        @param data add note about the transfer
        @return whether the function succeeded
    */
    function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    /** @dev temporarily commented out to prevent 'out of gas' error during migration */

    // /** @dev Eth payable fallback in case any Ether is accidentally sent */
    // function () public payable {
    //     revert("Don't accept ETH");
    // }

    // /** @dev Any accidentally sent ERC20 tokens will be sent back to the sender */
    // function transferAnyERC20Token(address tokenAddress, uint tokens) 
    // public returns (bool success) {
    //     return ERC20Interface(tokenAddress).transfer(owner, tokens);
    // }

    // /** @dev Kill the smart contract when no longer needed */
    // function kill() public onlyOwner {
    //     selfdestruct(owner);
    // }
}