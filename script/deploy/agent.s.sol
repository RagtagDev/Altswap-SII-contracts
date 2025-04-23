// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Agent} from "src/Agent.sol";

contract DeployAgentScript is Script {
    function run() public returns (Agent agent) {
        address brokerDeployer = vm.envAddress("BROKER_ADDRESS");
        address broker = vm.computeCreateAddress(brokerDeployer, 0);

        vm.createSelectFork("SpokeChain");
        vm.startBroadcast(vm.envUint("AGENT_PRIVATE_KEY"));
        agent = new Agent(902, broker);
        vm.stopBroadcast();

        return agent;
    }
}
