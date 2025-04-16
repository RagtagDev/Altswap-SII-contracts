// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import {BalanceDelta} from "../models/BalanceDelta.sol";
// import {OrderId} from "../models/OrderId.sol";
// import {PoolId} from "../models/PoolId.sol";
// import {SqrtPrice} from "../models/SqrtPrice.sol";

// interface IExchange {
//     function modifyFRReserves(PoolId poolId, int256 shareDelta) external returns (BalanceDelta balanceDelta);
//     function modifyCLReserves(PoolId poolId, int256 shareDelta) external returns (BalanceDelta balanceDelta);

//     struct PlaceOrderParams {
//         bool isZeroForOne;
//         bool isPostOnly;
//         bool isFillOrKill;
//         bool isImmediateOrCancel;
//         int128 amountSpecified;
//         SqrtPrice sqrtPriceLimit;
//         int32 restingTick;
//         SqrtPrice[] sqrtPriceNeighbors;
//     }

//     function placeOrder(PoolId poolId, PlaceOrderParams memory params) external returns (BalanceDelta balanceDelta);
//     function removeOrder(PoolId poolId, OrderId orderId) external returns (BalanceDelta balanceDelta);
// }
