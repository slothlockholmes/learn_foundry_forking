// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { IERC20, IUniswapV2Router01, IUniswapV2Pair } from "../lib/interfaces.sol";

abstract contract HelperContract {
    address constant ME = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
}

contract ContractTest is Test, HelperContract {

    IUniswapV2Router01 constant ROUTER = IUniswapV2Router01(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Pair constant WETH_USDC_PAIR = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    uint256 constant DEADLINE = 7956814942;
    address[] public buyPath = [WETH, USDC];
    address[] public sellPath = [USDC, WETH];
    
    function setUp() public {
        vm.deal(ME, 1000 ether);
    }

    function testBuy() public {
        // Calculate amountOut
        (uint256 r0, uint256 r1, ) = WETH_USDC_PAIR.getReserves();
        uint256 amountOut = ROUTER.getAmountOut(100 ether, r1, r0);
        
        // Get USDC before swapping
        IERC20 usdc = IERC20(USDC);
        uint256 balanceBefore = usdc.balanceOf(ME);

        // Swap ETH for USDC
        ROUTER.swapExactETHForTokens{value: 100 ether}(0, buyPath, ME, DEADLINE);
        
        // Get USDC after swapping
        uint256 balanceAfter = usdc.balanceOf(ME);

        // Check if increase in USDC is what I was expecting
        uint256 delta = balanceAfter - balanceBefore;
        assertEq(delta, amountOut);
    }
}
