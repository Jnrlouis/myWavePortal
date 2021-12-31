// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "hardhat/console.sol";
contract WavePortal {

    event NewWave(address indexed from, uint256 timestamp, string message);
    event Received(address, uint);

    mapping (address => uint) public lastWavedAt;


    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }


    Wave[] waves;
    constructor() payable {
        console.log("If I was an Anime Character, I'd be a combination of Saitama, Dio Brando and L");

    }
    uint totalWaves;

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 60 minutes < block.timestamp,
            "Relaxxx... Wait for an hour"
        );

        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        console.log("%s has waved with message %s", msg.sender, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        emit NewWave(msg.sender, block.timestamp, _message);

        uint256 prizeAmount = 0.05 ether;
        require(
            prizeAmount <= address(this).balance,
            "All out on ether right now :( Try again later."
            );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
    }

    function getAllWaves () public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves () public view returns (uint) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    receive () external payable {
        emit Received(msg.sender, msg.value);
    }

}