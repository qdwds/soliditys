// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0-0;

//  一个只有创建者才能调用的合约
contract Owner {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    //  定义一个只有 `合约创建者才能调用的 函数修饰器`
    modifier isOwner() {
        //  如果不是合约创建者就恢复最初
        if (msg.sender != owner) revert();
        _;
    }

    //  只有创建者才能调用该函数
    function get() public view isOwner returns (string memory) {
        return "msg";
    }

    //获取合约余额
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function gBalance() public view returns (uint256) {
        return owner.balance;
    }

    function getBalance() public view returns (int256) {
        return address(this).balance;
    }
}
