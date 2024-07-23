// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Standard ERC721
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-777.md
 */

import "./IERC777.sol";

contract ERC777 is IERC777 {
    // 存储每个地址的余额
    mapping(address => uint256) private _balances;
    // 存储代币的总供应量
    uint256 private _totalSupply;

    // 存储操作员和其被授权的状态
    mapping(address => mapping(address => bool)) private _operators;

    // 合约构造器，设置初始供应量
    constructor(uint256 initialSupply) {
        _mint(msg.sender, initialSupply, "", "");
    }

    // 返回代币的总供应量
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // 返回指定地址的余额
    function balanceOf(address owner) public view override returns (uint256) {
        return _balances[owner];
    }

    // 实现代币发送功能，包括检查余额是否充足
    function send(address recipient, uint256 amount, bytes calldata data) external override {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Sent(msg.sender, msg.sender, recipient, amount, data, "");
    }

    // 授权一个操作员
    function authorizeOperator(address operator) external override {
        _operators[msg.sender][operator] = true;
        emit AuthorizedOperator(operator, msg.sender);
    }

    // 撤销一个操作员
    function revokeOperator(address operator) external override {
        _operators[msg.sender][operator] = false;
        emit RevokedOperator(operator, msg.sender);
    }

    // 检查是否为操作员
    function isOperatorFor(address operator, address tokenHolder) public view override returns (bool) {
        return _operators[tokenHolder][operator];
    }

    // 内部函数，用于铸造代币
    function _mint(address to, uint256 amount, bytes memory data, bytes memory operatorData) internal {
        _totalSupply += amount;
        _balances[to] += amount;
        emit Minted(msg.sender, to, amount, data, operatorData);
    }

    // 简单的销毁功能，从调用者的账户中减少代币
    function burn(uint256 amount, bytes calldata data) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Burned(msg.sender, msg.sender, amount, data, "");
    }
}