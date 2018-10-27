pragma solidity ^0.4.24;

contract gaslimitGame{
    mapping (uint => uint) count;
    
    event GasLog(uint gas);

    function gasUse(uint n) public {
        uint gastmp = gasleft();
        for(uint i=0;i<n;i++)
        {
            count[i]=i;
            emit GasLog(gastmp-gasleft());
            gastmp = gasleft();
        }
    }
}