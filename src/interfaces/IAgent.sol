// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenBundle} from "../models/TokenBundle.sol";

interface IAgent {
    function initiate(
        TokenBundle calldata debitBundle,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenBundle calldata creditBundle
    ) external returns (bytes32 messageId);

    function release(address recipient, TokenBundle calldata creditBundle) external;

    function conclude(bytes32 messageId) external;

    function rollback(bytes32 messageId) external;
}
