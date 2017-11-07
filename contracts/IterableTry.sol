pragma solidity ^0.4.15;

import "./itMapsLib.sol";
import "./ERC20Interface.sol";


contract IterableTry is ERC20Interface{

      using itMaps for itMaps.itMapAddressUint;
      itMaps.itMapAddressUint balancesIterateMap; //mapp for address instead standart mapp
      itMaps.itMapAddressUint withdrawMap; //mapp for address per tokens for amount of ether

      string public constant symbol = "SPT";
      string public constant name = "Stepan Tokens";
      uint8 public constant decimals = 8;
      uint256 _totalSupply = 10000000000000000;
      uint public constant amountEtherOnContract = this.balance; 
   

      
      
      // Owner of this contract
      address public owner;
   
      // Balances for each account
    //   mapping(address => uint256) balances;
   
      // Owner of account approves the transfer of an amount to another account
      mapping(address => mapping (address => uint256)) allowed;
   
      // Functions with this modifier can only be executed by the owner
      modifier onlyOwner() {
          require(msg.sender == owner);           
          _;
      }

 

      // Constructor
      function IterableTry() {
          owner = msg.sender;
          
        //   balances[owner] = _totalSupply;
        balancesIterateMap.insert( msg.sender, _totalSupply);
      }
   
      function totalSupply() constant returns (uint256 totalSupply) {
          totalSupply = _totalSupply;
      }
   
      // What is the balance of a particular account?
      function balanceOf(address _owner) constant returns (uint256 balance) {
          
        //   return balances[_owner];
        return balancesIterateMap.get(_owner);
      }
   
      // Transfer the balance from owner's account to another account
      function transfer(address _to, uint256 _amount) returns (bool success) {
          if (balancesIterateMap.get(msg.sender) >= _amount && _amount > 0 && balancesIterateMap.get(_to) + _amount > balancesIterateMap.get(_to))
          {
              
            //   balances[msg.sender] -= _amount;
              balancesIterateMap.insert(msg.sender, balancesIterateMap.get(msg.sender) - _amount); //subtract amount from msg.sender
            //   balances[_to] += _amount;
              balancesIterateMap.insert(_to, balancesIterateMap.get(_to) + _amount);//add amount for _to to address recipient
              Transfer(msg.sender, _to, _amount);
              return true;
          } else {
              return false;
          }
      }
   
    
     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
        //  if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
        if(balancesIterateMap.get(_from) >= _amount && allowed[_from][msg.sender] >= _amount &&  _amount > 0 && balancesIterateMap.get(_to) + _amount > balancesIterateMap.get(_to))
         {
             //  balances[_from] -= _amount;
             balancesIterateMap.insert(_from, balancesIterateMap.get(_from) - _amount);
             allowed[_from][msg.sender] -= _amount;
             //  balances[_to] += _amount;
             balancesIterateMap.insert(_to,balancesIterateMap.get(_to) + _amount);
             Transfer(_from, _to, _amount);
             return true;
         } else {
             return false;
         }
     }
  
     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
     // If this function is called again it overwrites the current allowance with _value.
     function approve(address _spender, uint256 _amount) returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
         Approval(msg.sender, _spender, _amount);
         return true;
     }
  
     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
     }

     function withdrawFunction() returns (bool){
         uint amountEtherePerOneToken =  amountEtherOnContract/_totalSupply;
         address currentOwner;
        
         for(uint i; i<balancesIterateMap.size(); i++){
             withdrawMap.insert(balancesIterateMap.getKeyByIndex(i),balancesIterateMap.getValueByIndex(i) * amountEtherePerOneToken);  //insert amount ether per amount tokens on address in new structure
             currentOwner = withdrawMap.getKeyByIndex(i);
             currentOwner.transfer(withdrawMap.getValueByIndex(i));     //transfer etherium on addresses per tokens       
         }
         
         return true;
     }

   
}