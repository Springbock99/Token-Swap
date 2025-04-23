// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, Vm, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin-contracts-5.3.0/token/ERC20/IERC20.sol";

contract TokenSwapTest is Test {
    address public owner;
    address public user1;
    address public user2;
    address public dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IERC20 public daiToken;
    IERC20 public wEthTokens;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        daiToken = IERC20(dai);
        wEthTokens = IERC20(weth);

        string memory rpcUrl = vm.envString("ETHEREUM_URL");

        vm.createSelectFork(rpcUrl);

        vm.startPrank(owner);

        deal(address(dai), user1, 100 * 1e18);
        deal(address(weth), user1, 100 * 1e18);
        deal(address(dai), user2, 100 * 1e18);
        deal(address(weth), user2, 100 * 1e18);

        vm.stopPrank();
    }

    function test_userBalance() public {
        uint256 user1BalanceDai = daiToken.balanceOf(user1);
        uint256 user2BalanceWeth = wEthTokens.balanceOf(user2);

        assertEq(user1BalanceDai, 100 * 10 ** 18);
        assertEq(user2BalanceWeth, 100 * 10 ** 18);
    }
}
