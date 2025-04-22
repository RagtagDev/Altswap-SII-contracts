// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC6909Claims} from "./IERC6909Claims.sol";

interface IExchange is IERC6909Claims {
    function unlock(bytes calldata data) external returns (bytes memory result);

    function debit(address user, uint256 chainId, address token, uint256 amount) external;
    function credit(address user, uint256 chainId, address token, uint256 amount) external;

    function getBalance(address user, uint256 chainId, address token) external view returns (uint256 balance);
}
