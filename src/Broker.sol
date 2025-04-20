// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IL2ToL2CrossDomainMessenger} from "./interfaces/external/IL2ToL2CrossDomainMessenger.sol";
import {IAgent} from "./interfaces/IAgent.sol";
import {IBroker} from "./interfaces/IBroker.sol";
import {IExchange} from "./interfaces/IExchange.sol";
import {IUnlockCallback} from "./interfaces/IUnlockCallback.sol";
import {Predeploys} from "./libraries/external/Predeploys.sol";
import {Errors} from "./libraries/Errors.sol";
import {TokenData} from "./models/TokenData.sol";

contract Broker is IBroker, IUnlockCallback {
    IAgent internal immutable agent;
    IExchange internal immutable exchange;
    IL2ToL2CrossDomainMessenger internal immutable messenger =
        IL2ToL2CrossDomainMessenger(Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER);

    constructor(address _agent, address _exchange) {
        agent = IAgent(_agent);
        exchange = IExchange(_exchange);
    }

    function handleMessage(
        address user,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenData[] calldata debitBundle,
        TokenData[] calldata creditBundle,
        bytes calldata onSuccessCallback,
        bytes calldata onFailureCallback
    ) external {
        (address sourceSender, uint256 sourceChainId) = messenger.crossDomainMessageContext();
        require(msg.sender == address(messenger), Errors.NotMessenger());
        require(sourceSender == address(agent), Errors.NotAgent());

        try Broker(this).selfHandleMessage(
            sourceChainId, user, executor, executionData, recipientChainId, recipient, debitBundle, creditBundle
        ) {
            if (onSuccessCallback.length > 0) messenger.sendMessage(sourceChainId, sourceSender, onSuccessCallback);
        } catch {
            if (onFailureCallback.length > 0) messenger.sendMessage(sourceChainId, sourceSender, onFailureCallback);
        }
    }

    function selfHandleMessage(
        uint256 sourceChainId,
        address user,
        address executor,
        bytes calldata executionData,
        uint256 recipientChainId,
        address recipient,
        TokenData[] calldata debitBundle,
        TokenData[] calldata creditBundle
    ) external {
        require(msg.sender == address(this), Errors.NotSelf());

        for (uint256 i = 0; i < debitBundle.length; i++) {
            exchange.debit(user, sourceChainId, debitBundle[i].token, debitBundle[i].amount);
        }

        exchange.unlock(abi.encode(executor, executionData));

        for (uint256 i = 0; i < creditBundle.length; i++) {
            exchange.credit(user, recipientChainId, creditBundle[i].token, creditBundle[i].amount);
        }

        messenger.sendMessage(
            recipientChainId, address(agent), abi.encodeCall(IAgent.release, (recipient, creditBundle))
        );
    }

    function unlockCallback(bytes calldata data) external returns (bytes memory result) {
        (address executor, bytes memory executionData) = abi.decode(data, (address, bytes));

        bool success;
        (success, result) = executor.call(executionData);
        require(success);
    }
}
