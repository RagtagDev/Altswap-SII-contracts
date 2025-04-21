// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct TokenData {
    address token;
    uint256 amount;
}

using TokenDataLibrary for TokenData global;

library TokenDataLibrary {
    error ETHTransferFailed();

    address public constant ADDRESS_ZERO = address(0);

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
    /// Reverts upon failure.
    function safeTransferFrom(TokenData memory self, address from, address to) internal {
        /// altered from https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol#L204

        address token = self.token;
        uint256 amount = self.amount;

        assembly ("memory-safe") {
            let m := mload(0x40) // Cache the free memory pointer.
            mstore(0x60, amount) // Store the `amount` argument.
            mstore(0x40, to) // Store the `to` argument.
            mstore(0x2c, shl(96, from)) // Store the `from` argument.
            mstore(0x0c, 0x23b872dd000000000000000000000000) // `transferFrom(address,address,uint256)`.
            let success := call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x7939f424) // `TransferFromFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x60, 0) // Restore the zero slot to zero.
            mstore(0x40, m) // Restore the free memory pointer.
        }
    }

    function safeTransferETH(address to, uint256 amount) internal {
        assembly ("memory-safe") {
            if iszero(call(gas(), to, amount, codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, 0xb12d13eb) // `ETHTransferFailed()`.
                revert(0x1c, 0x04)
            }
        }
    }

    /// @dev Sends `amount` of ERC20 `token` from the current contract to `to`.
    /// Reverts upon failure.
    function safeTransfer(TokenData memory self, address to) internal {
        address token = self.token;
        uint256 amount = self.amount;

        assembly ("memory-safe") {
            mstore(0x14, to) // Store the `to` argument.
            mstore(0x34, amount) // Store the `amount` argument.
            mstore(0x00, 0xa9059cbb000000000000000000000000) // `transfer(address,uint256)`.
            // Perform the transfer, reverting upon failure.
            let success := call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x90b8ec18) // `TransferFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x34, 0) // Restore the part of the free memory pointer that was overwritten.
        }
    }

    function transferIn(TokenData[] memory self, address from) internal {
        uint256 sumETHAmount = 0;
        for (uint256 i = 0; i < self.length; i++) {
            TokenData memory data = self[i];

            if (data.token == ADDRESS_ZERO) {
                sumETHAmount += data.amount;
            } else {
                data.safeTransferFrom(from, address(this));
            }
        }

        require(sumETHAmount == msg.value, ETHTransferFailed());
    }

    function transferOut(TokenData[] memory self, address to) internal {
        for (uint256 i = 0; i < self.length; i++) {
            TokenData memory data = self[i];
            if (data.token == ADDRESS_ZERO) {
                safeTransferETH(to, data.amount);
            } else {
                data.safeTransfer(to);
            }
        }
    }
}
