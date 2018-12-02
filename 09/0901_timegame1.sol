pragma solidity ^0.4.24;

contract TimeGame1{
    uint public lastBlockTime;
    
    function lucky() public payable{
        require(msg.value == 100 wei);
        require(lastBlockTime != block.timestamp);
        lastBlockTime = block.timestamp;
        if(lastBlockTime % 10 == 5){
            msg.sender.transfer(address(this).balance);
        }
    }
}