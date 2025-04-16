// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IL2ToL2CrossDomainMessenger} from "@optimism/bedrock/L2/IL2ToL2CrossDomainMessenger.sol";
import {Predeploys} from "@optimism/bedrock/libraries/Predeploys.sol";
import {IAgent} from "./interfaces/IAgent.sol";
import {IBroker} from "./interfaces/IBroker.sol";
import {IExchange} from "./interfaces/IExchange.sol";
import {IUnlockCallback} from "./interfaces/IUnlockCallback.sol";
import {TokenBundle} from "./models/TokenBundle.sol";

contract Broker is IBroker, IUnlockCallback {
    // TODO: set
    IAgent internal immutable agent;
    // TODO: set
    IExchange internal immutable exchange;
    IL2ToL2CrossDomainMessenger internal immutable messenger =
        IL2ToL2CrossDomainMessenger(Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER);

    function handleMessage(
        bytes32 messageId,
        TokenBundle calldata retainBundle,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenBundle calldata releaseBundle
    ) external {
        // TODO: only from agent through messenger
        // TODO: debit retainBundle for messenger.crossDomainMessageSender into 6909 vault
        try exchange.unlock(abi.encode(executor, executionData)) {
            // TODO:
            // if recipientChainId == messenger.crossDomainMessageSource, call agent.conclude with messageId, recipient, releaseBundle
            // else call agent.release on recipientChainId with recipient, releaseBundle; and agent.conclude on messenger.crossDomainMessageSource with messageId
        } catch {
            // TODO:
            // call agent.rollback on messenger.crossDomainMessageSource with messageId
        }
    }

    function unlockCallback(bytes calldata data) external returns (bytes memory result) {
        (address executor, bytes memory executionData) = abi.decode(data, (address, bytes));

        bool success;
        (success, result) = executor.call(executionData);
        require(success);
    }
}
