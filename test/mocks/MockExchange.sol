// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IExchange} from "../../src/interfaces/IExchange.sol";
import {Errors} from "../../src/libraries/Errors.sol";
import {ERC6909Claims} from "../../src/ERC6909Claims.sol";

contract Exchange is IExchange, ERC6909Claims {
    address public immutable broker;

    modifier onlyBroker() {
        require(msg.sender == broker, Errors.NotBroker());
        _;
    }

    constructor(address _broker, address) {
        broker = _broker;
    }

    function unlock(bytes calldata data) external onlyBroker returns (bytes memory) {
        (, bytes memory executionData) = abi.decode(data, (address, bytes));
        (uint256 action, address user, address tokenIn, address tokenOut, uint256 amountIn) =
            abi.decode(executionData, (uint256, address, address, address, uint256));

        if (action == 1) {
            balanceOf[user][uint160(tokenIn)] = 0;
            balanceOf[user][uint160(tokenOut)] += amountIn * 2000;
        } else if (action == 2) {
            balanceOf[user][uint160(tokenIn)] = amountIn / 2;
            balanceOf[user][uint160(tokenOut)] = amountIn * 1000;
        } else if (action == 3) {
            revert();
        }

        return "";
    }

    function debit(address user, uint256, address token, uint256 amount) external onlyBroker {
        _mint(user, uint160(token), amount);
    }

    function credit(address user, uint256, address token, uint256 amount) external onlyBroker {
        _burn(user, uint160(token), amount);
    }

    function getBalance(address user, uint256, address token) external view returns (uint256 balance) {
        return balanceOf[user][uint160(token)];
    }
}
