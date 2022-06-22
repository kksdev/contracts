// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract KSEquip is Initializable, OwnableUpgradeable, ERC721EnumerableUpgradeable {

    using CountersUpgradeable for CountersUpgradeable.Counter;

    address private _factory;
    address private _signer;
    CountersUpgradeable.Counter private _tokenIdTracker;
    mapping (uint256=>uint32) private _equip;
    //mapping (bytes32=>bool) private _check;

    event MintKSEquip(address indexed minter, uint256 indexed id, uint32 equipId);

    function initialize(address signer) public initializer   
    {
        __Ownable_init();
        __ERC721_init("KSEQUIP", "KSEQUIP");
        _signer = signer;
    }

    function setOperator(address factory) public onlyOwner {
        _factory = factory;
    }

    function setSigner(address signer) public onlyOwner {
        _signer = signer;
    }

    // function mint(address user, uint32[] calldata equipIds, uint64 rand, uint8 v, bytes32 r, bytes32 s) external {
    //     bytes32 hash = keccak256(abi.encode(user,equipIds,rand));

    //     require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == _signer, "signature error");
    //     require(!_check[hash], "already minted");

    //     for (uint8 i=0; i<equipIds.length; i++ ) {
    //         _tokenIdTracker.increment();
    //         uint256 newTokenId = _tokenIdTracker.current();
    //         _mint(user, newTokenId);
    //         _equip[newTokenId] = equipIds[i];
    //         emit MintKSEquip(user, newTokenId, equipIds[i]);
    //     }

    //     _check[hash] = true;
    // }

    function mint(address user, uint32 equipId) public {
        require(msg.sender == _factory, "not factory");

        _tokenIdTracker.increment();
        uint256 newTokenId = _tokenIdTracker.current();
        _mint(user, newTokenId);
        _equip[newTokenId] = equipId;
        emit MintKSEquip(user, newTokenId, equipId);
    }

    function getEquipId(uint256 id) public view returns (uint32) {
        return _equip[id];
    }

    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
        delete _equip[tokenId];
    }
}