// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WhizGame {
    // Struct to store the details of the player
    struct Gamer {
        address gamerAddress;
        Stage stage;
    }

    // Enum to store the stage of the player
    enum Stage {
        Silver,
        Gold,
        Premium
    }

    // Mapping to store the player details
    mapping(address => Gamer) public gamers;

    // Mapping to keep track of players' balances
    mapping(address => uint) public balances;

    // Define the amount required to enter each stage
    uint256 public silverAmount = 0.1 ether;
    uint256 public goldAmount = 0.2 ether;
    uint256 public premiumAmount = 0.3 ether;

    // Function to enter the game
    function enterGame() public payable {
        // Ensure that the amount sent is at least the minimum for Silver stage
        require(msg.value >= silverAmount, "Insufficient amount to enter the game");

        // Determine the stage of the player based on the amount sent
        Stage stage;
        if (msg.value >= premiumAmount) {
            stage = Stage.Premium;
        } else if (msg.value >= goldAmount) {
            stage = Stage.Gold;
        } else {
            stage = Stage.Silver;
        }

        // Store the player details in the mapping
        gamers[msg.sender] = Gamer(msg.sender, stage);

        // Update the gamer's balance
        balances[msg.sender] += msg.value;
    }

    // Function to withdraw the balance
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance to withdraw");

        // Reset the balance
        balances[msg.sender] = 0;

        // Transfer the amount to the player
        payable(msg.sender).transfer(amount);
    }
}
