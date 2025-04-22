// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IL2ToL2CrossDomainMessenger} from "./interfaces/external/IL2ToL2CrossDomainMessenger.sol";
import {IAgent} from "./interfaces/IAgent.sol";
import {IBroker} from "./interfaces/IBroker.sol";
import {Predeploys} from "./libraries/external/Predeploys.sol";
import {TokenData, TokenDataLibrary} from "./models/TokenData.sol";
import {Errors} from "./libraries/Errors.sol";

contract Agent is IAgent {
    using TokenDataLibrary for TokenData[];

    struct MessageCache {
        address sender;
        TokenData[] debitBundle;
    }

    uint256 public nonce;
    uint256 internal immutable hubChainId;
    IBroker internal immutable broker;
    IL2ToL2CrossDomainMessenger internal immutable messenger =
        IL2ToL2CrossDomainMessenger(Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER);

    mapping(uint256 => MessageCache) internal messageCaches;

    constructor(uint256 _hubChainId, address _broker) {
        hubChainId = _hubChainId;
        broker = IBroker(_broker);
    }

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

    modifier onlyBroker() {
        // only from broker through messenger
        (address sourceSender, uint256 sourceChainId) = messenger.crossDomainMessageContext();

        require(msg.sender == address(messenger), Errors.NotMessenger());
        require(sourceSender == address(broker), Errors.NotBroker());
        require(hubChainId == sourceChainId, Errors.NotHubChain());

        _;
    }

    function release(address recipient, TokenData[] calldata creditBundle) external onlyBroker {
        // creditBundle.transfer(address(this), recipient)
        creditBundle.transferOut(recipient);
    }

    function conclude(uint256 messageNonce) external onlyBroker {
        delete messageCaches[messageNonce];
    }

    function rollback(uint256 messageNonce) external onlyBroker {
        // 1. get sender and debitBundle from messageCaches[messageHash]
        MessageCache memory messageCache = messageCaches[messageNonce];
        // 2. debitBundle.transfer(address(this), sender)
        messageCache.debitBundle.transferOut(messageCache.sender);
        // 3. delete messageCaches[messageHash]
        delete messageCaches[messageNonce];
    }
}
