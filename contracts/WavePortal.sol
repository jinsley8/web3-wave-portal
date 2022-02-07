// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    /** help gneerate random number */
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    /* Custom Wave datatype */
    struct Wave {
      address waver; // The address of the user who waved.
      string message; // The message the user sent.
      uint256 timestamp; // The timestamp when the user waved.
    }

    /* waves avriable to store array of structs */
    Wave[] waves;

    /*
     * This is an address => uint mapping to associate an address with a number.
     * In this case, store the address with the last time the user waved at us.
    */
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
      console.log("We have been constructed!");

      /** Set the initial seed */
      seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
      /** Make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored */
      require(
        lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
        "Wait 15m"
      );

      /** Update the current timestamp we have for the user */
      lastWavedAt[msg.sender] = block.timestamp;

      totalWaves += 1;
      console.log("%s waved w/ message %s", msg.sender, _message);

      /* store the wave data in the array. */
      waves.push(Wave(msg.sender, _message, block.timestamp));

      /** Generate a new seed for the next user that sends a wave */
      seed = (block.difficulty + block.timestamp + seed) % 100;

      console.log("Random # generated: %d", seed);

      /** Give a 50% chance that the user wins the prize. */
      if (seed <= 50) {
          console.log("%s won!", msg.sender);

        /** Send the prize. */
        uint256 prizeAmount = 0.0001 ether;

        require(
          prizeAmount <= address(this).balance,
          "Trying to withdraw more money than the contract has."
        );

        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
      }

      emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
      return waves;
    }

    function getTotalWaves() public view returns (uint256) {
      console.log("We have %d total waves!", totalWaves);
      return totalWaves;
    }
}