// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {TestERC20} from "test/TestERC20.sol";
import {ERC6909Registry} from "src/ERC6909Registry.sol";

contract DeployTokenScript is Script {
    function run()
        public
        returns (
            TestERC20 tokenASpoke,
            TestERC20 tokenBSpoke,
            TestERC20 tokenAHub,
            TestERC20 tokenBHub,
            ERC6909Registry registry
        )
    {
        address user = vm.envAddress("USER_ADDRESS");
        address wallet = vm.envAddress("WALLET_ADDRESS");

        vm.createSelectFork("SpokeChain");
        vm.startBroadcast(vm.envUint("WALLET_PRIVATE_KEY"));
        tokenASpoke = new TestERC20(0);
        tokenBSpoke = new TestERC20(0);

        tokenASpoke.mint(user, 100 ether);
        vm.stopBroadcast();

        vm.createSelectFork("HubChain");
        vm.startBroadcast(vm.envUint("WALLET_PRIVATE_KEY"));
        tokenAHub = new TestERC20(0);
        tokenBHub = new TestERC20(0);

        registry = new ERC6909Registry(wallet);

        uint256 id = registry.register(901, address(0));
        registry.setSubnodeToken(id, 902, address(0), false);

        id = registry.register(901, address(tokenASpoke));
        registry.setSubnodeToken(id, 902, address(tokenAHub), false);

        id = registry.register(901, address(tokenBSpoke));
        registry.setSubnodeToken(id, 902, address(tokenBHub), false);
        vm.stopBroadcast();
    }
}
