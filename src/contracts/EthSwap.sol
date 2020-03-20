pragma solidity >=0.4.21 <0.6.0;

import './Token.sol';

contract EthSwap {
  
  string public name = "Instant One-Coin Swap";
  Token public token;
  uint public rate = 100; // 1 eth = 100 token

  event TokenPurchased(
    address account,
    address token,
    uint amount,
    uint rate
  );

  event TokenSold(
    address account,
    address token,
    uint amount,
    uint rate
  );

  constructor(Token _token) public {
    token = _token;
  }

  function buyTokens() public payable {
    // Calculate the number of tokens to buy
    uint tokenAmount = msg.value * rate;

    //Require that EthSwap has enough tokens
    require(token.balanceOf(address(this)) >= tokenAmount, "EthSwap balance is less than transfer amount");

    //Transfer tokens to the user
    token.transfer(msg.sender, tokenAmount);

    //Emit an event
    emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
  }

  function sellTokens(uint _amount) public {
    //User cant sell more tokens than they have
    require(token.balanceOf(msg.sender) >= _amount, "sender deosn't have enough tokens");

    //Calculate the amount of ether to redeem
    uint etherAmount = _amount / rate;

    // Require that ethSwap has enough Ether
    require(address(this).balance >= etherAmount, "smart contract doesn't have enough ether");
     
    //Perform sale
    token.transferFrom(msg.sender, address(this), _amount);
    msg.sender.transfer(etherAmount);
    
    //Emit event
    emit TokenSold(msg.sender, address(token), _amount, rate);
  }

}
