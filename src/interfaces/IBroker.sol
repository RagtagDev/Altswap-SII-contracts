// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenData} from "../models/TokenData.sol";

interface IBroker {
    function handleMessage(
        bytes32 messageId,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenData[] calldata debitBundle,
        TokenData[] calldata creditBundle
    ) external;
}
