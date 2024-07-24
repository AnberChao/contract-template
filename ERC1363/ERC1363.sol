// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20/ERC20.sol";

// 定义接收者接口，接收代币并处理额外的数据
interface IERC1363Receiver {
    // 在接收代币时调用，必须返回特定的选择器以确认实现了接口
    function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
}

// 定义批准者接口，批准代币使用并处理额外的数据
interface IERC1363Spender {
    // 在代币批准时调用，必须返回特定的选择器以确认实现了接口
    function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
}

// ERC-1363接口，扩展自ERC20标准接口
interface IERC1363 is IERC20 {
    // 定义在转账的同时调用合约的方法
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

contract ERC1363 is IERC1363, ERC20 {
    // 构造函数，初始化ERC20代币名称和符号
    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {}

    // 实现转账并调用功能
    function transferAndCall(address to, uint256 value, bytes calldata data) public override returns (bool) {
        // 调用内部转账方法
        ERC20._transfer(_msgSender(), to, value);
        // 检查并执行调用，确保交易正常完成
        require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer failed");
        return true;
    }

    // 实现从一个地址转账到另一个地址并调用功能
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) public override returns (bool) {
        // 从一个地址向另一个地址转账
        transferFrom(from, to, value);
        // 检查并执行调用，确保交易正常完成
        require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer failed");
        return true;
    }

    // 实现批准并调用功能
    function approveAndCall(address spender, uint256 value, bytes calldata data) public override returns (bool) {
        // 批准代币使用
        approve(spender, value);
        // 检查并执行调用，确保交易正常完成
        require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove failed");
        return true;
    }

    // 内部方法，用于检查并调用转账后的接收合约
    function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
        // 检查地址是否为合约地址
        if (isContract(to)) {
            try IERC1363Receiver(to).onTransferReceived(_msgSender(), from, value, data) returns (bytes4 retval) {
                // 确保返回的是正确的方法选择器
                return retval == IERC1363Receiver(to).onTransferReceived.selector;
            } catch (bytes memory reason) {
                // 处理调用失败的情况
                if (reason.length == 0) {
                    revert("ERC1363: transfer to non ERC1363Receiver implementer");
                } else {
                    // 将失败原因抛出
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
        return true;
    }

    // 内部方法，用于检查并调用批准后的接收合约
    function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
        if (isContract(spender)) {
            try IERC1363Spender(spender).onApprovalReceived(_msgSender(), value, data) returns (bytes4 retval) {
                return retval == IERC1363Spender(spender).onApprovalReceived.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC1363: approve to non ERC1363Spender implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
        return true;
    }

    // 辅助函数，用于检查一个地址是否是合约
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // 使用汇编获取代码大小
        assembly { size := extcodesize(account) }
        // 如果代码大小大于0，则为合约地址
        return size > 0;
    }
}
