// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AttrConfig {
	struct EquipAttr{
		uint16 SuitId;
		uint16 AP;
		uint16 DEF;
		uint16 HPMAX;
		uint16 LUCK;
	}

	struct SuitAttr{
		uint16 APR;
		uint16 DEFR;
		uint16 HPMAXR;
		uint16 LUCKR;
	}

    mapping( uint32 => EquipAttr ) public equipConfig;
    mapping( uint32 => SuitAttr ) public suitConfig;

    constructor() {
        equipConfig[13010001] = EquipAttr(0, 45, 0, 0, 0);
        equipConfig[13010002] = EquipAttr(0, 55, 0, 0, 0);
        equipConfig[13010003] = EquipAttr(0, 90, 0, 0, 0);
        equipConfig[13010004] = EquipAttr(0, 120, 0, 0, 0);
        equipConfig[13010005] = EquipAttr(0, 240, 0, 0, 0);
        equipConfig[13010006] = EquipAttr(0, 310, 0, 0, 0);
        equipConfig[13010007] = EquipAttr(12, 370, 0, 0, 0);
        equipConfig[13010008] = EquipAttr(13, 560, 0, 0, 0);
        equipConfig[13010009] = EquipAttr(14, 670, 0, 0, 0);
        equipConfig[13010010] = EquipAttr(15, 790, 0, 0, 0);
        equipConfig[13010011] = EquipAttr(16, 910, 0, 0, 0);
        equipConfig[13010012] = EquipAttr(18, 1230, 0, 0, 0);
        equipConfig[13010013] = EquipAttr(19, 1475, 0, 0, 0);
        equipConfig[13010014] = EquipAttr(20, 1740, 0, 0, 0);
        equipConfig[13010015] = EquipAttr(21, 2000, 0, 0, 0);
        equipConfig[13010016] = EquipAttr(22, 3200, 0, 0, 0);
        equipConfig[13010017] = EquipAttr(23, 4800, 0, 0, 0);
        equipConfig[13020001] = EquipAttr(0, 0, 0, 340, 0);
        equipConfig[13020002] = EquipAttr(0, 0, 0, 405, 0);
        equipConfig[13020003] = EquipAttr(0, 0, 0, 690, 0);
        equipConfig[13020004] = EquipAttr(0, 0, 0, 895, 0);
        equipConfig[13020005] = EquipAttr(0, 0, 0, 1790, 0);
        equipConfig[13020006] = EquipAttr(0, 0, 0, 2325, 0);
        equipConfig[13020007] = EquipAttr(12, 0, 0, 2795, 0);
        equipConfig[13020008] = EquipAttr(13, 0, 0, 4190, 0);
        equipConfig[13020009] = EquipAttr(14, 0, 0, 5025, 0);
        equipConfig[13020010] = EquipAttr(15, 0, 0, 5930, 0);
        equipConfig[13020011] = EquipAttr(16, 0, 0, 6820, 0);
        equipConfig[13020012] = EquipAttr(18, 0, 0, 9210, 0);
        equipConfig[13020013] = EquipAttr(19, 0, 0, 11050, 0);
        equipConfig[13020014] = EquipAttr(20, 0, 0, 13040, 0);
        equipConfig[13020015] = EquipAttr(21, 0, 0, 14995, 0);
        equipConfig[13020016] = EquipAttr(22, 0, 0, 23990, 0);
        equipConfig[13020017] = EquipAttr(23, 0, 0, 35990, 0);
        equipConfig[13030001] = EquipAttr(0, 30, 0, 0, 0);
        equipConfig[13030002] = EquipAttr(0, 35, 0, 0, 0);
        equipConfig[13030003] = EquipAttr(0, 60, 0, 0, 0);
        equipConfig[13030004] = EquipAttr(0, 80, 0, 0, 0);
        equipConfig[13030005] = EquipAttr(0, 160, 0, 0, 0);
        equipConfig[13030006] = EquipAttr(0, 205, 0, 0, 0);
        equipConfig[13030007] = EquipAttr(12, 250, 0, 0, 0);
        equipConfig[13030008] = EquipAttr(13, 370, 0, 0, 0);
        equipConfig[13030009] = EquipAttr(14, 445, 0, 0, 0);
        equipConfig[13030010] = EquipAttr(15, 525, 0, 0, 0);
        equipConfig[13030011] = EquipAttr(16, 605, 0, 0, 0);
        equipConfig[13030012] = EquipAttr(18, 820, 0, 0, 0);
        equipConfig[13030013] = EquipAttr(19, 980, 0, 0, 0);
        equipConfig[13030014] = EquipAttr(20, 1160, 0, 0, 0);
        equipConfig[13030015] = EquipAttr(21, 1335, 0, 0, 0);
        equipConfig[13030016] = EquipAttr(22, 2135, 0, 0, 0);
        equipConfig[13030017] = EquipAttr(23, 3200, 0, 0, 0);
        equipConfig[13040001] = EquipAttr(0, 0, 0, 225, 0);
        equipConfig[13040002] = EquipAttr(0, 0, 0, 270, 0);
        equipConfig[13040003] = EquipAttr(0, 0, 0, 460, 0);
        equipConfig[13040004] = EquipAttr(0, 0, 0, 595, 0);
        equipConfig[13040005] = EquipAttr(0, 0, 0, 1195, 0);
        equipConfig[13040006] = EquipAttr(0, 0, 0, 1550, 0);
        equipConfig[13040007] = EquipAttr(12, 0, 0, 1860, 0);
        equipConfig[13040008] = EquipAttr(13, 0, 0, 2795, 0);
        equipConfig[13040009] = EquipAttr(14, 0, 0, 3350, 0);
        equipConfig[13040010] = EquipAttr(15, 0, 0, 3955, 0);
        equipConfig[13040011] = EquipAttr(16, 0, 0, 4545, 0);
        equipConfig[13040012] = EquipAttr(18, 0, 0, 6140, 0);
        equipConfig[13040013] = EquipAttr(19, 0, 0, 7365, 0);
        equipConfig[13040014] = EquipAttr(20, 0, 0, 8695, 0);
        equipConfig[13040015] = EquipAttr(21, 0, 0, 9995, 0);
        equipConfig[13040016] = EquipAttr(22, 0, 0, 15995, 0);
        equipConfig[13040017] = EquipAttr(23, 0, 0, 23990, 0);

        suitConfig[122] = SuitAttr(0, 0, 200, 0);
        suitConfig[123] = SuitAttr(300, 0, 200, 0);
        suitConfig[124] = SuitAttr(300, 0, 300, 0);
        suitConfig[132] = SuitAttr(0, 0, 400, 0);
        suitConfig[133] = SuitAttr(500, 0, 400, 0);
        suitConfig[134] = SuitAttr(500, 0, 600, 0);
        suitConfig[142] = SuitAttr(0, 0, 500, 0);
        suitConfig[143] = SuitAttr(700, 0, 500, 0);
        suitConfig[144] = SuitAttr(700, 0, 900, 0);
        suitConfig[152] = SuitAttr(0, 0, 700, 0);
        suitConfig[153] = SuitAttr(900, 0, 700, 0);
        suitConfig[154] = SuitAttr(900, 0, 1100, 0);
        suitConfig[162] = SuitAttr(0, 0, 800, 0);
        suitConfig[163] = SuitAttr(1000, 0, 800, 0);
        suitConfig[164] = SuitAttr(1000, 0, 1300, 0);
        suitConfig[182] = SuitAttr(0, 0, 1000, 0);
        suitConfig[183] = SuitAttr(1200, 0, 1000, 0);
        suitConfig[184] = SuitAttr(1200, 0, 1500, 0);
        suitConfig[192] = SuitAttr(0, 0, 1100, 0);
        suitConfig[193] = SuitAttr(1400, 0, 1100, 0);
        suitConfig[194] = SuitAttr(1400, 0, 1700, 0);
        suitConfig[202] = SuitAttr(0, 0, 1200, 0);
        suitConfig[203] = SuitAttr(1600, 0, 1200, 0);
        suitConfig[204] = SuitAttr(1600, 0, 1900, 0);
        suitConfig[212] = SuitAttr(0, 0, 1400, 0);
        suitConfig[213] = SuitAttr(1800, 0, 1400, 0);
        suitConfig[214] = SuitAttr(1800, 0, 2100, 0);
        suitConfig[222] = SuitAttr(0, 0, 1500, 0);
        suitConfig[223] = SuitAttr(2000, 0, 1500, 0);
        suitConfig[224] = SuitAttr(2000, 0, 2300, 0);
        suitConfig[232] = SuitAttr(0, 0, 1600, 0);
        suitConfig[233] = SuitAttr(2200, 0, 1600, 0);
        suitConfig[234] = SuitAttr(2200, 0, 2400, 0);
    }

    function getEquipAttr(uint32 equipId) public view returns (EquipAttr memory) {
        return equipConfig[equipId];
    }

    function getSuitAttr(uint32 suitId) public view returns (SuitAttr memory) {
        return suitConfig[suitId];
    }
}