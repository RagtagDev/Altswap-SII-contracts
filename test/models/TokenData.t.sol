// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.29;

import {Test} from "forge-std/Test.sol";
import {TokenData, TokenDataLibrary} from "../../src/models/TokenData.sol";
import {TestERC20} from "../TestERC20.sol";

contract TokenDataTest is Test {
    using TokenDataLibrary for TokenData[];

    TestERC20 public token;

    address public constant Alice = address(1);
    address public constant Bob = address(2);

    function setUp() public {
        token = new TestERC20(0);
    }

    function test_fuzz_safeTransferFrom(uint256 amount) public {
        vm.startPrank(Alice);
        token.mint(Alice, amount);
        token.approve(address(this), amount);
        vm.stopPrank();

        TokenData memory data = TokenData({token: address(token), amount: amount});
        data.safeTransferFrom(Alice, Bob);

        assertEq(token.balanceOf(Bob), amount);
    }
}
