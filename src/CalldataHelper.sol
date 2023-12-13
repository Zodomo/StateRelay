// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.23;

contract CalldataHelper {
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
