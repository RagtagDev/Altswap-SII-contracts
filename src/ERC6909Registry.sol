// SPDX-License-Identifier: MIT
pragma solidity =0.8.29;

import {IERC6909Registry} from "./interfaces/IERC6909Registry.sol";

contract ERC6909Registry is IERC6909Registry {
    // TODO: event
    address public owner;
    uint256 public nextId = 1;

    mapping(bytes32 identifier => uint256 id) private _ids;
    mapping(uint256 id => mapping(uint256 chainId => address token)) public toToken;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, OwnableUnauthorizedAccount(msg.sender));
        _;
    }

    function _toIdentifier(uint256 chainId, address token) internal pure returns (bytes32 identifier) {
        assembly {
            mstore(0x00, chainId)
            mstore(0x20, token)

            identifier := keccak256(0, 0x40)
        }
    }

    function toID(uint256 chainId, address token) external view override returns (uint256 id) {
        bytes32 identifier = _toIdentifier(chainId, token);

        id = _ids[identifier];
    }

    function register(uint256 chainId, address token) external override onlyOwner returns (uint256 id) {
        bytes32 identifier = _toIdentifier(chainId, token);

        id = nextId;
        _ids[identifier] = nextId;
        toToken[id][chainId] = token;

        emit Registered(nextId, chainId, token);

        nextId += 1;
    }

    function setSubnodeToken(uint256 id, uint256 chainId, address token, bool isDelete) external override onlyOwner {
        bytes32 identifier = _toIdentifier(chainId, token);

        if (isDelete) {
            delete _ids[identifier];
            delete toToken[id][chainId];

            emit Deleted(id, chainId, token);
        } else {
            _ids[identifier] = id;
            toToken[id][chainId] = token;

            emit Registered(id, chainId, token);
        }
    }
}
