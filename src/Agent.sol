// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IL2ToL2CrossDomainMessenger} from "./interfaces/external/IL2ToL2CrossDomainMessenger.sol";
import {IAgent} from "./interfaces/IAgent.sol";
import {IBroker} from "./interfaces/IBroker.sol";
import {Predeploys} from "./libraries/external/Predeploys.sol";
import {TokenData} from "./models/TokenData.sol";

contract Agent is IAgent {
    struct MessageCache {
        address sender;
        TokenData[] debitBundle;
    }

    // TODO: set
    uint256 internal immutable hubChainId;
    // TODO: set
    IBroker internal immutable broker;
    IL2ToL2CrossDomainMessenger internal immutable messenger =
        IL2ToL2CrossDomainMessenger(Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER);

    mapping(bytes32 => MessageCache) internal messageCaches;

    function initiate(
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenData[] calldata debitBundle,
        TokenData[] calldata creditBundle
    ) external payable returns (bytes32 messageId) {
        // TODO:
        // 1. debitBundle.transfer(msg.sender, address(this))
        // 2. call broker.handleMessage on hubChainId through messenger and get messgeHash
        // 3. cache msg.sender, and debitBundle under messageHash
    }

    function release(address recipient, TokenData[] calldata creditBundle) external {
        // TODO: only from broker through messenger
        // TODO: creditBundle.transfer(address(this), recipient)
    }

    function conclude(bytes32 messageHash) external {
        // TODO: only from broker through messenger
        // TODO: delete messageCaches[messageHash]
    }

    function rollback(bytes32 messageHash) external {
        // TODO: only from broker through messenger
        // TODO:
        // 1. get sender and debitBundle from messageCaches[messageHash]
        // 2. debitBundle.transfer(address(this), sender)
        // 3. delete messageCaches[messageHash]
    }
}
