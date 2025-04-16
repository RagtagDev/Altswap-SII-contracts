// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IExchange {
    function unlock(bytes calldata data) external returns (bytes memory result);
}
