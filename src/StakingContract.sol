//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/OrcaCoinContract.sol";

contract StakingContract {
    mapping(address => uint256) public balance;
    mapping(address => uint256) public unClaimedRewards;
    mapping(address => uint256) public lastUpdateTime;
    constructor() {}

    function stake() public payable {
        require(msg.value > 0, "Must stake some Ether");
        if (!lastUpdateTime[msg.sender]) {
            lastUpdateTime[msg.sender] = block.timestamp
        }
        else {
            unClaimedRewards[msg.sender] += (block.timestamp - lastUpdateTime[msg.sender]) * balance[msg.sender];
            lastUpdateTime[msg.sender] = block.timestamp;
        }
        balance[msg.sender] += msg.value;
    }

    function unstake(uint _amount) public {
        require(balance[msg.sender] >= _amount, "Not enough staked balance");

        unClaimedRewards[msg.sender] += (block.timestamp - lastUpdateTime[msg.sender]) * balance[msg.sender];
        lastUpdateTime[msg.sender] = block.timestamp; 

        balance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function getReward(address _address) public view {
        uint currentReward = unClaimedRewards[_address];
        uint updateTime = lastUpdateTime[_address];
        uint newReward = (block.timestamp - updateTime) * balance[_address];
        return currentReward + newReward;
    }

    function claimReward() public {
        uint currentReward = unClaimedRewards[msg.sender];
        uint updateTime = lastUpdateTime[msg.sender];
        uint newReward = (block.timestamp - updateTime) * balance[msg.sender];
        
        unClaimedRewards[msg.sender] = 0;
        lastUpdateTime[msg.sender] = block.timestamp;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return balance[_address];
    }
}
