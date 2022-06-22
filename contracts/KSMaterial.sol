// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract KSMaterial is Initializable, OwnableUpgradeable, ERC1155BurnableUpgradeable {

    address private _operator;

    function initialize(string memory baseURI) public initializer   
    {
        __Ownable_init();
        __ERC1155_init(baseURI);
        __ERC1155Burnable_init_unchained();
    }

    function setOperator(address operator) public onlyOwner {
        _operator = operator;
    }

    function mint(address to, uint256 id, uint256 value) external {
        require(msg.sender == _operator, "not operator");
        _mint(to, id, value, "");
    }

    function mintBatch(address to, uint256[] calldata ids, uint256[] calldata values) external {
        require(msg.sender == _operator, "not operator");
        _mintBatch(to, ids, values, "");
    }
}