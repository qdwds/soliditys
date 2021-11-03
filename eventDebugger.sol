// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 <0.9;
// 通过event 调试

contract event_debugger {
    struct User {
        string name;
        uint256 age;
    }

    User public amdinUser;

    //  事件定义：可以在log日志中查看到传入的数据
    event setAge(address _owner, uint256 _age);

    constructor () public {
        amdinUser.name = "amdin";
        amdinUser.age = 18;
    }

    function setAge1(uint256 _age) public {
        // 注意⚠️：这里的user是adminUser的一个拷贝
        User memory user = amdinUser;
        //  拷贝的文件修改后 adminUser是不会改变的
        user.age = _age;
        //  事件调用
        emit setAge(msg.sender, _age);
    }

    function setAge2(uint256 _age) public {
        //  引用类型：user就是adminUser
        User storage user = amdinUser;
        //  直接改变的adminUser本身
        user.age = _age;
        //  调用事件
        emit setAge(msg.sender, _age);
    }
}

