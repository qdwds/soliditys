// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.1;

/**
菠菜 下注大小
 */
contract Bet {
    address public owner;   // 管理员
    bool public isFinshed;    // 游戏结束标志
    
    // 玩家结构信息，可以记录玩家及其下下注金额
    struct Player {
        address payable addr;
        uint amount;
    }

    // 下注大的人
    Player[] inBig;
    // 下注小的人
    Player[] inSmall;


    uint totalBig;
    uint totalSmall;
    uint nowtime;

    constructor () public {
        owner = msg.sender;
        totalSmall = 0;
        totalBig = 0;
        isFinshed = false;
        nowtime = now;
    }

    // 下注功能：选大小
    function stake(bool flag) public payable returns (bool) {
        require(msg.value > 0);

        //创建一个玩家
        Player memory p = Player(msg.sender, msg.value);

        if(flag){
            inBig.push(p);
            //  记录下注大的总金额
            totalBig += p.amount;
        }else{
            inSmall.push(p);
            //  记录下注小的总金额
            totalSmall += p.amount;
        }
        return true;
    }

    //  开奖功能：随机取一个值，然后分析大还是小
    function open() public returns (bool) {
        //  开奖时间限制
        require(now > nowtime + 5);
        //  游戏不必须是开启时候
        require(!isFinshed);
        // 求一个10以内的随机值0～8开小，9～17开打
        uint points = uint(keccak256(abi.encode(msg.sender, now, block.number))) % 18;
        uint i = 0;
        Player memory p;
        if(points >= 9){
            for (i = 0; i < inBig.length; i++) {
                p = inBig[i];
                // 玩家收入 = 下注本金 + 按比例分配的奖金
                p.addr.transfer(p.amount + totalSmall * p.amount / totalBig);
            }
        }else{
            // 开小：退还狭小的人本金 + 奖金
            for (i = 0; i < inSmall.length; i++) {
                p = inSmall[i];
                // 玩家收入 = 下注本金 + 按比例分配的奖金
                p.addr.transfer(p.amount + totalBig * p.amount / totalSmall);
            }
        }
        // 开奖智能开一次
        isFinshed = true;
        return true;
    }
}