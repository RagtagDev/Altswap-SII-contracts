// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Action} from "../models/Action.sol";

interface IRouter {
    function execute(Action[] memory actions, bytes memory params) external;
}
