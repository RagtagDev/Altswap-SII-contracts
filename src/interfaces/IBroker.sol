// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenBundle} from "../models/TokenBundle.sol";

interface IBroker {
    function handleMessage(
        bytes32 messageId,
        TokenBundle calldata debitBundle,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenBundle calldata creditBundle
    ) external;
}
