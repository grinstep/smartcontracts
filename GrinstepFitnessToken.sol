// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * Grinstep Fitness Token
 * @author Grinstep
 */
contract GrinstepFitnessToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("GrinstepFitnessToken", "GFT") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
