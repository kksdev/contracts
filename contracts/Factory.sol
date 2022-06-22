// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./KSEquip.sol";
import "./KSMaterial.sol";
import "./KSNFT.sol";
import "./KSToken.sol";
import "./HeroConfig.sol";
//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@prb/math/contracts/PRBMathUD60x18.sol";

contract Factory is OwnableUpgradeable {

//    using SafeMath for uint16;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using PRBMathUD60x18 for uint256;

    KSEquip private _equip; 
    KSMaterial private _material;
    KSNFT private _nft;
    KSToken private _token;
    address private _signer;
    uint256 private _stoneId;
    uint8[5] private _stoneNum;
    uint256[5] private _tokenNeed;
    address private _beneficiary;
    uint8 private _MAX_EQUIP_LEVEL;
    uint256 private _EQUIP_TOKENS;
    uint8 public constant FARM_MAX = 255;
    uint256 private _Multipiler;
    mapping (bytes32=>bool) private _check;
    uint256[6] private _base;
    uint16[4] private _quality;
    uint16[6] private _power;
    uint16[6] private _ratio;
    uint256[6] private _exp;

    //address=>tokenId=>timestamp
    mapping (address=>mapping (uint256=>uint256)) private _farm;
    event FarmInEvent(address indexed farmer, uint8 farmId, uint256[] ids);
    event FarmOutEvent(address indexed farmer, uint256[] ids);
    event FarmUpdateTime(address indexed farmer, uint256[] ids);
    event TransferProof(address indexed buyer, uint256 value, uint8 transferType, uint64 seed);
    mapping(address => mapping(uint8 => EnumerableSetUpgradeable.UintSet)) private _tokenIdsOfFarmId;
    HeroConfig private _config;
    uint256 private _unlockPosFee;
    uint16[6] private _level;

    struct rewardBox {
        uint32[] equipIds;
        uint256[] materialIds;
        uint256[] materialNums;
        uint32 rand;
    }

    function initialize(KSMaterial material, KSEquip equip, KSNFT nft, KSToken token, address signer, address beneficiary) public initializer {

        __Ownable_init();

        _equip = equip;
        _material = material;
        _signer = signer;
        _nft = nft;
        _token = token;
        _beneficiary = beneficiary;
 
        _stoneNum = [2,5,15,25,50];
        _tokenNeed = [10 ether, 30 ether, 50 ether, 150 ether, 500 ether];
        _MAX_EQUIP_LEVEL = 17;
        _EQUIP_TOKENS = 10 ether;
        _Multipiler = 1e16;
        _base = [1e13, 1e14, 5*1e14, 9*1e14, 5*1e14, 5*1e14];
        _quality = [1, 3, 15, 360];
        _power = [262, 303, 416, 477, 598, 688];
        _ratio = [1, 2, 3, 9, 3, 3];//div(10000)
        _exp = [3*1e16, 24*1e16, 33*1e16, 33*1e16, 33*1e16, 33*1e16];
        _unlockPosFee = 15 ether;
        _level = [1,5,15,20,25,30];
    }

    function setExp(uint256[6] calldata exp) public onlyOwner {
        _exp = exp;
    }

    function setSigner(address signer) public onlyOwner {
        _signer = signer;
    }

    function setMaterial(KSMaterial material) public onlyOwner {
        _material = material;
    }

    function setEquip(KSEquip equip) public onlyOwner {
        _equip = equip;
    }

    function setNft(KSNFT nft) public onlyOwner {
        _nft = nft;
    }

    function setStone(uint256 stoneId, uint8[5] calldata nums) public onlyOwner {
        _stoneId = stoneId;
        _stoneNum = nums;
    }

    function setEquipUpgrade(uint8 maxLvl, uint256 tokens) public onlyOwner {
        _MAX_EQUIP_LEVEL = maxLvl;
        _EQUIP_TOKENS = tokens;
    }

    function setMultiplier(uint256 mul) public onlyOwner {
        _Multipiler = mul;
    }

    function setHeroConfigAddress(HeroConfig config) public onlyOwner {
        _config = config;
    }

    function setUnlockPosFee(uint256 fee) public onlyOwner {
        _unlockPosFee = fee;
    }

    function setPower(uint16[6] calldata power) public onlyOwner {
        _power = power;
    }

    function upgradeNft(uint256 masterNftId, uint256[] calldata burnNftIds) public {
        require(burnNftIds.length == 2, "number err");
        require(_nft.ownerOf(masterNftId) == msg.sender, "not owner");
        KSNFT.NFTAttr memory attr = _nft.getNftAttr(masterNftId);
        for(uint8 i = 0; i< 2; i++) {
            require(_nft.getNftAttr(burnNftIds[i]).Star == attr.Star && _nft.getNftAttr(burnNftIds[i]).HeroId == attr.HeroId , "not same hero or star");
            _nft.burn(burnNftIds[i]);
        }

        _material.burn(msg.sender, _stoneId, _stoneNum[attr.Star-1]);
        _token.transferFrom(msg.sender, _beneficiary, _tokenNeed[attr.Star-1]);

        attr.Star += 1;
        require(attr.Star <= 6, "over max star");
        _nft.setNftAttr(masterNftId, attr);
    }

    function upgradeEquip(uint256[] calldata tokenIds) public {
        uint32 equipId = _equip.getEquipId(tokenIds[0]);
        require((equipId%100) <_MAX_EQUIP_LEVEL,"MAX LEVEN");
        
        uint32 newEquipId = equipId++;
        uint256 needTokens = 0;
        for(uint8 i = 0; i< tokenIds.length; i++) {
            require(_equip.ownerOf(tokenIds[i]) == msg.sender, "not owner");
            require(_equip.getEquipId(tokenIds[1]) == equipId, "not same equipId");
            _equip.burn(tokenIds[i]);
            if((i+1)%3 == 0) {
                _equip.mint(msg.sender, newEquipId);
                needTokens +=_EQUIP_TOKENS;
            }
        }

        if( needTokens > 0 ) {
            _token.transferFrom(msg.sender, _beneficiary, _EQUIP_TOKENS);
        }
    }

    function farmIn(uint8 farmId, uint256[] calldata ids) external {
        require(ids.length < FARM_MAX, "ids over max");
        require(farmId < 6, "farmId over max");
        for(uint8 i=0; i<ids.length; i++) {
            require(_nft.getNftPower(ids[i]) >= _power[farmId], "nft's power not enough");
            KSNFT.NFTAttr memory attr = _nft.getNftAttr(ids[i]);
            require(attr.Star >= (farmId+1), "nft's star not enough");
            require(attr.Level >= _level[farmId], "nft's level not enough");

            _farm[msg.sender][ids[i]] = block.timestamp;
            _nft.transferFrom(msg.sender, address(this), ids[i]);
            _tokenIdsOfFarmId[msg.sender][farmId].add(ids[i]);
        }

        emit FarmInEvent(msg.sender, farmId, ids);
    }

    function farmOut(uint8 farmId, uint256[] calldata ids) external {

        harvest(farmId);
        for(uint8 i=0; i<ids.length; i++) {
            require(_farm[msg.sender][ids[i]] > 0, "NFTId not exsit");
            require(_tokenIdsOfFarmId[msg.sender][farmId].contains(ids[i]), "NFTId not in FarmId");

            _nft.transferFrom(address(this), msg.sender, ids[i]);
            _tokenIdsOfFarmId[msg.sender][farmId].remove(ids[i]);
            delete _farm[msg.sender][ids[i]];
        }
        emit FarmOutEvent(msg.sender, ids);
    }

    function chargeHp(uint8 farmId, uint256[] calldata ids, uint16[] calldata hps) external {
        
        harvest(farmId);
        uint256 tickNow = block.timestamp;
        uint16  HPTotal = 0;
        for(uint8 i=0; i<ids.length; i++) {
            require(_farm[msg.sender][ids[i]] > 0, "NFTId not exsit");
    
            KSNFT.NFTAttr memory attr = _nft.getNftAttr(ids[i]);
            require(attr.HPMAX>=hps[i], "hp can't over HpMax");
            uint256 t = tickNow - _farm[msg.sender][ids[i]];
            uint16 nHP = uint16(t/600);

            if( attr.HPCurrent < nHP) {
                attr.Exp += attr.HPCurrent;
                attr.HPCurrent = hps[i];
                HPTotal += hps[i];
            }else {
                attr.Exp += nHP;
                require(hps[i]>=(attr.HPCurrent-nHP), "hp cant' lower than hpcurrent");
                HPTotal += hps[i]-(attr.HPCurrent-nHP);
                attr.HPCurrent = hps[i];
            }

            _farm[msg.sender][ids[i]] = tickNow;
            _nft.setNftAttr(ids[i], attr);
        }

        _token.transferFrom(msg.sender, _beneficiary, HPTotal * _Multipiler);

        emit FarmUpdateTime(msg.sender, ids);
    }

    function harvest(uint8 farmId) public {
        uint256 reward = 0;
        for(uint i=0; i<_tokenIdsOfFarmId[msg.sender][farmId].length(); i++) {
            uint256 id = _tokenIdsOfFarmId[msg.sender][farmId].at(i);
            uint16 nHP = uint16((block.timestamp - _farm[msg.sender][id])/600);
            KSNFT.NFTAttr memory attr = _nft.getNftAttr(id);
            uint256 profit = calcProfit(farmId, id);

            if( attr.HPCurrent < nHP) {
                attr.Exp += attr.HPCurrent;
                reward += attr.HPCurrent * profit;
                attr.HPCurrent = 0;
            } else {
                attr.Exp += nHP;
                reward += nHP * profit;
                attr.HPCurrent -= nHP;
            }
            _nft.setNftAttr(id, attr);
            _farm[msg.sender][id] = block.timestamp;
        }
        if( reward > 0) {
            _token.transferFrom(_beneficiary, msg.sender, reward);
        }

        emit FarmUpdateTime(msg.sender, _tokenIdsOfFarmId[msg.sender][farmId].values());
    }

    function mint(rewardBox calldata reward, uint8 v, bytes32 r, bytes32 s) external {
        bytes32 hash = keccak256(abi.encode(msg.sender, reward));
        require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == _signer, "signature error");
        require(!_check[hash], "already minted");
        require(reward.materialIds.length == reward.materialNums.length, "ids1155 or nums1155 length error");
        for(uint i=0; i<reward.equipIds.length; i++) {
            _equip.mint(msg.sender, reward.equipIds[i]);
        }
  
        _material.mintBatch(msg.sender, reward.materialIds, reward.materialNums);
        
        _check[hash] = true;
    }

    function calcProfit(uint8 farmId, uint256 nftId) view public returns(uint256){
        uint16 power = _nft.getNftPower(nftId);
        if(power < _power[farmId]) return 0;
        uint256 p = uint256(power - _power[farmId])*1e18;
        KSNFT.NFTAttr memory a = _nft.getNftAttr(nftId);
        uint16 qual = 0;
        if(a.HeroId<=20) qual = 0;
        else if(a.HeroId<=39) qual = 1;
        else if(a.HeroId<=58) qual = 2;
        else if(a.HeroId<=77) qual = 3;
        return p.pow(_exp[farmId]) * _quality[qual] * _ratio[farmId] /10000 + _base[farmId];
    }

    function updateHeroLevel(uint256 nftId, uint16 level, bool isFast) public {
        require(level>1 && level<=40, "level>1&&level<=40");
        require(_nft.ownerOf(nftId) == msg.sender, "nftId not owner");
        KSNFT.NFTAttr memory a = _nft.getNftAttr(nftId);
        require(level>a.Level, "level should more than current level");
        uint16 s = level-a.Level;
        uint256 tokens = 0;
        while(s>0) {
            HeroConfig.HeroLevelInfo memory info = _config.getHeroLevelInfo(++a.Level);
            if( isFast ) {
                tokens += info.fastNeedCoin;
            }else {
                require( a.Exp >= info.needExp, "Exp not enough");
                a.Exp -= info.needExp;
                tokens += info.normalNeedCoin;
            }
            s--;
        }
        _token.transferFrom(msg.sender, _beneficiary, tokens*1e18);
        _nft.setNftAttr(nftId, a);
    }

    function unlockPos(uint256 nftId) public {
        require(_nft.ownerOf(nftId) == msg.sender, "nft not owner");
        KSNFT.NFTAttr memory a = _nft.getNftAttr(nftId);
        uint8 left = 0;
        for(uint8 i=0; i<4; i++) {
            if(a.pos[i] == false) left++;
        }
        require(a.Level >= ((5-left)*10),"Level not enough");

        uint8 p1 = 0;
        uint8 p2 = 0;
        if(left>0) {
            p1 = uint8(random(nftId)%left);
            for(uint8 i=0; i<4; i++) {
                if(a.pos[i] == false){
                    if(p1 == p2) {
                        a.pos[i] = true;
                        break;
                    } 
                    else p2++;
                }
            }
            _token.transferFrom(msg.sender, _beneficiary, _unlockPosFee);
            _nft.setNftAttr(nftId, a);
        }
    }

    function random(uint256 seed) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, blockhash(block.number-1), block.timestamp)));
    }

    function transferProof(uint256 value, uint8 transferType) public {
        _token.transferFrom(msg.sender, _beneficiary, value);
        emit TransferProof(msg.sender, value, transferType, uint64(random(value)&0xFFFFFFFFFFFFFFFF));
    }

    function getFightReward(uint256 value, uint32 rand, uint8 v, bytes32 r, bytes32 s) external {
        bytes32 hash = keccak256(abi.encode(msg.sender, value, rand));
        require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == _signer, "signature error");
        require(!_check[hash], "already get reward");

        _token.transferFrom(_beneficiary, msg.sender, value);
        _check[hash] = true;
    }
}