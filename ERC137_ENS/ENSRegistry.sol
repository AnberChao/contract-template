// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IENSResolver {
    function resolve(bytes32 node) external view returns (address);
}

contract ENSRegistry {
    struct Record {
        address owner;          // 域名的所有者
        IENSResolver resolver;  // 与域名关联的解析器
    }

    mapping(bytes32 => Record) records; // 域名hash到记录的映射

    // 仅允许域名所有者调用的修改器
    modifier onlyOwner(bytes32 node) {
        require(msg.sender == records[node].owner, "Not owner");
        _;
    }

    // 设置新的域名所有者
    function setOwner(bytes32 node, address newOwner) public onlyOwner(node) {
        records[node].owner = newOwner;
    }

    // 设置新的域名解析器
    function setResolver(bytes32 node, IENSResolver newResolver) public onlyOwner(node) {
        records[node].resolver = newResolver;
    }

    // 创建子域并分配所有者
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public onlyOwner(node) {
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        records[subnode].owner = owner;
    }

    // 根据域名解析到相应的地址
    function resolve(bytes32 node) public view returns (address) {
        return records[node].resolver.resolve(node);
    }
}
