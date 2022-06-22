	struct HeroLevelInfo{
		uint16 needExp;
		uint16 normalNeedCoin;
		uint16 fastNeedCoin;
	}

	// mapping HeroLevelInfo(address => )
	mapping(uint16 => HeroLevelInfo) private heroLevelConfig;

	//heroLevelConfig
	heroLevelConfig[1] = EquipAttr(0, 0, 0);
	heroLevelConfig[2] = EquipAttr(900, 1, 5);
	heroLevelConfig[3] = EquipAttr(1500, 3, 10);
	heroLevelConfig[4] = EquipAttr(2100, 5, 15);
	heroLevelConfig[5] = EquipAttr(3300, 7, 20);
	heroLevelConfig[6] = EquipAttr(4200, 9, 25);
	heroLevelConfig[7] = EquipAttr(5100, 11, 30);
	heroLevelConfig[8] = EquipAttr(5400, 13, 35);
	heroLevelConfig[9] = EquipAttr(5760, 15, 40);
	heroLevelConfig[10] = EquipAttr(6000, 17, 45);
	heroLevelConfig[11] = EquipAttr(6480, 19, 50);
	heroLevelConfig[12] = EquipAttr(6660, 21, 55);
	heroLevelConfig[13] = EquipAttr(6900, 23, 60);
	heroLevelConfig[14] = EquipAttr(7080, 25, 65);
	heroLevelConfig[15] = EquipAttr(7260, 27, 70);
	heroLevelConfig[16] = EquipAttr(7440, 29, 75);
	heroLevelConfig[17] = EquipAttr(7680, 31, 80);
	heroLevelConfig[18] = EquipAttr(7860, 33, 85);
	heroLevelConfig[19] = EquipAttr(7980, 35, 90);
	heroLevelConfig[20] = EquipAttr(8100, 37, 95);
	heroLevelConfig[21] = EquipAttr(8280, 39, 100);
	heroLevelConfig[22] = EquipAttr(8460, 41, 105);
	heroLevelConfig[23] = EquipAttr(8580, 43, 110);
	heroLevelConfig[24] = EquipAttr(8760, 45, 115);
	heroLevelConfig[25] = EquipAttr(8940, 47, 120);
	heroLevelConfig[26] = EquipAttr(9120, 49, 125);
	heroLevelConfig[27] = EquipAttr(9300, 51, 130);
	heroLevelConfig[28] = EquipAttr(9480, 53, 135);
	heroLevelConfig[29] = EquipAttr(9660, 55, 140);
	heroLevelConfig[30] = EquipAttr(9780, 57, 145);
	heroLevelConfig[31] = EquipAttr(9960, 59, 150);
	heroLevelConfig[32] = EquipAttr(10140, 61, 155);
	heroLevelConfig[33] = EquipAttr(10320, 63, 160);
	heroLevelConfig[34] = EquipAttr(10500, 65, 165);
	heroLevelConfig[35] = EquipAttr(10680, 67, 170);
	heroLevelConfig[36] = EquipAttr(10860, 69, 175);
	heroLevelConfig[37] = EquipAttr(10920, 71, 180);
	heroLevelConfig[38] = EquipAttr(10980, 73, 185);
	heroLevelConfig[39] = EquipAttr(11040, 75, 190);
	heroLevelConfig[40] = EquipAttr(11100, 77, 195);
	
