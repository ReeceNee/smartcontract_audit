pragma solidity ^0.4.24;

contract IntOverflow{

    function addNumber(uint a, uint b) public constant returns (uint){
        uint c;
        c = a+b;
        return c;
    }

}