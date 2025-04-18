// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct TokenBundle {
    address[] tokens;
    uint256[] amounts;
}

using TokenBundleLibrary for TokenBundle global;

library TokenBundleLibrary {
    function transfer(TokenBundle memory self, address from, address to) internal {
        // TODO: use safe transfer
    }
}
