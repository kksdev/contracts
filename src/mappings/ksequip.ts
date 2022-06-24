import {
	KSEQUIPTransfer,
	KSEQUIPTransaction,
} from '../../generated/schema'

import {
	Approval       as ApprovalEvent,
	ApprovalForAll as ApprovalForAllEvent,
	Transfer       as TransferEvent,
	MintKSEquip	   as KSEquipEvent,
} from '../../generated/KSEquip/KSEquip'

import {
	events,
} from '@amxx/graphprotocol-utils'

import {
	fetchAccount,
} from '../fetch/accountEQUIP'

import {
	fetchERC721,
	fetchERC721Token,
	fetchERC721Operator,
	getOrCreateEQUIPAttr,
} from '../fetch/equip'

import {
	ethereum,
} from '@graphprotocol/graph-ts'

import equipModel from "../config/EquipModel"

export function handleMintKSEquip(event: KSEquipEvent): void {
    let params = event.params;
    let attr = getOrCreateEQUIPAttr(params.id.toHex());

    let contract = fetchERC721(event.address)
	if (contract != null) {
		let token = fetchERC721Token(contract, event.params.id);
        attr.token = token.id;

        let h = equipModel.get(params.equipId.toI32())
        if ( h!= null )
        {
            attr.Name = ""
            attr.ModelId = h.ModelId as i32
            attr.Attr = h.Attr
			attr.SuitModelId = h.SuitModelId as i32
			attr.Star = h.Star as i32
			attr.Slot = h.Slot as i32
        }

        attr.save();
    }
}
