pragma solidity ^0.5.7;
 
contract Will {
   address owner;
   uint fortune;
   bool deceased;
 
   constructor () payable public {
       owner = msg.sender;
       fortune = msg.value;
       deceased = false;
   }
 
   modifier onlyOwner {
      require(msg.sender == owner, "You are not allowed");
      _;
  }
 
   modifier mustBeDeceased {
      require(deceased == true, "Will not yet activated");
      _;
  }
 
   //list of family wallets
  address payable[] familyWallets;
 
  mapping (address => uint) inheritance;
 
   //set inheritance for each address
  function setInheritance (address payable wallet, uint amount) public onlyOwner {
      familyWallets.push(wallet);
      inheritance[wallet] = amount;
  }
 
   //pay each family member based on their wallet address
  function payout() private mustBeDeceased {
       for (uint i=0; i<familyWallets.length; i++) {
           familyWallets[i].transfer(inheritance[familyWallets[i]]);
       }
  }
 
   //oracle switch simulation
  function hasDeceased() public onlyOwner {
      deceased = true;
      payout();
  }
 
}
