pragma solidity ^0.4.24;

contract AccessGame{
    
    uint totalSupply=0;
    address owner;
    mapping (address => uint256) public balances;

    event SendBouns(address _who, uint bouns);

    modifier onlyOwner {
        if (msg.sender != owner)
            revert();
        _;
    }
    
    // new constructor() updated in 0.4.22
    constructor() public {
        initOwner(msg.sender);
    }

    function initOwner(address _owner) public{
        owner=_owner;
    }

    function SendBonus(address lucky, uint bouns) public onlyOwner returns (uint){
        require(balances[lucky]<1000);
        require(bouns<200);
        balances[lucky]+=bouns;
        totalSupply+=bouns;

        emit SendBouns(lucky, bouns);

        return balances[lucky];
    }
}
