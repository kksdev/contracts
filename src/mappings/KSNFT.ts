import { NFTAttr } from "../../generated/schema"
import { BigInt, Address} from "@graphprotocol/graph-ts";

import {
	mintKSNFT  as mintKSNFTEvent,
    updateKSNFTAttr as updateKSNFTAttrEvent,
    putOnEquipEvent
} from '../../generated/KSNFT/KSNFT'

import {
	fetchERC721,
	fetchERC721Token,
	fetchERC721Operator,
    getOrCreateNFTAttr,
} from '../fetch/erc721'

import {
	fetchERC721 as fetchEquip,
	fetchERC721Token as fetchEquipToken
} from '../fetch/equip'

import {
	fetchAccount,
} from '../fetch/accountERC721'

import heroModel from "../config/HeroModel"

let EQUIP_ADDRESS="0x44d51D3c7A0F8B29fC54C7C597a1b0E5b2236C90";

export function handleMintKSNFT(event: mintKSNFTEvent): void {
    let params = event.params;
    let attr = getOrCreateNFTAttr(params.id.toHex());

    let contract = fetchERC721(event.address)
	if (contract != null) {
		let token = fetchERC721Token(contract, event.params.id);
        attr.token = token.id;

        let h = heroModel.get(params.data.HeroId)
        if ( h!= null )
        {
            attr.Name = h.Name
            attr.ModelId = h.ModelId as i32
            attr.HeroId = params.data.HeroId
            attr.Qualitity = h.Qualitity as i32
            
            attr.Ap = params.data.AP
            attr.Def = params.data.DEF
            attr.HpMAX = params.data.HPMAX
            attr.HpCurrent = params.data.HPCurrent
            attr.Luck = params.data.Luck
            attr.Exp = params.data.Exp
            attr.Star = params.data.Star
            attr.Level = params.data.Level

            attr.sAp = params.data.sAP
            attr.sDef = params.data.sDEF
            attr.sHp = params.data.sHP
            attr.sLuck = params.data.sLuck

            attr.Pos0 = params.data.pos[0]
            attr.Pos1 = params.data.pos[1]
            attr.Pos2 = params.data.pos[2]
            attr.Pos3 = params.data.pos[3]
        }

        attr.save();
    }
}

export function handleUpdateKSNFTAttr(event: updateKSNFTAttrEvent): void {
    let params = event.params;
    let attr = getOrCreateNFTAttr(params.tokenId.toHex());

    let contract = fetchERC721(event.address)
	if (contract != null) {
		let token = fetchERC721Token(contract, event.params.tokenId);
        attr.token = token.id;

        let h = heroModel.get(params.data.HeroId)
        if ( h!= null )
        {
            attr.Ap = params.data.AP
            attr.Def = params.data.DEF
            attr.HpMAX = params.data.HPMAX
            attr.HpCurrent = params.data.HPCurrent
            attr.Luck = params.data.Luck
            attr.Exp = params.data.Exp
            attr.Star = params.data.Star
            attr.Level = params.data.Level

            attr.sAp = params.data.sAP
            attr.sDef = params.data.sDEF
            attr.sHp = params.data.sHP
            attr.sLuck = params.data.sLuck

            attr.Pos0 = params.data.pos[0]
            attr.Pos1 = params.data.pos[1]
            attr.Pos2 = params.data.pos[2]
            attr.Pos3 = params.data.pos[3]
        }

        attr.save();
    }
}

export function handlePutOnEquipEvent(event: putOnEquipEvent): void {
    let params = event.params;
    let attr = getOrCreateNFTAttr(params.tokenId.toHex());

    for(let i=0; i<params.pos.length; i++) {
        let contract = fetchEquip(Address.fromString(EQUIP_ADDRESS.toLowerCase()))
        if (contract != null) {
            if(params.equipId[i] == BigInt.zero()) {
                if( params.pos[i] == 0) attr.Equip0 = null;
                else if( params.pos[i] == 1) attr.Equip1 = null;
                else if( params.pos[i] == 2) attr.Equip2 = null;
                else if( params.pos[i] == 3) attr.Equip3 = null;           
            }else {
                let token = fetchEquipToken(contract, params.equipId[i]);
                if( params.pos[i] == 0) attr.Equip0 = token.id;
                else if( params.pos[i] == 1) attr.Equip1 = token.id;
                else if( params.pos[i] == 2) attr.Equip2 = token.id;
                else if( params.pos[i] == 3) attr.Equip3 = token.id;
            }
        }
    }
    attr.save()
}
