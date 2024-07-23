// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
    // 存储所有代币的数组
    uint256[] private _allTokens; 
    // 按地址存储每个用户拥有的代币
    mapping(address => uint256[]) private _ownedTokens; 
    // tokenId到用户拥有代币索引的映射
    mapping(uint256 => uint256) private _ownedTokensIndex; 
    // tokenId到全局代币索引的映射
    mapping(uint256 => uint256) private _allTokensIndex; 

    constructor() {
        // 可以根据需要在这里初始化合约
    }

    // 返回总代币供应量
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    // 根据全局索引获取代币ID
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    // 根据拥有者和索引获取代币ID
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    // 重写_mint方法，以在铸造时更新枚举
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokenToAllTokensEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    // 将新铸造的代币添加到全局代币数组中，并更新索引映射
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    // 将新铸造的代币添加到拥有者的代币列表中，并更新索引映射
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
}
