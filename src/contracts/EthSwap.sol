pragma solidity >=0.4.21 <0.6.0;

import './Token.sol';

contract EthSwap {
  
  string public name = "Instant One-Coin Swap";
  Token public token;
  uint public rate = 100;

  event TokenPurchased(
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

}
