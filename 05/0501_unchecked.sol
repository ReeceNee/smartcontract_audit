pragma solidity ^0.4.24;

contract UncheckedGame{
    
    uint etherLeft=0;
    mapping (address => uint256) public balances;

    event Deposite(address _who, uint _amount);
    event Withdraw(address _who, uint _amount);

    function deposite() public payable returns (uint){
        balances[msg.sender]+=msg.value;
        etherLeft+=msg.value;
        emit Deposite(msg.sender, msg.value);
        return balances[msg.sender];
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        msg.sender.send(_amount);
        balances[msg.sender] -= _amount;
        etherLeft -= _amount;
        emit Withdraw(msg.sender, _amount);
    }
    
    function ownedEth() public constant returns(uint256){
        return this.balance;
    }
}

contract revertContract{
    
    function testDeposite(address _addr) public payable{
        bytes4 methodHash = bytes4(keccak256("deposite()"));
        _addr.call.value(msg.value)(methodHash);
    }
    
    function testWithdraw(address _addr, uint256 _amount) public payable{
        bytes4 methodHash = bytes4(keccak256("withdraw(uint256)"));
        _addr.call(methodHash,_amount);
    }
    
    function ownedEth() public constant returns(uint256){
        return this.balance;
    }
    
    function() public payable{
        revert();
    }
}