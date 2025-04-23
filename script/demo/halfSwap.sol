// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {TestERC20} from "test/TestERC20.sol";
import {Agent} from "src/Agent.sol";
import {TokenData} from "src/models/TokenData.sol";

contract SuccessSwapScript is Script {
    TestERC20 tokenASpoke = TestERC20(address(0x5FbDB2315678afecb367f032d93F642f64180aa3));
    TestERC20 tokenBSpoke = TestERC20(address(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512));
    Agent agent = Agent(address(0x8464135c8F25Da09e49BC8782676a84730C318bC));

    address user = vm.envAddress("USER_ADDRESS");
    address recipient = user;

    function run() public {
        vm.createSelectFork("SpokeChain");
        console.log("Before swap: ");
        console.log("tokenA balance: ", tokenASpoke.balanceOf(user));
        // console.log("tokenB balance: ", tokenBSpoke.balanceOf(user));

        vm.startBroadcast(vm.envUint("USER_PRIVATE_KEY"));
        tokenASpoke.approve(address(agent), 1000 ether);
        tokenBSpoke.mint(address(agent), 1000 ether);

        bytes memory executionData = abi.encode(
            2,
            user,
            address(tokenASpoke),
            address(tokenBSpoke),
            0.1 ether
        );

        TokenData[] memory debitBundle = new TokenData[](1);
        debitBundle[0] = TokenData({token: address(tokenASpoke), amount: 0.1 ether});

        TokenData[] memory creditBundle = new TokenData[](2);
        creditBundle[0] = TokenData({token: address(tokenASpoke), amount: 0});
        creditBundle[1] = TokenData({token: address(tokenBSpoke), amount: 0});

        agent.initiate(address(0), executionData, 901, recipient, debitBundle, creditBundle);
    }
}
