// Shared Wallet

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract project {
    
    mapping(address => uint) public balanceReceived;

    function convertWeiToEth(uint _amount) public pure returns(uint) {
       return _amount / 1 ether;
    }

    function receiveMoney() public payable {
       assert(balanceReceived[msg.sender] + msg.value >= balanceReceived[msg.sender]);
       balanceReceived[msg.sender] += msg.value;
    }

    function getBalance() public view returns(uint) {
      return address(this).balance;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
       require(_amount <= balanceReceived[msg.sender], "not enough funds.");
       assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
       balanceReceived[msg.sender] -= _amount;
       _to.transfer(_amount);
    }

    function sendMoney(address _here, uint _amount) public {
       require(balanceReceived[msg.sender] >= _amount, "Not enough funds");
       assert(balanceReceived[_here] + _amount >= balanceReceived[_here]);
       assert(balanceReceived[msg.sender] - _amount <= balanceReceived[msg.sender]);
       balanceReceived[msg.sender] -= _amount;
       balanceReceived[_here] += _amount;
    }

    receive() external payable {
       receiveMoney();
    }

}
