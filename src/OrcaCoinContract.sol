//Spdx-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OrcaCoinContract is ERC20 {
    address stakingContract;
    address owner;

    constructor(address _stakingContract) ERC20("OrcaCoin", "ORCA") {
        stakingContract = _stakingContract;
        owner = msg.sender;
    }

    function mint(address account, uint256 value) public {
        require(
            msg.sender == stakingContract,
            "Only the staking contract can mint tokens"
        );
        _mint(account, value);
    }

    function updateStakingContract(address _stakingContract) public {
        require(
            msg.sender == owner,
            "Only the owner can update the staking contract"
        );
        stakingContract = _stakingContract;
    }
}
