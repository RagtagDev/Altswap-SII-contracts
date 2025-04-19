// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenData} from "../models/TokenData.sol";

interface IAgent {
    function initiate(
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenData[] calldata debitBundle,
        TokenData[] calldata creditBundle
    ) external returns (bytes32 messageHash);

    function release(address recipient, TokenData[] calldata creditBundle) external;

    function conclude(bytes32 messageHash) external;

    function rollback(bytes32 messamessageHashgeId) external;
}
