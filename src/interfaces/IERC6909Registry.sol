// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC6909Registry {
    /// @notice Throw when register id is not owner
    error OwnableUnauthorizedAccount(address account);

    /// @dev Emitted when a new ERC6909 ID has been registered
    /// @param id The ERC6909 ID.
    /// @param chainId The chain ID.
    /// @param token The address of the token.
    event Registered(uint256 indexed id, uint256 indexed chainId, address indexed token);

    /// @dev Emitted when a token has been deleted from an ERC6909 ID
    /// @param id The ERC6909 ID.
    /// @param chainId The chain ID.
    /// @param token The address of the token.
    event Deleted(uint256 indexed id, uint256 indexed chainId, address indexed token);

    /// @dev Submits and reserves a new ERC6909 ID
    /// @param chainId The chain ID.
    /// @param token The address of the token.
    /// @return The ERC6909 ID.
    function register(uint256 chainId, address token) external returns (uint256);

    /// @dev Add a token to an existing ERC6909 ID
    /// @param id The ERC6909 ID.
    /// @param chainId The chain ID.
    /// @param token The address of the token.
    function setSubnodeToken(uint256 id, uint256 chainId, address token, bool isDelete) external;

    /// @dev Use chainId and token to get the ERC6909 ID
    /// @param chainId The chain ID.
    /// @param token The address of the token.
    /// @return The ERC6909 ID.
    function toID(uint256 chainId, address token) external view returns (uint256);

    /// @dev Use ERC6909 ID and chainId to get the token
    /// @param id The ERC6909 ID.
    /// @param chainId The chain ID.
    /// @return The address of the token.
    function toToken(uint256 id, uint256 chainId) external view returns (address);
}
