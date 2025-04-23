// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {IERC20} from "@openzeppelin-contracts-5.3.0/token/ERC20/IERC20.sol";

error InvalidAddress();
error InvalidAmount();
error InsufficientFunds();

contract SimpleSwap {
    IERC20 public daiToken;
    IERC20 public wEthToken;
    uint256 public reserveDai;
    uint256 public reserveWeth;
    uint256 constant FEE_NUMERATOR = 997;
    uint256 constant FEE_DENOMINATOR = 1000;

    constructor(address _dai, address _wEth) {
        daiToken = IERC20(_dai);
        wEthToken = IERC20(_wEth);

        if (_dai == address(0)) revert InvalidAddress();
        if (_wEth == address(0)) revert InvalidAddress();
    }

    function deposit(uint256 daiAmount, uint256 wEthAmount) external {
        if (daiAmount == 0) revert InvalidAmount();
        if (wEthAmount == 0) revert InvalidAmount();

        // if (daiAmount > daiToken.balanceOf(msg.sender))
        //     revert InsufficientFunds();
        // if (wEthAmount > wEthToken.balanceOf(msg.sender))
        //     revert InsufficientFunds();

        daiToken.transferFrom(msg.sender, address(this), daiAmount);
        wEthToken.transferFrom(msg.sender, address(this), wEthAmount);
    }
}
