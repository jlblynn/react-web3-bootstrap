pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
  string public name = "Dapp Token Farm";
  address public owner;
  DaiToken public daiToken;
  DappToken public dappToken;

  address[] public stakers; 
  mapping(address  => uint) public stakingBalance;
  mapping(address => bool) public hasStaked;
  mapping(address => bool) public isStaking;

  constructor(DappToken _dappToken, DaiToken _daiToken) public {
    dappToken = _dappToken;
    daiToken = _daiToken;
    owner = msg.sender;
  }

  // deposit tokens for staking
  function stakeTokens(uint _amount) public {

    // require amount to be greater than 0
    require(_amount > 0, "amount cannot be 0");

    // transfer mock dai tokens from this contract for staking
    // transferFrom allows another party to send the dai
    daiToken.transferFrom(msg.sender, address(this), _amount);

    // update the staking balance
    stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

    // add user to staking array only if they haven't already staked
    if(!hasStaked[msg.sender]) {
      stakers.push(msg.sender);
    }

    // update staking status
    isStaking[msg.sender] = true;
    hasStaked[msg.sender] = true;
  }

  // withdraw from staking
  function unstakeTokens() public {

    // fetch staking balance
    uint balance = stakingBalance[msg.sender];

    // require that the account is greater than 0
    require(balance > 0, "staking balance cannot be 0");

    // transfer tokens from the app back to the investor
    daiToken.transfer(msg.sender, balance);

    // reset the investor staking balance
    stakingBalance[msg.sender] = 0;

    // tell the app they aren't staking anymore
    isStaking[msg.sender] = false;
  }

  // issuing tokens
  function issueTokens() public {

    // only the owner can call this
    require(msg.sender == owner, "caller must be the owner");

    // issue 1:1 dai:dapp for everyone that is staking
    for (uint i=0; i<stakers.length; i++) {
      address recipient = stakers[i];
      uint balance = stakingBalance[recipient];
      if (balance > 0) {
        dappToken.transfer(recipient, balance);
      }
    }
  }
}