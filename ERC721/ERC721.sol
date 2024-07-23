// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Standard ERC721
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */

import "./IERC721.sol";

contract ERC721 is IERC721 {
    // 代币名称和代号
    string public name;
    string public symbol;

    // 映射表：tokenId 到拥有者地址
    mapping(uint256 => address) private _owners;
    // 映射表：拥有者地址到拥有代币数量
    mapping(address => uint256) private _balances;
    // 映射表：tokenId 到授权地址
    mapping(uint256 => address) private _tokenApprovals;
    // 映射表：拥有者到操作者的全授权状态
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // 构造函数，设置代币名称和代号
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    // 获取指定地址的代币数量
    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "Address zero is not a valid owner");
        return _balances[owner];
    }

    // 获取指定tokenId的拥有者地址
    function ownerOf(uint256 tokenId) public view override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token ID does not exist");
        return owner;
    }

    // 安全转移代币，包括数据的重载版本
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) public override {
        _safeTransfer(from, to, tokenId, data);
    }

    // 安全转移代币
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        _safeTransfer(from, to, tokenId, "");
    }

    // 转移代币
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Caller is not owner nor approved"
        );
        _transfer(from, to, tokenId);
    }

    // 授权一个地址操作特定的代币
    function approve(address to, uint256 tokenId) public override {
        address owner = ownerOf(tokenId);
        require(to != owner, "Approval to current owner");
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    // 设置或取消一个操作者对所有代币的操作权限
    function setApprovalForAll(
        address operator,
        bool approved
    ) public override {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    // 获取某个代币的授权地址
    function getApproved(
        uint256 tokenId
    ) public view override returns (address) {
        require(_owners[tokenId] != address(0), "Token ID does not exist");
        return _tokenApprovals[tokenId];
    }

    // 查询一个地址是否被授权操作另一个地址的所有代币
    function isApprovedForAll(
        address owner,
        address operator
    ) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    // 内部函数，用于安全转移代币，包括接收者能否接收代币的检查
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    // 内部函数，用于转移代币
    function _transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "Transfer of token that is not own");
        require(to != address(0), "Transfer to the zero address");

        _approve(address(0), tokenId); // 清除之前的授权
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    // 内部函数，用于设置代币的授权
    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    // 内部函数，设置或取消一个操作者对所有代币的操作权限
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal {
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    // 内部函数，检查接收者是否可以接收ERC721代币
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        // 这里通常需要实现ERC721接收接口的检查，以确保接收者能够处理ERC721代币
        return true;
    }

    // 内部函数，检查调用者是否为代币的拥有者或已被授权
    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(tokenId); // 获取代币的拥有者
        // 返回调用者是否为拥有者、已被拥有者授权或被授权管理所有代币
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }
}
