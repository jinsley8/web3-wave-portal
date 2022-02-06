// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    event NewWave(address indexed from, uint256 timestamp, string message);

    /* Custom Wave datatype */
    struct Wave {
      address waver; // The address of the user who waved.
      string message; // The message the user sent.
      uint256 timestamp; // The timestamp when the user waved.
    }

    /* waves avriable to store array of structs */
    Wave[] waves;

    constructor() {
       console.log("I AM SMART CONTRACT. POG.");
    }

    function wave(string memory _message) public {
      totalWaves += 1;
      console.log("%s waved w/ message %s", msg.sender, _message);

      /* store the wave data in the array. */
      waves.push(Wave(msg.sender, _message, block.timestamp));

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