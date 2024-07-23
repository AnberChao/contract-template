// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    // 代币转移事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // 授权事件
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    // 全部授权事件
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // 必须实现的函数
    function balanceOf(address owner) external view returns (uint256 balance); // 获取一个地址的代币数量
    function ownerOf(uint256 tokenId) external view returns (address owner); // 获取代币的拥有者
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external; // 安全转移代币，包括数据
    function safeTransferFrom(address from, address to, uint256 tokenId) external; // 安全转移代币
    function transferFrom(address from, address to, uint256 tokenId) external; // 转移代币
    function approve(address to, uint256 tokenId) external; // 授权一个地址操作特定代币
    function setApprovalForAll(address operator, bool _approved) external; // 设置或取消一个操作者对所有代币的操作权限
    function getApproved(uint256 tokenId) external view returns (address operator); // 获取某个代币的授权地址
    function isApprovedForAll(address owner, address operator) external view returns (bool); // 查询一个地址是否被授权操作另一个地址的所有代币
}
