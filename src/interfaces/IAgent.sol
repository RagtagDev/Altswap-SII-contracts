// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenBundle} from "../models/TokenBundle.sol";

interface IAgent {
    function initiate(
        TokenBundle calldata retainBundle,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenBundle calldata releaseBundle
    ) external returns (bytes32 messageId);

    function release(address recipient, TokenBundle calldata releaseBundle) external;

    function conclude(bytes32 messageId) external;
    function conclude(bytes32 messageId, address recipient, TokenBundle calldata releaseBundle) external;

    function rollback(bytes32 messageId) external;
}
