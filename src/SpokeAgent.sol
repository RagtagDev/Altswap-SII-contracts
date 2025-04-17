// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IL2ToL2CrossDomainMessenger} from "@optimism/bedrock/L2/IL2ToL2CrossDomainMessenger.sol";
import {Predeploys} from "@optimism/bedrock/libraries/Predeploys.sol";
import {IAgent} from "./interfaces/IAgent.sol";
import {IBroker} from "./interfaces/IBroker.sol";
import {TokenBundle} from "./models/TokenBundle.sol";

contract SpokeAgent is IAgent {
    struct MessageCache {
        address sender;
        TokenBundle debitBundle;
    }

    // TODO: set
    uint256 internal immutable hubChainId;
    // TODO: set
    IBroker internal immutable broker;
    IL2ToL2CrossDomainMessenger internal immutable messenger =
        IL2ToL2CrossDomainMessenger(Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER);

    mapping(bytes32 => MessageCache) internal messageCaches;

    function initiate(
        TokenBundle calldata debitBundle,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenBundle calldata creditBundle
    ) external returns (bytes32 messageId) {
        // TODO:
        // 1. debitBundle.transfer(msg.sender, address(this))
        // 2. generate messageId, then cache msg.sender and debitBundle
        // 3. call broker.handleMessage on hubChainId through messenger with messageId, debitBundle, executor, executionData, recipient, recipientChainId, and creditBundle
    }

    function release(address recipient, TokenBundle calldata creditBundle) external {
        // TODO: only from broker through messenger
        // TODO: creditBundle.transfer(address(this), recipient)
    }

    function conclude(bytes32 messageId) external {
        // TODO: only from broker through messenger
        // TODO: delete messageCaches[messageId]
    }
    function conclude(bytes32 messageId, address recipient, TokenBundle calldata creditBundle) external {
        // TODO: only from broker through messenger
        // TODO:
        // 1. creditBundle.transfer(address(this), recipient)
        // 2. delete messageCaches[messageId]
    }

    function rollback(bytes32 messageId) external {
        // TODO: only from broker through messenger
        // TODO:
        // 1. get sender and debitBundle from messageCaches[messageId]
        // 2. debitBundle.transfer(address(this), sender)
        // 3. delete messageCaches[messageId]
    }
}
