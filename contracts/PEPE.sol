// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PEPE is ERC20, Ownable {
    constructor() ERC20("PEPE Token", "PEPE") {
        
    }

    function mint() external {
        _mint(msg.sender, 10e18);
    }
}