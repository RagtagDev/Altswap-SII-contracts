// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.29;

import {Test, stdStorage, StdStorage} from "forge-std/Test.sol";
import {ERC6909Registry} from "../src/ERC6909Registry.sol";

contract ERC6909RegistryTest is Test {
    using stdStorage for StdStorage;

    event Registered(uint256 indexed id, uint256 indexed chainId, address indexed token);
    event Deleted(uint256 indexed id, uint256 indexed chainId, address indexed token);

    ERC6909Registry public registry;

    function setUp() public {
        registry = new ERC6909Registry(address(this));
    }

    function test_fuzz_register(uint256 chainId, address token) public {
        vm.expectEmit(true, true, true, false, address(registry));
        emit Registered(1, chainId, token);

        registry.register(chainId, token);

        assertEq(registry.toToken(registry.toID(chainId, token), chainId), token);
    }

    function test_fuzz_setSubnodeToken(uint256 id, uint256 chainId, address token) public {
        vm.expectEmit(true, true, true, false, address(registry));
        emit Registered(id, chainId, token);

        registry.setSubnodeToken(id, chainId, token, false);

        assertEq(registry.toToken(registry.toID(chainId, token), chainId), token);
        assertEq(registry.nextId(), 1);
    }

    function test_fuzz_deleteSubnodeToken(uint256 id, uint256 chainId, address token) public {
        registry.setSubnodeToken(id, chainId, token, false);

        vm.expectEmit(true, true, true, false, address(registry));
        emit Deleted(id, chainId, token);

        registry.setSubnodeToken(id, chainId, token, true);

        assertEq(registry.toToken(registry.toID(chainId, token), chainId), address(0));
    }

    function test_fuzz_register(uint256 nextId, uint256 chainId, address token) public {
        vm.assume(nextId < UINT256_MAX - 1);
        stdstore.target(address(registry)).sig("nextId()").checked_write(nextId);

        uint256 id = registry.register(chainId, token);
        assertEq(registry.toID(chainId, token), id);

        assertEq(nextId, id);
    }
}
