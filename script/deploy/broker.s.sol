// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Broker} from "src/Broker.sol";
import {Exchange} from "test/mocks/MockExchange.sol";

contract DeployBrokerScript is Script {
    function run() public returns (Broker broker, Exchange exchange) {
        address agentDeployer = vm.envAddress("AGENT_ADDRESS");
        address agent = vm.computeCreateAddress(agentDeployer, 0);
        address exchangeDeployer = vm.envAddress("EXCHANGE_ADDRESS");
        address exchangeAddress = vm.computeCreateAddress(exchangeDeployer, 0);
        address registryDeployer = vm.envAddress("WALLET_ADDRESS");
        address registry = vm.computeCreateAddress(registryDeployer, 2);

        vm.createSelectFork("HubChain");
        vm.startBroadcast(vm.envUint("BROKER_PRIVATE_KEY"));
        broker = new Broker(agent, exchangeAddress);
        vm.stopBroadcast();

        vm.startBroadcast(vm.envUint("EXCHANGE_PRIVATE_KEY"));
        exchange = new Exchange(address(broker), registry);
        vm.stopBroadcast();
    }
}
