// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {IERC20} from "@openzeppelin-contracts-5.3.0/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin-contracts-5.3.0/utils/ReentrancyGuard.sol";

error InvalidAddress();
error InvalidAmount();
error InsufficientFunds();
error InsufficientLiquidity();
error SlippageTooHigh();

contract SimpleSwap is ReentrancyGuard {
    IERC20 public daiToken;
    IERC20 public wEthToken;
    uint256 public reserveDai;
    uint256 public reserveWeth;
    uint256 constant FEE_NUMERATOR = 997;
    uint256 constant FEE_DENOMINATOR = 1000;

    event LiquidityAdded(
        address indexed user,
        uint256 daiAmount,
        uint256 wEthamount
    );

    constructor(address _dai, address _wEth) {
        daiToken = IERC20(_dai);
        wEthToken = IERC20(_wEth);

        if (_dai == address(0)) revert InvalidAddress();
        if (_wEth == address(0)) revert InvalidAddress();
    }
    function _syncReserve() internal {
        reserveDai = daiToken.balanceOf(address(this));
        reserveWeth = wEthToken.balanceOf(address(this));
    }

    function addLiquidity(
        uint256 daiAmount,
        uint256 wEthAmount
    ) external nonReentrant {
        if (daiAmount == 0) revert InvalidAmount();
        if (wEthAmount == 0) revert InvalidAmount();

        daiToken.transferFrom(msg.sender, address(this), daiAmount);
        wEthToken.transferFrom(msg.sender, address(this), wEthAmount);

        emit LiquidityAdded(msg.sender, daiAmount, wEthAmount);

        _syncReserve();
    }

    function swapDaiForWeth(uint256 amountIn) external nonReentrant {
        if (amountIn == 0) revert InvalidAmount();

        _syncReserve();

        uint256 amountInWithFee = (amountIn * FEE_NUMERATOR) / FEE_DENOMINATOR;

        uint256 amountOut = (reserveWeth * amountInWithFee) /
            (reserveDai + amountInWithFee);

        if (amountOut >= reserveWeth) revert InsufficientLiquidity();
        if (amountOut == 0) revert SlippageTooHigh();

        daiToken.transferFrom(msg.sender, address(this), amountIn);
        wEthToken.transfer(msg.sender, amountOut);

        _syncReserve();
    }

    // function swapTokens(address token) external {
    //     if (token == address(0)) revert InvalidAddress();

    // }
}
