//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/StakingContract.sol";

contract StakingContractTest is Test {
    StakingContract stakingContract;

    address user = 0xdf883080e30c1944f84d6C9eE75adf43e59E772E;

    receive() external payable {}

    function setUp() public {
        stakingContract = new StakingContract();
    }

    function testStake() public {
        stakingContract.stake{value: 200}();
        assert(stakingContract.balanceOf(address(this)) == 200);
    }

    function testStakingUser() public {
        vm.startPrank(user);
        vm.deal(user, 10 ether);
        stakingContract.stake{value: 200}();
        assert(stakingContract.balanceOf(address(user)) == 200);
        vm.stopPrank();
    }

    function testUnstake() public {
        stakingContract.stake{value: 200}();
        stakingContract.unstake(100);
        assert(stakingContract.balanceOf(address(this)) == 100);
    }

    function test_revertIf_Unstake() public {
        stakingContract.stake{value: 200}();
        vm.expectRevert();
        stakingContract.unstake(300);
        assert(stakingContract.balanceOf(address(this)) == 200);
    }
}
