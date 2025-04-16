// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.29;

import {IExchange} from "./interfaces/IExchange.sol";
import {IRouter} from "./interfaces/IRouter.sol";
import {Action, Actions} from "./models/Action.sol";

contract Router is IRouter {
    IExchange public exchange;

    function execute(Action[] memory actions, bytes memory params) external {
        try exchange.unlock(abi.encode(actions, params)) {
            // TODO: send success message
        } catch {
            // TODO: send failure message
        }
    }

    function unlockCallback(bytes memory data) external returns (bytes memory) {
        (Action[] memory actions, bytes memory params) = abi.decode(data, (Action[], bytes));
        for (uint256 i = 0; i < actions.length; i++) {
            if (actions[i] == Actions.NONE) {
                continue;
            }
        }
    }
}
