// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint256) public addressToValue;

    // Event declarations
    event Deposit(address indexed depositor, uint256 amount);
    event WithdrawInitiated(address indexed withdrawer, uint256 amount);
    event WithdrawCompleted(address indexed withdrawer, uint256 amount);

    function deposit() public payable {
        if (msg.value <= 0) {
            revert("Must be >0 transaction");
        }
        addressToValue[msg.sender] = msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() public {
        uint256 balance = addressToValue[msg.sender];

        emit WithdrawInitiated(msg.sender, balance);

        (bool sent, ) = msg.sender.call{value: balance}("");
        if (!sent) {
            revert("Transfer failed!");
        }

        addressToValue[msg.sender] = 0;

        emit WithdrawCompleted(msg.sender, balance);
    }
}