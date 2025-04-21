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
    ) external payable returns (uint256 nonce);

    function release(address recipient, TokenData[] calldata creditBundle) external;

    function conclude(uint256 messageNonce) external;

    function rollback(uint256 messageNonce) external;
}
