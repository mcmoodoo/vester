// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Vester} from "../src/Vester.sol";
import {WethMock} from "./mocks/WethMock.sol";
import {TestAddresses} from "./TestAddresses.sol";

contract TestVester is Test {
  Vester vester;
  WethMock weth;
  address payer;
  address receiver;

  function setUp() public {
    payer = TestAddresses.payer;
    receiver = TestAddresses.receiver;

    vm.prank(payer);
    weth = new WethMock();

    vm.prank(receiver);
    vester = new Vester(address(weth));
  }

  function test_InitialState() public {
    assertEq(weth.balanceOf(payer), 10);
    assertEq(weth.balanceOf(receiver), 0);
    assertEq(weth.balanceOf(vester.receiver()), 0);
    assertEq(vester.duration(), 10 days);
    assertEq(weth.balanceOf(address(this)), 0);
  }

  function deposit10tokensForPayer() private {
    vm.startPrank(payer);
    weth.approve(address(vester), 10);
    vester.deposit(address(weth), 10);
    vm.stopPrank();
  }

  function test_Deposit() public {
    deposit10tokensForPayer();

    assertEq(weth.balanceOf(payer), 0);
    assertEq(weth.balanceOf(receiver), 0);
    assertEq(weth.balanceOf(vester.receiver()), 0);
    assertEq(weth.balanceOf(address(vester)), 10);

    assertEq(weth.balanceOf(address(vester)), 10);
    assertEq(weth.balanceOf(vester.receiver()), 0);

    assertEq(weth.balanceOf(address(this)), 0);
  }

  function test_Withdrawal_one_day() public {
    deposit10tokensForPayer();
    assertEq(weth.balanceOf(address(this)), 0);

    vm.expectRevert("You're not the receiver!");
    vester.withdraw();

    assertEq(weth.balanceOf(address(vester)), 10);
    vm.warp(vm.getBlockTimestamp() + 1 days);
    vm.prank(receiver);
    vester.withdraw();
    assertEq(weth.balanceOf(address(vester)), 9);
    assertEq(weth.balanceOf(receiver), 1);
  }

  function test_Withdrawal_two_day() public {
    deposit10tokensForPayer();
    assertEq(weth.balanceOf(address(this)), 0);

    vm.expectRevert("You're not the receiver!");
    vester.withdraw();

    assertEq(weth.balanceOf(address(vester)), 10);
    vm.warp(vm.getBlockTimestamp() + 2 days);
    vm.prank(receiver);
    vester.withdraw();
    assertEq(weth.balanceOf(address(vester)), 8);
    assertEq(weth.balanceOf(receiver), 2);
  }

  function test_Withdrawal_halfway() public {
    deposit10tokensForPayer();
    assertEq(weth.balanceOf(address(this)), 0);

    vm.expectRevert("You're not the receiver!");
    vester.withdraw();

    assertEq(weth.balanceOf(address(vester)), 10);
    vm.warp(vm.getBlockTimestamp() + 5 days);
    vm.prank(receiver);
    vester.withdraw();
    assertEq(weth.balanceOf(address(vester)), 5);
    assertEq(weth.balanceOf(receiver), 5);
  }

  function test_Withdrawal_Twice_onDay3_and_day8() public {
    deposit10tokensForPayer();
    assertEq(weth.balanceOf(address(this)), 0);

    vm.expectRevert("You're not the receiver!");
    vester.withdraw();

    assertEq(weth.balanceOf(address(vester)), 10);
    vm.warp(vm.getBlockTimestamp() + 3 days);
    vm.prank(receiver);
    vester.withdraw();
    assertEq(weth.balanceOf(receiver), 3);
    assertEq(weth.balanceOf(address(vester)), 7);

    vm.warp(vm.getBlockTimestamp() + 4 days); // 7 days since depositing
    vm.prank(receiver);
    vester.withdraw();
    assertEq(weth.balanceOf(receiver), 7);
    assertEq(weth.balanceOf(address(vester)), 3);
  }

}
