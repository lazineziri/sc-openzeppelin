// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimplePayment
 * @dev A simple smart contract to receive and track Ether payments.
 */
contract SimplePayment {

    // Store the address of the owner of the contract
    address public owner;

    // Store total balance of the contract
    uint public totalReceived;

    // Event triggered when Ether is received
    event PaymentReceived(address from, uint amount);

    // Constructor sets the contract owner and makes it payable
    constructor() payable {
        owner = msg.sender;

        // If any Ether is sent during deployment, it updates the total balance
        totalReceived = msg.value;

        // Emit an event for the initial payment (if any)
        if (msg.value > 0) {
            emit PaymentReceived(msg.sender, msg.value);
        }
    }

    /**
     * @dev Payable function to receive Ether
     */
    function pay() public payable {
        // Check if the value sent is greater than 0
        require(msg.value > 0, "Must send some Ether");

        // Update the total received balance
        totalReceived += msg.value;

        // Emit an event for the payment
        emit PaymentReceived(msg.sender, msg.value);
    }

    /**
     * @dev Function to check the contract balance
     * @return balance The contract's Ether balance
     */
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    /**
     * @dev Only the owner can withdraw Ether from the contract
     * @param amount The amount of Ether to withdraw
     */
    function withdraw(uint amount) public {
        // Only the contract owner can withdraw
        require(msg.sender == owner, "Only the owner can withdraw");

        // Ensure there's enough balance to withdraw
        require(amount <= address(this).balance, "Insufficient balance");

        // Transfer the amount to the owner
        payable(owner).transfer(amount);
    }
}
//Payable function will be called when the contract has been deployed.