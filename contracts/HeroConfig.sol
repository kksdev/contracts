// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HeroConfig {
    struct HeroLevelInfo{
		uint16 needExp;
		uint16 normalNeedCoin;
		uint16 fastNeedCoin;
	}

 
	mapping(uint16 => HeroLevelInfo) private heroLevelConfig;

    constructor() {
        heroLevelConfig[1] = HeroLevelInfo(0, 0, 0);
        heroLevelConfig[2] = HeroLevelInfo(900, 1, 5);
        heroLevelConfig[3] = HeroLevelInfo(1500, 3, 10);
        heroLevelConfig[4] = HeroLevelInfo(2100, 5, 15);
        heroLevelConfig[5] = HeroLevelInfo(3300, 7, 20);
        heroLevelConfig[6] = HeroLevelInfo(4200, 9, 25);
        heroLevelConfig[7] = HeroLevelInfo(5100, 11, 30);
        heroLevelConfig[8] = HeroLevelInfo(5400, 13, 35);
        heroLevelConfig[9] = HeroLevelInfo(5760, 15, 40);
        heroLevelConfig[10] = HeroLevelInfo(6000, 17, 45);
        heroLevelConfig[11] = HeroLevelInfo(6480, 19, 50);
        heroLevelConfig[12] = HeroLevelInfo(6660, 21, 55);
        heroLevelConfig[13] = HeroLevelInfo(6900, 23, 60);
        heroLevelConfig[14] = HeroLevelInfo(7080, 25, 65);
        heroLevelConfig[15] = HeroLevelInfo(7260, 27, 70);
        heroLevelConfig[16] = HeroLevelInfo(7440, 29, 75);
        heroLevelConfig[17] = HeroLevelInfo(7680, 31, 80);
        heroLevelConfig[18] = HeroLevelInfo(7860, 33, 85);
        heroLevelConfig[19] = HeroLevelInfo(7980, 35, 90);
        heroLevelConfig[20] = HeroLevelInfo(8100, 37, 95);
        heroLevelConfig[21] = HeroLevelInfo(8280, 39, 100);
        heroLevelConfig[22] = HeroLevelInfo(8460, 41, 105);
        heroLevelConfig[23] = HeroLevelInfo(8580, 43, 110);
        heroLevelConfig[24] = HeroLevelInfo(8760, 45, 115);
        heroLevelConfig[25] = HeroLevelInfo(8940, 47, 120);
        heroLevelConfig[26] = HeroLevelInfo(9120, 49, 125);
        heroLevelConfig[27] = HeroLevelInfo(9300, 51, 130);
        heroLevelConfig[28] = HeroLevelInfo(9480, 53, 135);
        heroLevelConfig[29] = HeroLevelInfo(9660, 55, 140);
        heroLevelConfig[30] = HeroLevelInfo(9780, 57, 145);
        heroLevelConfig[31] = HeroLevelInfo(9960, 59, 150);
        heroLevelConfig[32] = HeroLevelInfo(10140, 61, 155);
        heroLevelConfig[33] = HeroLevelInfo(10320, 63, 160);
        heroLevelConfig[34] = HeroLevelInfo(10500, 65, 165);
        heroLevelConfig[35] = HeroLevelInfo(10680, 67, 170);
        heroLevelConfig[36] = HeroLevelInfo(10860, 69, 175);
        heroLevelConfig[37] = HeroLevelInfo(10920, 71, 180);
        heroLevelConfig[38] = HeroLevelInfo(10980, 73, 185);
        heroLevelConfig[39] = HeroLevelInfo(11040, 75, 190);
        heroLevelConfig[40] = HeroLevelInfo(11100, 77, 195);
    }

    function getHeroLevelInfo(uint16 level) public view returns (HeroLevelInfo memory) {
        return heroLevelConfig[level];
    }
}