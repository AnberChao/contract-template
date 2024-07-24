// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC1155 {
    // 当单个token被转移时触发
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    // 当多个token同时被转移时触发
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
    // 当一个地址授权或撤销另一个地址管理其所有资产时触发
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    // 每当更新token的URI时触发
    event URI(string value, uint256 indexed id);

    // 返回指定地址指定ID token的余额
    function balanceOf(address account, uint256 id) external view returns (uint256);
    // 批量返回多个地址指定ID token的余额
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
    // 设置或撤销一个操作员管理所有者账户下所有token的权限
    function setApprovalForAll(address operator, bool approved) external;
    // 检查一个操作员是否有权管理指定地址的token
    function isApprovedForAll(address account, address operator) external view returns (bool);
    // 安全转移任意数量的token到指定地址
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
    // 安全批量转移多个token到指定地址
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}