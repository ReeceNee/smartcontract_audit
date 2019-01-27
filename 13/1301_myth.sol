pragma solidity ^0.5.0;

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
      msg.sender.call.value(amount)("");
      credit[msg.sender]-=amount;
      emit Withdraw(msg.sender, amount);
      return true;
    }
    return false;
  }  

  function creditOf(address to) public returns (uint) {
    return credit[to];
  }
}