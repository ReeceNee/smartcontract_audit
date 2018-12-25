pragma solidity ^0.4.24;

contract CoverToken{
    uint256 public numbers;
    address public owner;
    mapping(address => uint256) public balances;
    luckyMan[] luckyLog;

    struct luckyMan{
        uint256 _amount;
        address _who;
    }
    
    constructor() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        if (msg.sender != owner)
            revert();
        _;
    }
    
    function lucky(uint guess) public returns (bool){
        uint random = uint(keccak256(now, msg.sender, numbers)) % 5;
        if (guess == random){
            balances[msg.sender] += 10;
            luckyMan lucky;
            lucky._amount = 10;
            lucky._who = msg.sender;
            luckyLog.push(lucky);
            return true;
        }
        return false;   
        
    }
    
    
    
    
}