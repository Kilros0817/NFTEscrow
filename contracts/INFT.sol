// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface INFT {
    function escrowFirstNFT(uint256, address) external;
    function transferFrom(address, address, uint256) external;
}