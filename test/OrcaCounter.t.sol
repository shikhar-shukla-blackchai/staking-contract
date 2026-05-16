// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/OrcaCoinContract.sol";

contract OrcaCoinTest is Test {
    OrcaCoinContract orcaCoin;

    address user = 0xdf883080e30c1944f84d6C9eE75adf43e59E772E;

    function setUp() public {
        orcaCoin = new OrcaCoinContract(address(this));
    }

    function testInitialSupply() public view {
        assert(orcaCoin.totalSupply() == 0);
    }

    // function testFailMint() public {
    //     vm.startPrank(user);
    //     orcaCoin.mint(user, 100);
    //     // vm.stopPrank();
    // }

    function test_RevertIf_NonOwnerMint() public {
        vm.startPrank(user);
        vm.expectRevert();
        orcaCoin.mint(user, 100);
    }

    function testMint() public {
        orcaCoin.mint(address(this), 100);
        assert(orcaCoin.balanceOf(address(this)) == 100);
    }

    function testChangingStakingContract() public {
        orcaCoin.updateStakingContract(user);
        vm.startPrank(user);
        orcaCoin.mint(user, 100);
        assert(orcaCoin.balanceOf(user) == 100);
    }
}
