pragma solidity ^0.4.24;

contract ownerGame{
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _new) public {
        owner = _new;
    }
}