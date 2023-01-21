//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SmartWallet {
    address owner;
    address payable wallet1;
    address payable public wallet2;
    uint256 public percentage;
    mapping(address => uint256) balanceReceived;
    mapping(address => bool) public authorizedUsers;
    
    event Wallet1Set(address indexed newWallet1);
    event Wallet2Set(address indexed newWallet2);
    event PercentageSet(uint256 newPercentage);
    event FundReceived(address indexed sender, uint256 value);
    event FundsAllocated(address indexed wallet1, uint256 wallet1Amount, address indexed wallet2, uint256 wallet2Amount);

    constructor() public {
        owner = msg.sender;
        authorizedUsers[owner] = true;
    }

    function setWallet1(address payable _wallet1) public {
        require(authorizedUsers[msg.sender], "Unauthorized user.");
        wallet1 = _wallet1;
        emit Wallet1Set(_wallet1);
    }

    function setWallet2(address payable _wallet2) public {
        require(authorizedUsers[msg.sender], "Unauthorized user.");
        wallet2 = _wallet2;
        emit Wallet2Set(_wallet2);
    }

    function setPercentage(uint256 _percentage) public {
        require(authorizedUsers[msg.sender], "Unauthorized user.");
        require(_percentage <= 100, "Percentage must be less than or equal to 100.");
        percentage = _percentage;
        emit PercentageSet(_percentage);
    }

    function authorizeUser(address _user) public {
        require(msg.sender == owner, "Only the owner can authorize users.");
        authorizedUsers[_user] = true;
    }

    function revokeUser(address _user) public {
        require(msg.sender == owner, "Only the owner can revoke users.");
        authorizedUsers[_user] = false;
    }

    function withdrawAllMoney(address payable _to) public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        uint balanceToSend = balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0;
        _to.transfer(balanceToSend);
    }

    function getBalance() public view returns(uint) {
        require(authorizedUsers[msg.sender], "Unauthorized user.");
        return address(this).balance;
    } 

    function getWallet1Balance() public view returns(uint) {
        require(authorizedUsers[msg.sender], "Unauthorized user.");
        return wallet1.balance;
    } 


    function receive() external payable {
        require(wallet1 != address(0) && wallet2 != address(0), "Wallet addresses must be set before receiving funds.");
        require(percentage > 0 && percentage < 100, "Percentage allocation must be set before receiving funds.");

        uint256 amount1 = (percentage * msg.value) / 100;
        uint256 amount2 = msg.value - amount1;

        wallet1.transfer(amount1);
        wallet2.transfer(amount2);
        
        emit FundReceived(msg.sender, msg.value);
        emit FundsAllocated(wallet1, amount1, wallet2, amount2);
    }
}
