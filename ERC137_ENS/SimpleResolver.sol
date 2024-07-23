// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SimpleResolver {
    mapping(bytes32 => address) public addresses; // 节点到地址的映射

    // 设置域名的地址
    function setAddress(bytes32 node, address addr) public {
        addresses[node] = addr;
    }

    // 解析域名到地址
    function resolve(bytes32 node) external view returns (address) {
        return addresses[node];
    }
}
