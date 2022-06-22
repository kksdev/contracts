// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KSToken is ERC20, ERC20Burnable, Ownable {
  constructor (string memory _name, string memory _symbol, uint256 _supply ) ERC20(_name, _symbol) {
    _mint(msg.sender, _supply*10**18);
  }

}

