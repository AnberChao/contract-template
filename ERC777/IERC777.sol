// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC777 {
    // 返回代币的总供应量
    function totalSupply() external view returns (uint256);
    // 返回指定地址的余额
    function balanceOf(address owner) external view returns (uint256);
    // 从调用者地址向另一个地址发送代币
    function send(address recipient, uint256 amount, bytes calldata data) external;

    // 授权一个操作员管理调用者的代币
    function authorizeOperator(address operator) external;
    // 撤销一个操作员的管理权限
    function revokeOperator(address operator) external;
    // 检查指定的操作员是否被授权管理指定持有者的代币
    function isOperatorFor(address operator, address tokenHolder) external view returns (bool);

    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );
    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
    event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}