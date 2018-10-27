pragma solidity ^0.4.24;

contract selfdestructGame{
    address owner;

    constructor() payable {
        owner = msg.sender;
    }
    
    function ownedEth() public constant returns(uint256){
        return this.balance;
    }
    

    function destruct(address _who) public {
        selfdestruct(_who);
    }
}

contract revertContract{
    
    function ownedEth() public constant returns(uint256){
        return this.balance;
    }
    
    function() public {
        revert();
    }
}