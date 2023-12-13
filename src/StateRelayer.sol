// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.23;

import "../lib/LayerZero/contracts/interfaces/ILayerZeroReceiver.sol";
import "../lib/LayerZero/contracts/interfaces/ILayerZeroEndpoint.sol";

/**
 * @title StateRelayer
 * @notice Permissionlessly performs state reads for external contracts and returns the results via the sending bridge.
 * @dev You must implement handling in StateRelay.sol to use StateRelayer properly!
 * @author Zodomo.eth (Farcaster/Telegram/Discord/Github: @zodomo, X: @0xZodomo, Email: zodomo@proton.me)
 * @custom:github https://github.com/Zodomo/StateRelay
 */
contract StateRelayer is ILayerZeroReceiver {
    /// @dev Thrown when anyone but the LZ endpoint tries to call lzReceive()
    error InvalidCaller();

    /// @dev Emitted when the call to the target address fails
    event CallFailed(address indexed target, bytes indexed data, bytes indexed result);

    /// @dev Address of the LayerZero Endpoint deployed to the same chain as StateRelayer
    address public immutable lzEndpoint;

    constructor(address lzEndpoint_) {
        lzEndpoint = lzEndpoint_;
    }

    function _lzSend(uint16 srcChainId, bytes calldata srcAddress, bytes memory payload) internal {
        ILayerZeroEndpoint(lzEndpoint).send{value: msg.value}(
            srcChainId, srcAddress, payload, payable(msg.sender), address(0), bytes("")
        );
    }

    function _lzSend(
        uint16 srcChainId,
        bytes calldata srcAddress,
        bytes memory payload,
        address zroPaymentAddress,
        bytes calldata adapterParams
    ) internal {
        ILayerZeroEndpoint(lzEndpoint).send{value: msg.value}(
            srcChainId, srcAddress, payload, payable(msg.sender), zroPaymentAddress, adapterParams
        );
    }

    /// @dev Decodes the payload to determine target address and calldata (if any)
    function _decodePayload(bytes memory payload) internal pure returns (address target, bytes memory data) {
        assembly {
            target := mload(add(payload, 32))
        }

        uint256 length = payload.length;
        if (length > 20) {
            assembly {
                // Allocate memory for the data
                data := mload(0x40) // Load the free memory pointer
                mstore(0x40, add(data, add(length, 0x20))) // Update the free memory pointer

                // Set the length of the data
                mstore(data, sub(length, 20))

                // Copy the data
                let startPtr := add(payload, 20)
                let endPtr := add(startPtr, sub(length, 20))
                for { let ptr := startPtr } lt(ptr, endPtr) { ptr := add(ptr, 32) } {
                    mstore(add(data, add(sub(ptr, startPtr), 0x20)), mload(ptr))
                }
            }
        }
    }

    /// @dev The call from LZ's Endpoint is what triggers the action on target. If no calldata is provided, then only
    /// the target's ETH balance is returned. Otherwise, the calldata is sent and the result (if any) is returned.
    function lzReceive(uint16 srcChainId, bytes calldata srcAddress, uint64, bytes calldata payload) external {
        if (msg.sender != lzEndpoint) revert InvalidCaller();

        (address target, bytes memory data) = _decodePayload(payload);

        // Return balance if no calldata is provided, otherwise execute call and return result (empty upon failure)
        if (data.length == 0) {
            _lzSend(srcChainId, srcAddress, abi.encodePacked(target.balance));
        } else {
            (bool success, bytes memory result) = target.call(data);
            if (!success) {
                emit CallFailed(target, data, result);
                _lzSend(srcChainId, srcAddress, bytes(""));
            } else {
                _lzSend(srcChainId, srcAddress, result);
            }
        }
    }
}
