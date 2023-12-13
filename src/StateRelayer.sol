// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.23;

import "../lib/solady/src/auth/Ownable.sol";
import "../lib/LayerZero/contracts/interfaces/ILayerZeroReceiver.sol";
import "../lib/LayerZero/contracts/interfaces/ILayerZeroEndpoint.sol";

contract StateRelayer is Ownable, ILayerZeroReceiver {
    address public immutable lzEndpoint;

    constructor(address owner_, address lzEndpoint_) {
        _initializeOwner(owner_);
        lzEndpoint = lzEndpoint_;
    }

    function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload)
        external
    {}
}
