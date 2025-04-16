// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.29;

import {IExchange} from "./interfaces/IExchange.sol";
import {PoolId} from "./models/PoolId.sol";
import {PoolConfig} from "./models/PoolConfig.sol";

contract Exchange is IExchange {
    mapping(PoolId => PoolConfig) public configs;

    function unlock(bytes calldata data) external returns (bytes memory result) {
        // TODO:
    }
}
