// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct TokenData {
    address token;
    uint256 amount;
}

using TokenDataLibrary for TokenData global;

library TokenDataLibrary {
    function transfer(TokenData[] memory self, address from, address to) internal {
        // TODO: use safe transfer
    }
}
