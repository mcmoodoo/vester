// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WethMock is ERC20 {
  constructor() ERC20("WETH Mock Contract", "WETHMOCK") {
    _mint(msg.sender, 10);
  }
}
