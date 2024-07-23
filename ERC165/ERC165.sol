// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

contract ERC165 is IERC165 {
    // 这个映射用于存储接口ID和该合约是否支持这个接口的信息
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() {
        // 注册ERC165接口
        _registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
    }

    // 实现ERC-165的supportsInterface方法
    function supportsInterface(bytes4 interfaceID) external view override returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    // 辅助函数，用于注册接口
    function _registerInterface(bytes4 interfaceID) internal {
        require(interfaceID != 0xffffffff, "Invalid interface request");
        _supportedInterfaces[interfaceID] = true;
    }
}
