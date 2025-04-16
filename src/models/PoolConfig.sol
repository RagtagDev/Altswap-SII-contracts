// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
tickSpacing: uint16, multiples of which new limit orders can be placed
clRangeLower: uint24, lower bound factor of the concentrated liquidity range; sqrtPriceLower = sqrtPrice * 1.000001 ** -clRangeLower
clRangeUpper: uint24, upper bound factor of the concentrated liquidity range; sqrtPriceUpper = sqrtPrice * 1.000001 ** clRangeUpper

frFeeMbps: uint24, fee paid by swappers for consuming full range liquidity, in 1 / 10_000_000 or 0.00001%
clFeeMbps: uint24, fee paid by swappers for consuming concentrated liquidity, in 1 / 10_000_000 or 0.00001%
takerFeeMbps: uint24, fee paid by takers for crossing sitting limit orders, in 1 / 10_000_000 or 0.00001%
protocolShareBps: uint16, fraction of the fee paid by takers that is shared with the protocol, in 1 / 10_000 or 0.01%

daoSpeed: uint16, spped rate factor at which the DAO's price move; sqrtPriceNew = sqrtPriceOld * 1.000001 ** ((-)daoSpeed * secondsElapsed)
*/

type PoolConfig is bytes32;
