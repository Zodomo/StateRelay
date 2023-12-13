// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.23;

import "../lib/LayerZero/contracts/interfaces/ILayerZeroReceiver.sol";
import "../lib/LayerZero/contracts/interfaces/ILayerZeroEndpoint.sol";

/**
 * @title StateRelay
 * @notice This contract allows any inheriting contract to perform state reads on other chains via bridges.
 * @dev The inheriting contract must use _preparePayload() to call _lzSend() and also must implement _processPayload()
 * @author Zodomo.eth (Farcaster/Telegram/Discord/Github: @zodomo, X: @0xZodomo, Email: zodomo@proton.me)
 * @custom:github https://github.com/Zodomo/StateRelay
 */
abstract contract StateRelay is ILayerZeroReceiver {
    /// @dev Thrown when anyone but the LZ endpoint tries to call lzReceive()
    error InvalidCaller();
    /// @dev Thrown when anyone but the relayer tries to message from the relay chain
    error InvalidSender();
    /// @dev Thrown when messages from any chain other than the target relay chain are received
    error InvalidSrcChain();

    /// @dev Address of the LayerZero Endpoint deployed to the same chain as StateRelay
    address public immutable lzEndpoint;

    /// @dev The trusted remote-style path (remote, local) for messages via LZ
    bytes public lzPath;
    /// @dev Address of StateRelayer on the destination chain with ID lzChainId
    address public stateRelayer;
    /// @dev LZ chain ID for chain with target StateRelayer on it
    uint16 public lzChainId;

    constructor(address stateRelayer_, address lzEndpoint_, uint16 lzChainId_) {
        lzPath = abi.encodePacked(stateRelayer_, address(this));
        stateRelayer = stateRelayer_;
        lzEndpoint = lzEndpoint_;
        lzChainId = lzChainId_;
    }

    /// @dev Implement this function if you need to adjust the default StateRelayer
    function _configureLz(uint16 lzChainId_, address stateRelayer_) internal virtual {
        lzChainId = lzChainId_;
        stateRelayer = stateRelayer_;
        lzPath = abi.encodePacked(stateRelayer_, address(this));
    }

    /// @dev Implement this function to prepare the payload for StateRelayer. If you don't know how to generate
    /// function calldata correctly, see CalldataHelper.sol. If `data` is left empty, addr's balance will be returned.
    /// @param addr Target address for StateRelayer to query
    /// @param data Calldata to be naively passed to addr
    function _preparePayload(address addr, bytes memory data) internal pure returns (bytes memory payload) {
        payload = abi.encodePacked(addr, data);
    }

    /// @dev Implement this function to send a message to the target StateRelayer with default LZ settings
    function _lzSend(bytes memory payload) internal {
        ILayerZeroEndpoint(lzEndpoint).send{value: msg.value}(
            lzChainId, lzPath, payload, payable(msg.sender), address(0), bytes("")
        );
    }

    /// @dev Implement this function to send a message to the target StateRelayer with custom LZ settings
    function _lzSend(bytes memory payload, address zroPaymentAddress, bytes calldata adapterParams) internal {
        ILayerZeroEndpoint(lzEndpoint).send{value: msg.value}(
            lzChainId, lzPath, payload, payable(msg.sender), zroPaymentAddress, adapterParams
        );
    }

    /// @dev Define this function in the child contract to handle processing the return data from StateRelayer. You are
    /// responsible for knowing what the return data of the contract being queried looks like.
    function _processPayload(bytes calldata payload) internal virtual;

    /// @dev This is called by LZ Endpoint to deliver StateRelayer's return data
    function lzReceive(uint16 srcChainId, bytes calldata srcAddress, uint64, bytes calldata payload) external {
        if (msg.sender != lzEndpoint) revert InvalidCaller();
        if (srcChainId != lzChainId) revert InvalidSrcChain();
        if (keccak256(srcAddress) != keccak256(lzPath)) revert InvalidSender();

        _processPayload(payload);
    }
}
