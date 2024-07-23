// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SimpleRegistrar {
    ENSRegistry private registry; // ENS注册表合约实例
    bytes32 private rootNode;      // 根节点

    // 构造函数，初始化注册表合约地址和根节点
    constructor(ENSRegistry _registry, bytes32 _rootNode) {
        registry = _registry;
        rootNode = _rootNode;
    }

    // 注册一个新的子域
    function register(bytes32 label, address owner) public {
        bytes32 node = keccak256(abi.encodePacked(rootNode, label));
        registry.setSubnodeOwner(rootNode, label, owner);
    }
}
