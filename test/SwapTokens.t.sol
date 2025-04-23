// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, Vm, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin-contracts-5.3.0/token/ERC20/IERC20.sol";
import {SimpleSwap} from "../contracts/SimpleSwap.sol";

contract TokenSwapTest is Test {
    SimpleSwap public simpleSwap;

    address public owner;
    address public user1;
    address public user2;
    address public dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint256 public totalSupply = 10000 * 1e18;
    IERC20 public daiToken;
    IERC20 public wEthToken;

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        daiToken = IERC20(dai);
        wEthToken = IERC20(weth);

        string memory rpcUrl = vm.envString("ETHEREUM_URL");

        vm.createSelectFork(rpcUrl);

        vm.startPrank(owner);

        simpleSwap = new SimpleSwap(address(daiToken), address(wEthToken));

        deal(address(dai), user1, totalSupply);
        deal(address(weth), user1, totalSupply);
        deal(address(dai), user2, totalSupply);
        deal(address(weth), user2, totalSupply);

        vm.startPrank(user1);
        daiToken.approve(address(simpleSwap), 10000 * 1e18);
        wEthToken.approve(address(simpleSwap), 10000 * 1e18);
        vm.stopPrank();

        vm.startPrank(user2);
        daiToken.approve(address(simpleSwap), 10000 * 1e18);
        wEthToken.approve(address(simpleSwap), 10000 * 1e18);
        vm.stopPrank();

        vm.stopPrank();
    }

    function test_userBalance() public view {
        uint256 user1BalanceDai = daiToken.balanceOf(user1);
        uint256 user2BalanceWeth = wEthToken.balanceOf(user2);

        assertEq(user1BalanceDai, totalSupply);
        assertEq(user2BalanceWeth, totalSupply);
    }

    function test_addLiquidity() public {
        vm.prank(user1);
        simpleSwap.addLiquidity(100 * 1e18, 100 * 1e18);

        uint256 user1BalanceDai = daiToken.balanceOf(user1);
        uint256 user2BalanceWeth = wEthToken.balanceOf(user1);

        assertEq(user1BalanceDai, totalSupply - 100 * 1e18);
        assertEq(user2BalanceWeth, totalSupply - 100 * 1e18);
    }
}
