// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Standard ERC721
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
 */

import "./IERC1155.sol";

contract ERC1155 is IERC1155 {
    // 存储每个token ID对应的所有者地址及其余额
    mapping(uint256 => mapping(address => uint256)) private _balances;
    // 存储所有者和操作员的授权状态
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // 构造函数
    constructor() {}

    // 查看指定地址的指定ID token的余额
    function balanceOf(
        address account,
        uint256 id
    ) public view override returns (uint256) {
        require(
            account != address(0),
            "ERC1155: balance query for the zero address"
        );
        return _balances[id][account];
    }

    // 批量查看多个地址的指定ID token的余额
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view override returns (uint256[] memory) {
        require(
            accounts.length == ids.length,
            "ERC1155: accounts and ids length mismatch"
        );

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    // 授权或撤销授权一个操作员管理所有token
    function setApprovalForAll(
        address operator,
        bool approved
    ) external override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // 检查指定操作员是否被授权管理指定地址的所有token
    function isApprovedForAll(
        address account,
        address operator
    ) public view override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    // 安全转移指定数量的token
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external override {
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "ERC1155: caller is not owner nor approved"
        );

        _balances[id][from] -= amount;
        _balances[id][to] += amount;

        emit TransferSingle(msg.sender, from, to, id, amount);
        _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, amount, data);
    }

    // 安全批量转移多个token
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external override {
        require(
            ids.length == amounts.length,
            "ERC1155: ids and amounts length mismatch"
        );
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "ERC1155: caller is not owner nor approved"
        );

        for (uint i = 0; i < ids.length; ++i) {
            _balances[ids[i]][from] -= amounts[i];
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);
        _doSafeBatchTransferAcceptanceCheck(
            msg.sender,
            from,
            to,
            ids,
            amounts,
            data
        );
    }

    // 辅助函数：单个转移后的安全检查
    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        uint256 size;
        assembly {
            size := extcodesize(to)
        }
        if (size > 0) {
            try
                IERC1155Receiver(to).onERC1155Received(
                    operator,
                    from,
                    id,
                    amount,
                    data
                )
            returns (bytes4 response) {
                require(
                    response == IERC1155Receiver.onERC1155Received.selector,
                    "ERC1155: ERC1155Receiver rejected tokens"
                );
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }
    // 辅助函数：批量转移后的安全检查
    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        uint256 size;
        assembly {
            size := extcodesize(to)
        }
        if (size > 0) {
            try
                IERC1155Receiver(to).onERC1155BatchReceived(
                    operator,
                    from,
                    ids,
                    amounts,
                    data
                )
            returns (bytes4 response) {
                require(
                    response ==
                        IERC1155Receiver.onERC1155BatchReceived.selector,
                    "ERC1155: ERC1155Receiver rejected tokens"
                );
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }
}
