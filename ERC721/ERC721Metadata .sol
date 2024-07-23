// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract ERC721Metadata is ERC721 {
    // 存储NFT的名称
    string private _name;
    // 存储NFT的符号
    string private _symbol; 
    // 存储每个tokenId的元数据URI
    mapping(uint256 => string) private _tokenURIs; 

    // 构造函数用于初始化合约时设置NFT的名称和符号
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // 返回NFT的名称
    function name() public view  returns (string memory) {
        return _name;
    }

    // 返回NFT的符号
    function symbol() public view  returns (string memory) {
        return _symbol;
    }

    // 通过tokenId获取元数据URI
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    // 内部函数，用于设置指定tokenId的URI
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }
}
