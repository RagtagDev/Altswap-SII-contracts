// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
token0: uint32, id of the first token, require token0 < token1
token1: uint32, id of the second token, require token1 > token0
*/

type PoolId is bytes8;
