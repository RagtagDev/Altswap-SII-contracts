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

    uint256 public nonce;
    // TODO: set
    uint256 internal immutable hubChainId;
    // TODO: set
    IBroker internal immutable broker;
    IL2ToL2CrossDomainMessenger internal immutable messenger =
        IL2ToL2CrossDomainMessenger(Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER);

    mapping(uint256 => MessageCache) internal messageCaches;

    function initiate(
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenData[] calldata debitBundle,
        TokenData[] calldata creditBundle
    ) external payable returns (uint256 cacheNonce) {
        // 1. debitBundle.transfer(msg.sender, address(this))
        debitBundle.transferIn(msg.sender);
        // 2. call broker.handleMessage on hubChainId through messenger and get messgeHash
        cacheNonce = nonce;
        bytes memory onSuccessCallback = abi.encodeCall(IAgent.conclude, (cacheNonce));
        bytes memory onFailureCallback = abi.encodeCall(IAgent.rollback, (cacheNonce));

        bytes memory message;

        // TODO: Use Assembly Optimization
        message = abi.encodeCall(
            IBroker.handleMessage,
            (
                msg.sender,
                executor,
                executionData,
                recipientChainId,
                recipient,
                debitBundle,
                creditBundle,
                onSuccessCallback,
                onFailureCallback
            )
        );

        messenger.sendMessage(hubChainId, address(broker), message);

        // 3. cache msg.sender, and debitBundle under messageHash
        messageCaches[nonce] = MessageCache({sender: msg.sender, debitBundle: debitBundle});

        nonce += 1;
    }

    function release(address recipient, TokenData[] calldata creditBundle) external {
        // TODO: only from broker through messenger
        // TODO: creditBundle.transfer(address(this), recipient)
    }

    function conclude(uint256 messageNonce) external {
        // TODO: only from broker through messenger
        // TODO: delete messageCaches[messageHash]
    }

    function rollback(uint256 messageNonce) external {
        // TODO: only from broker through messenger
        // TODO:
        // 1. get sender and debitBundle from messageCaches[messageHash]
        // 2. debitBundle.transfer(address(this), sender)
        // 3. delete messageCaches[messageHash]
    }
}
