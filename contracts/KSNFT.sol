// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "./KSEquip.sol";
import "./AttrConfig.sol";

contract KSNFT is Initializable, ERC721EnumerableUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMathUpgradeable for uint256;
    using SafeMathUpgradeable for uint16;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using StringsUpgradeable for *;

    string private EMPTY_STRING;

    uint256 public MAX_ELEMENTS;
    uint256 public PRICE;

    address payable devAddress;
    uint256 private devFee;


    bool private PAUSE;

    uint256 private MaxExp;
    address private factory_address;

    CountersUpgradeable.Counter private _tokenIdTracker;

    struct BaseTokenUriById {
        uint256 startId;
        uint256 endId;
        string baseURI;
    }

    BaseTokenUriById[] public baseTokenUris;

    struct NFTAttr{
        uint16 HeroId;
        uint16 AP;
        uint16 DEF;
        uint16 HPMAX;
        uint16 HPCurrent;
        uint16 Luck;
        uint16 Star;
        uint16 Exp;
        uint16 Level;
        bool[4] pos;
    }

    struct NFTAttr2{
        uint16 sAP;
        uint16 sDEF;
        uint16 sHP;
        uint16 sLuck;
        uint16 bAP;
        uint16 bDEF;
        uint16 bHP;
        uint16 bLuck;
    }

    // mapping nftAttrs(address => )
    mapping(uint256 => NFTAttr) private nftAttrs;
    mapping(uint256 => NFTAttr2) private nftAttrs2;
    mapping(uint256 => uint256[4]) private equipIdOfNft;

    KSEquip private ksEquip_address;
    AttrConfig private attrConfig_addr;

    event PauseEvent(bool pause);
    event mintKSNFT(address indexed minter, uint256 indexed id, NFTAttr data);
    event updateKSNFTAttr(uint256 indexed tokenId, NFTAttr data);
    event putOnEquipEvent(uint256 indexed tokenId, uint8[] pos, uint256[] equipId);
    //event putOffEquipEvent(uint8 pos, uint256 tokenId);

    function setKSEquipAddress(KSEquip equip) public onlyOwner {
        ksEquip_address = equip;
    }

    function setAttrConfigAddress(AttrConfig addr) public onlyOwner {
        attrConfig_addr = addr;
    }

    function calcSuitAttr(uint256 nftId) public {
        
        NFTAttr memory nftattr = nftAttrs[nftId]; 
        NFTAttr2 memory nftattr2 = nftAttrs2[nftId];     
        nftattr.AP -= nftattr2.sAP;
        nftattr.DEF -= nftattr2.sDEF;
        nftattr.HPMAX -= nftattr2.sHP;
        nftattr.Luck -= nftattr2.sLuck;
        nftattr2.sAP = 0;
        nftattr2.sDEF = 0;
        nftattr2.sHP = 0;
        nftattr2.sLuck = 0;

        for(uint8 i=0; i<3; i++) {
            uint256 e1 = equipIdOfNft[nftId][i];
            uint8 sNum = 0;
            uint16 sId = 0;
            if(  e1 != 0 ) {
                AttrConfig.EquipAttr memory a1 = attrConfig_addr.getEquipAttr(ksEquip_address.getEquipId(e1));
                if( a1.SuitId != 0) {
                    for( uint8 j=i+1; j<4; j++ ) {
                        uint256 e2 = equipIdOfNft[nftId][j];
                        if( e2 != 0) {
                            AttrConfig.EquipAttr memory a2= attrConfig_addr.getEquipAttr(ksEquip_address.getEquipId(e1));
                            if( a2.SuitId != 0 ) {
                                if( a1.SuitId == a2.SuitId ) {
                                    sId = a1.SuitId;
                                    sNum++;
                                }
                            }
                        }
                    }
                }
            }

            if( sNum > 0) {
                uint16 suitId = sId*10 + sNum + 1;
                AttrConfig.SuitAttr memory suitattr = attrConfig_addr.getSuitAttr(suitId);
                nftattr2.sAP += uint16(nftattr.AP.mul(suitattr.APR).div(10000));
                nftattr2.sDEF += uint16(nftattr.DEF.mul(suitattr.DEFR).div(10000));
                nftattr2.sHP += uint16(nftattr.AP.mul(suitattr.HPMAXR).div(10000));
                nftattr2.sLuck += uint16(nftattr.AP.mul(suitattr.LUCKR).div(10000));
            }
            if( sNum > 1) break;
        }

        nftattr.AP += nftattr2.sAP;
        nftattr.DEF += nftattr2.sDEF;
        nftattr.HPMAX += nftattr2.sHP;
        nftattr.Luck += nftattr2.sLuck;

        nftAttrs[nftId] = nftattr;
        nftAttrs2[nftId] = nftattr2;

        emit updateKSNFTAttr(nftId, nftattr);
    }
    function putOnEquip(uint256 nftId, uint8[] calldata pos, uint256[] calldata equipId) public {
        require(ownerOf(nftId) == msg.sender, "tokenId not owner");
        require(pos.length == equipId.length, "arguments error");

        NFTAttr memory nftattr = nftAttrs[nftId]; 

        for(uint8 i=0; i<pos.length; i++) {
            require(pos[i]<4, "pos should <=3");
            require(nftattr.pos[pos[i]], "pos is locked");
            
            if( equipIdOfNft[nftId][pos[i]] != 0) {
                AttrConfig.EquipAttr memory equipattr = attrConfig_addr.getEquipAttr(ksEquip_address.getEquipId(equipIdOfNft[nftId][pos[i]]));
                nftattr.AP -= equipattr.AP;
                nftattr.DEF -= equipattr.DEF;
                nftattr.HPMAX -= equipattr.HPMAX;
                nftattr.Luck -= equipattr.LUCK;

                ksEquip_address.transferFrom(address(this), msg.sender, equipIdOfNft[nftId][pos[i]]);
                equipIdOfNft[nftId][pos[i]] = 0;
            }

            if (equipId[i] != 0) {
                AttrConfig.EquipAttr memory equipattr = attrConfig_addr.getEquipAttr(ksEquip_address.getEquipId(equipId[i]));
                nftattr.AP += equipattr.AP;
                nftattr.DEF += equipattr.DEF;
                nftattr.HPMAX += equipattr.HPMAX;
                nftattr.Luck += equipattr.LUCK;

                equipIdOfNft[nftId][pos[i]] = equipId[i];
                ksEquip_address.transferFrom(msg.sender, address(this), equipId[i]);
            }
        }

        nftAttrs[nftId] = nftattr;
        calcSuitAttr(nftId);

        emit putOnEquipEvent(nftId, pos, equipId);
    }

    modifier saleIsOpen() {
        require(totalToken() <= MAX_ELEMENTS, "Soldout!");
        require(!PAUSE, "Sales not open");
        _;
    }

    function random(string memory keyPrefix, uint256 max) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(keyPrefix, blockhash(block.number-1), _tokenIdTracker.current(), block.timestamp))) % max;
    }
        
    function initialize(string memory baseURI,uint256 endId) public initializer   
    {
        __Ownable_init();
        __ERC721Enumerable_init();
        __ReentrancyGuard_init();
        __ERC721_init("KSNFT", "KSNFT");

        setBaseURI(baseURI, 0, endId);
        devAddress = payable(owner());
        MAX_ELEMENTS = endId;
        EMPTY_STRING = "";
        PRICE = 0.2 ether;
        PAUSE = false;
        // max exp
        MaxExp = 1000000;
    }

    function setMaxElements(uint256 maxElements) public onlyOwner {
        require(MAX_ELEMENTS < maxElements, "Cannot decrease max elements");
        MAX_ELEMENTS = maxElements;
    }

    function setMintPrice(uint256 mintPriceWei) public onlyOwner {
        PRICE = mintPriceWei;
    }

    function setDevAddress(address _devAddress, uint256 _devFee) public onlyOwner {
        devAddress = payable(_devAddress);
        devFee = _devFee;
    }

    function setFactoryAddress(address addr) public onlyOwner {
        factory_address = addr;
    }

    function clearBaseUris() public onlyOwner {
        delete baseTokenUris;
    }

    function setBaseURI(string memory baseURI, uint256 startId, uint256 endId) public onlyOwner {
        require(keccak256(bytes(tokenURI(startId))) == keccak256(bytes(EMPTY_STRING)), "Start ID Overlap");
        require(keccak256(bytes(tokenURI(endId))) == keccak256(bytes(EMPTY_STRING)), "End ID Overlap");

        baseTokenUris.push(BaseTokenUriById({startId: startId, endId: endId, baseURI: baseURI}));
    }

    function setPause(bool _pause) public onlyOwner {
        PAUSE = _pause;
        emit PauseEvent(PAUSE);
    }

    function withdrawAll() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(devAddress, balance.mul(devFee).div(100));
        _widthdraw(owner(), address(this).balance);
    }

    function mintUnsoldTokens(uint256 amount) public onlyOwner {
        require(PAUSE, "Pause is disable");
        _mintAmount(amount, owner());
    }

    function mint(uint256 _amount) public payable saleIsOpen nonReentrant {
        uint256 total = totalToken();
        require(_amount <= 10, "Max limit");
        require(total + _amount <= MAX_ELEMENTS, "Max limit");
        require(msg.value >= price(_amount), "Value below price");

        address wallet = _msgSender();
        _mintAmount(_amount, wallet);
    }

    function getUnsoldTokens(uint256 offset, uint256 limit) external view returns (uint256[] memory) {
        uint256[] memory tokens = new uint256[](limit);
        for (uint256 i = 0; i < limit; i++) {
            uint256 key = i + offset;
            if (!_exists(key)) {
                tokens[i] = key;
            }
        }
        return tokens;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint256 length = baseTokenUris.length;
        for (uint256 interval = 0; interval < length; ++interval) {
            BaseTokenUriById storage baseTokenUri = baseTokenUris[interval];
            if (baseTokenUri.startId <= tokenId && baseTokenUri.endId >= tokenId) {
                return string(abi.encodePacked(baseTokenUri.baseURI,tokenId.toString(),".json"));
            }
        }
        return "";
    }

    function totalToken() public view returns (uint256) {
        return _tokenIdTracker.current();
    }

    function price(uint256 _count) public view returns (uint256) {
        if ( _count >= 10 )
            return PRICE.mul(_count).mul(95).div(100);
        else
            return PRICE.mul(_count);
    }

    function _mintAmount(uint256 amount, address wallet) private {
        for (uint8 i = 0; i < amount; i++) {
            while (_exists(_tokenIdTracker.current().add(1))) {
                _tokenIdTracker.increment();
            }
            _mintAnElement(wallet); // mint on current = 7.
        }
    }

    function _mintAnElement(address _to) private {
        _tokenIdTracker.increment();
        uint256 newTokenId = _tokenIdTracker.current();
        _safeMint(_to, newTokenId);

        uint16 _HeroId;
        uint16 _AP;
        uint16 _DEF;
        uint16 _HP;
        uint16 _Luck;
        uint16 _Star = 1;
        uint16 _Exp = 0;
        //init
        uint16 rand = uint16(random("random", 10000));
        if( rand < 80) { //SSR 0.8%
            _HeroId = uint16(random("HeroId", 19)) + 59;
            _AP = uint16(random("AP", 841)) + 1160;
            _DEF = uint16(random("DEF", 471)) + 880;
            _HP = uint16(random("HP", 1501)) + 5600;
            _Luck = uint16(random("Luck", 121)) + 290;
        }else if( rand < 1500 ) { //SR 14.2%
            _HeroId = uint16(random("HeroId", 19)) + 40;
            _AP = uint16(random("AP", 476)) + 425;
            _DEF = uint16(random("DEF", 341)) + 320;
            _HP = uint16(random("HP", 1301)) + 2200;
            _Luck = uint16(random("Luck", 51)) + 210;
        }else if( rand < 4000 ) { //R 25%
            _HeroId = uint16(random("HeroId", 19)) + 21;
            _AP = uint16(random("AP", 201)) + 170;
            _DEF = uint16(random("DEF", 133)) + 128;
            _HP = uint16(random("HP", 581)) + 920;
            _Luck = uint16(random("Luck", 41)) + 150;            
        }else { // C 60%
            _HeroId = uint16(random("HeroId", 20)) + 1;
            _AP = uint16(random("AP", 66)) + 90;
            _DEF = uint16(random("DEF", 41)) + 65;
            _HP = uint16(random("HP", 201)) + 500;
            _Luck = uint16(random("Luck", 31)) + 100;
        }

        nftAttrs[newTokenId] = NFTAttr(_HeroId, _AP, _DEF, _HP, _HP, _Luck, _Star, _Exp, 1, [false,false,false,false]);
        nftAttrs2[newTokenId] = NFTAttr2(0, 0, 0, 0, _AP, _DEF, _HP, _Luck);

        emit mintKSNFT(_to, newTokenId, nftAttrs[newTokenId]);
    }

    function getNftAttr(uint256 tokenId) public view returns (NFTAttr memory) {
        return nftAttrs[tokenId];
    }

    function getNftAttr2(uint256 tokenId) public view returns (NFTAttr2 memory) {
        return nftAttrs2[tokenId];
    }

    function getNftPower(uint256 tokenId) public view returns (uint16) {
        NFTAttr storage attr = nftAttrs[tokenId];
        return uint16(uint256(attr.HPMAX.mul(8) + attr.AP.mul(36) + attr.DEF.mul(45) + attr.Luck.mul(11)).div(100));
    }

    function setNftAttr(uint256 tokenId, NFTAttr memory attr) public {
        require(_msgSender() == factory_address, "not factory address");
        nftAttrs[tokenId] = attr;

        emit updateKSNFTAttr(tokenId, attr);
    }

    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }
}
