// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.29;

import {IExchange} from "./interfaces/IExchange.sol";
import {IERC6909Registry} from "./interfaces/IERC6909Registry.sol";
import {Errors} from "./libraries/Errors.sol";
import {PoolId} from "./models/PoolId.sol";
import {PoolConfig} from "./models/PoolConfig.sol";
import {ERC6909Claims} from "./ERC6909Claims.sol";

contract Exchange is IExchange, ERC6909Claims {
    address public immutable broker;
    IERC6909Registry public immutable registry;
    mapping(PoolId => PoolConfig) public configs;

    modifier onlyBroker() {
        require(msg.sender == broker, Errors.NotBroker());
        _;
    }

    constructor(address _broker, address _registry) {
        broker = _broker;
        registry = IERC6909Registry(_registry);
    }

    function unlock(bytes calldata data) external returns (bytes memory result) {
        // TODO:
    }

    function debit(address user, uint256 chainId, address token, uint256 amount) external {
        _mint(user, registry.toID(chainId, token), amount);
    }

    function credit(address user, uint256 chainId, address token, uint256 amount) external {
        _burn(user, registry.toID(chainId, token), amount);
    }
}
