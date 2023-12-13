// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.23;

/**
 * @title CalldataHelper
 * @notice This contract has helper functions to assist users with preparing function calldata. Implement these if you
 * don't know how to generate calldata manually or want to provide external interfaces to help your users with making
 * arbitrary calls.
 * @dev Only provide the string portion of the function signature for funcSig in any function!
 * @author Zodomo.eth (Farcaster/Telegram/Discord/Github: @zodomo, X: @0xZodomo, Email: zodomo@proton.me)
 * @custom:github https://github.com/Zodomo/StateRelay
 */
library CalldataHelper {
    function getCalldata(string memory funcSig) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig);
    }

    function getCalldata(string memory funcSig, bool val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }

    function getCalldata(string memory funcSig, bytes4 val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }

    function getCalldata(string memory funcSig, address val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }

    function getCalldata(string memory funcSig, address val1, address val2) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val1, val2);
    }

    function getCalldata(string memory funcSig, address val1, uint256 val2) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val1, val2);
    }

    function getCalldata(string memory funcSig, address[] memory val1, uint256[] memory val2)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSignature(funcSig, val1, val2);
    }

    function getCalldata(string memory funcSig, int256 val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }

    function getCalldata(string memory funcSig, uint256 val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }

    function getCalldata(string memory funcSig, bytes32 val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }

    function getCalldata(string memory funcSig, bytes memory val) external pure returns (bytes memory) {
        return abi.encodeWithSignature(funcSig, val);
    }
}
