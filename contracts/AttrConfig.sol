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
        equipConfig[13010001] = EquipAttr(0, 50, 0, 0, 0);
        equipConfig[13010002] = EquipAttr(0, 60, 0, 0, 0);
        equipConfig[13010003] = EquipAttr(0, 70, 0, 0, 0);
        equipConfig[13010004] = EquipAttr(0, 85, 0, 0, 0);
        equipConfig[13010005] = EquipAttr(0, 105, 0, 0, 0);
        equipConfig[13010006] = EquipAttr(0, 125, 0, 0, 0);
        equipConfig[13010007] = EquipAttr(12, 145, 0, 0, 0);
        equipConfig[13010008] = EquipAttr(13, 170, 0, 0, 0);
        equipConfig[13010009] = EquipAttr(14, 205, 0, 0, 0);
        equipConfig[13010010] = EquipAttr(15, 240, 0, 0, 0);
        equipConfig[13010011] = EquipAttr(16, 275, 0, 0, 0);
        equipConfig[13010012] = EquipAttr(18, 330, 0, 0, 0);
        equipConfig[13010013] = EquipAttr(19, 395, 0, 0, 0);
        equipConfig[13010014] = EquipAttr(20, 465, 0, 0, 0);
        equipConfig[13010015] = EquipAttr(21, 535, 0, 0, 0);
        equipConfig[13010016] = EquipAttr(22, 655, 0, 0, 0);
        equipConfig[13010017] = EquipAttr(23, 825, 0, 0, 0);
        equipConfig[13020001] = EquipAttr(0, 0, 30, 0, 0);
        equipConfig[13020002] = EquipAttr(0, 0, 35, 0, 0);
        equipConfig[13020003] = EquipAttr(0, 0, 40, 0, 0);
        equipConfig[13020004] = EquipAttr(0, 0, 50, 0, 0);
        equipConfig[13020005] = EquipAttr(0, 0, 65, 0, 0);
        equipConfig[13020006] = EquipAttr(0, 0, 75, 0, 0);
        equipConfig[13020007] = EquipAttr(12, 0, 85, 0, 0);
        equipConfig[13020008] = EquipAttr(13, 0, 105, 0, 0);
        equipConfig[13020009] = EquipAttr(14, 0, 120, 0, 0);
        equipConfig[13020010] = EquipAttr(15, 0, 145, 0, 0);
        equipConfig[13020011] = EquipAttr(16, 0, 165, 0, 0);
        equipConfig[13020012] = EquipAttr(18, 0, 200, 0, 0);
        equipConfig[13020013] = EquipAttr(19, 0, 235, 0, 0);
        equipConfig[13020014] = EquipAttr(20, 0, 280, 0, 0);
        equipConfig[13020015] = EquipAttr(21, 0, 320, 0, 0);
        equipConfig[13020016] = EquipAttr(22, 0, 395, 0, 0);
        equipConfig[13020017] = EquipAttr(23, 0, 495, 0, 0);
        equipConfig[13030001] = EquipAttr(0, 0, 0, 0, 15);
        equipConfig[13030002] = EquipAttr(0, 0, 0, 0, 20);
        equipConfig[13030003] = EquipAttr(0, 0, 0, 0, 20);
        equipConfig[13030004] = EquipAttr(0, 0, 0, 0, 25);
        equipConfig[13030005] = EquipAttr(0, 0, 0, 0, 30);
        equipConfig[13030006] = EquipAttr(0, 0, 0, 0, 35);
        equipConfig[13030007] = EquipAttr(12, 0, 0, 0, 45);
        equipConfig[13030008] = EquipAttr(13, 0, 0, 0, 50);
        equipConfig[13030009] = EquipAttr(14, 0, 0, 0, 60);
        equipConfig[13030010] = EquipAttr(15, 0, 0, 0, 70);
        equipConfig[13030011] = EquipAttr(16, 0, 0, 0, 85);
        equipConfig[13030012] = EquipAttr(18, 0, 0, 0, 100);
        equipConfig[13030013] = EquipAttr(19, 0, 0, 0, 120);
        equipConfig[13030014] = EquipAttr(20, 0, 0, 0, 140);
        equipConfig[13030015] = EquipAttr(21, 0, 0, 0, 160);
        equipConfig[13030016] = EquipAttr(22, 0, 0, 0, 195);
        equipConfig[13030017] = EquipAttr(23, 0, 0, 0, 245);
        equipConfig[13040001] = EquipAttr(0, 0, 0, 235, 0);
        equipConfig[13040002] = EquipAttr(0, 0, 0, 280, 0);
        equipConfig[13040003] = EquipAttr(0, 0, 0, 325, 0);
        equipConfig[13040004] = EquipAttr(0, 0, 0, 410, 0);
        equipConfig[13040005] = EquipAttr(0, 0, 0, 490, 0);
        equipConfig[13040006] = EquipAttr(0, 0, 0, 585, 0);
        equipConfig[13040007] = EquipAttr(12, 0, 0, 670, 0);
        equipConfig[13040008] = EquipAttr(13, 0, 0, 805, 0);
        equipConfig[13040009] = EquipAttr(14, 0, 0, 960, 0);
        equipConfig[13040010] = EquipAttr(15, 0, 0, 1130, 0);
        equipConfig[13040011] = EquipAttr(16, 0, 0, 1300, 0);
        equipConfig[13040012] = EquipAttr(18, 0, 0, 1560, 0);
        equipConfig[13040013] = EquipAttr(19, 0, 0, 1860, 0);
        equipConfig[13040014] = EquipAttr(20, 0, 0, 2195, 0);
        equipConfig[13040015] = EquipAttr(21, 0, 0, 2520, 0);
        equipConfig[13040016] = EquipAttr(22, 0, 0, 3075, 0);
        equipConfig[13040017] = EquipAttr(23, 0, 0, 3875, 0);

        suitConfig[122] = SuitAttr(0, 200, 0, 0);
        suitConfig[123] = SuitAttr(0, 200, 200, 0);
        suitConfig[124] = SuitAttr(200, 200, 200, 0);
        suitConfig[132] = SuitAttr(0, 400, 0, 0);
        suitConfig[133] = SuitAttr(0, 400, 400, 0);
        suitConfig[134] = SuitAttr(400, 400, 400, 0);
        suitConfig[142] = SuitAttr(0, 600, 0, 0);
        suitConfig[143] = SuitAttr(0, 600, 600, 0);
        suitConfig[144] = SuitAttr(600, 600, 600, 0);
        suitConfig[152] = SuitAttr(0, 800, 0, 0);
        suitConfig[153] = SuitAttr(0, 800, 800, 0);
        suitConfig[154] = SuitAttr(800, 800, 800, 0);
        suitConfig[162] = SuitAttr(0, 1000, 0, 0);
        suitConfig[163] = SuitAttr(0, 1000, 1000, 0);
        suitConfig[164] = SuitAttr(1000, 1000, 1000, 0);
        suitConfig[182] = SuitAttr(0, 1200, 0, 0);
        suitConfig[183] = SuitAttr(0, 1200, 1200, 0);
        suitConfig[184] = SuitAttr(1200, 1200, 1200, 0);
        suitConfig[192] = SuitAttr(0, 1400, 0, 0);
        suitConfig[193] = SuitAttr(0, 1400, 1400, 0);
        suitConfig[194] = SuitAttr(1400, 1400, 1400, 0);
        suitConfig[202] = SuitAttr(0, 1600, 0, 0);
        suitConfig[203] = SuitAttr(0, 1600, 1600, 0);
        suitConfig[204] = SuitAttr(1600, 1600, 1600, 0);
        suitConfig[212] = SuitAttr(0, 1800, 0, 0);
        suitConfig[213] = SuitAttr(0, 1800, 1800, 0);
        suitConfig[214] = SuitAttr(1800, 1800, 1800, 0);
        suitConfig[222] = SuitAttr(0, 2000, 0, 0);
        suitConfig[223] = SuitAttr(0, 2000, 2000, 0);
        suitConfig[224] = SuitAttr(2000, 2000, 2000, 0);
        suitConfig[232] = SuitAttr(0, 2200, 0, 0);
        suitConfig[233] = SuitAttr(0, 2200, 2200, 0);
        suitConfig[234] = SuitAttr(2200, 2200, 2200, 0);
    }

    function getEquipAttr(uint32 equipId) public view returns (EquipAttr memory) {
        return equipConfig[equipId];
    }

    function getSuitAttr(uint32 suitId) public view returns (SuitAttr memory) {
        return suitConfig[suitId];
    }
}