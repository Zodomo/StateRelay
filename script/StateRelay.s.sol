// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";

contract StateRelayScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }
}
