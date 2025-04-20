// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IL2ToL2CrossDomainMessenger} from "./interfaces/external/IL2ToL2CrossDomainMessenger.sol";
import {IAgent} from "./interfaces/IAgent.sol";
import {IBroker} from "./interfaces/IBroker.sol";
import {Predeploys} from "./libraries/external/Predeploys.sol";
import {TokenData, TokenDataLibrary} from "./models/TokenData.sol";

contract Agent is IAgent {
    using TokenDataLibrary for TokenData[];
    struct MessageCache {
        address sender;
        TokenData[] debitBundle;
    }

    uint256 public messageNonce;
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
        // 1. debitBundle.transfer(msg.sender, address(this))
        debitBundle.transferIn(msg.sender);
        // 2. call broker.handleMessage on hubChainId through messenger and get messgeHash
        assembly ("memory-safe") {
            let m := sload(messageNonce.slot)
            mstore(0x00, m)
            mstore(0x20, chainid())

            messageId := keccak256(0x00, 0x40)

            sstore(messageNonce.slot, add(m, 1))
        }

        messageCaches[messageId] = MessageCache({
            sender: msg.sender,
            debitBundle: debitBundle
        });

        // 3. cache msg.sender, and debitBundle under messageHash
        bytes memory message;

        assembly ("memory-safe") {
            let ptr := mload(0x40)
            let copylen := add(sub(calldatasize(), 4), 0x20)
            message := ptr

            mstore(ptr, copylen)
            mstore(add(ptr, 0x20), messageId)
            calldatacopy(add(ptr, 0x40), 0x04, copylen)
            mstore(0x40, add(ptr, copylen))
        }

        messenger.sendMessage(hubChainId, address(broker), message);
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
