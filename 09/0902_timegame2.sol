pragma solidity ^0.4.24;

contract TimeGame2{
    bool public neverPlayed=true;
    
    function check(uint answer) public returns(bool){
        // some check for answer
        return true;
    }
    
    function play() public {
	require(now > 1577808000 && neverPlayed == true);
	if (check(233) == true){
    	neverPlayed = false;
    	msg.sender.transfer(1500 ether);   
    	}
    }
}