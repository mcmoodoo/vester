// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vester is ERC20 {
  uint256 public duration;
  address depositor;
  address public receiver;
  address weth;
  uint256 depositDay;
  uint256 tokenBalance;

  constructor(address wethMock) ERC20("Vesting Vault", "VV") {
    duration = 10 days;
    receiver = msg.sender;
    weth = wethMock;
  }
  
  function deposit(address token, uint256 amount) public {
    require(address(depositor) == address(0), "Someone already deposited, use another vault");
    bool success = IERC20(weth).transferFrom(msg.sender, address(this), amount);
    require(success, "Transfer failed");
    tokenBalance = amount;
    depositDay = block.timestamp;
  }

  function withdraw() public {
    require(msg.sender == receiver, "You're not the receiver!");
    uint256 daysElapsed = block.timestamp - depositDay;
    
    uint256 allowedAmountToWithdraw = tokenBalance * daysElapsed * 10**18/(duration * 10**18);

    IERC20(weth).transfer(receiver, allowedAmountToWithdraw);
    tokenBalance -= allowedAmountToWithdraw;
  }

}
