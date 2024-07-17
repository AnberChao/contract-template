// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title Standard ERC20 token
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 */

interface IERC20 {
    // 返回存在的代币总量
    function totalSupply() external view returns (uint256);

    // 返回某账户的余额
    function balanceOf(address account) external view returns (uint256);

    // 返回某账户允许另一账户从其账户中转出的代币数量
    function allowance(address owner, address spender) external view returns (uint256);

    // 在调用者账户上，为另一账户设置代币转出额度
    function approve(address spender, uint256 amount) external returns (bool);

    // 从调用者账户转移代币到另一账户
    function transfer(address recipient, uint256 amount) external returns (bool);

    // 从一个账户转移代币到另一个账户，前提是转出账户已经批准操作者账户进行相应金额的转出
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // 代币转移时触发
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 批准额度时触发
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is IERC20 {
    // 使用私有映射存储每个地址的代币余额
    mapping(address => uint256) private _balances;

    // 使用嵌套映射存储每个地址允许其他地址转出的代币数量
    mapping(address => mapping(address => uint256)) private _allowances;

    // 存储代币的总供应量
    uint256 private _totalSupply;

    // 存储代币的名称和符号
    string private _name;
    string private _symbol;

    // 构造函数用于初始化代币名称、符号和初始供应量
    constructor(string memory name_, string memory symbol_, uint256 initialSupply) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    // 返回代币的名称
    function name() public view returns (string memory) {
        return _name;
    }

    // 返回代币的符号
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // 返回代币的总供应量
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // 返回指定地址的代币余额
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // 实现代币的转移功能
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 返回允许某地址从调用者地址转出的代币量
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // 允许 spender 从调用者账户转出最多 amount 数量的代币
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 从 sender 到 recipient 转移 amount 代币，前提是已经获得足够的授权
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        _allowances[sender][msg.sender] -= amount;
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
