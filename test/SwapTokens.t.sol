// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, Vm, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin-contracts-5.2.0/token/ERC20/IERC20.sol";

contract TokenSwapTest is Test {
    address public owner;
    address public user1;
    address public user2;
    address public Dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public Weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        string memory rpcUrl = vm.envString("ETHEREUM_URL");

        vm.createSelectFork(rpcUrl);

        vm.startPrank(owner);

        deal(address(Dai), user1, );
        deal(address(Weth), user2, );

        vm.stopPrank();
    }

    // function test_userBalance() public {
    //     user1 balance = balance(user1);
    // }
}
