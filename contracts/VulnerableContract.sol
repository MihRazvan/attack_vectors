// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract VulnerableContract {

    mapping(address => uint256) public addressToValue;

    function deposit() public payable {
        addressToValue[msg.sender] = msg.value;
    }

    function withdraw() public {
        uint256 balance = addressToValue[msg.sender];
        if (!(balance > 0)) {
            revert("Must have funds!");
        }
        (bool sent, ) = msg.sender.call{value: balance}("");
        if (!sent) {
            revert("Transfer failed!");
        }
        addressToValue[msg.sender] = 0;
    }


}