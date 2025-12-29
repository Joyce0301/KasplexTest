// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Ping {
    uint256 public counter = 1;

    function ping() external {
        counter += 1;
    }

    function get() external view returns (uint256) {
        return counter;
    }
}
