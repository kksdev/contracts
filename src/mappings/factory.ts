import { BigInt, Address } from "@graphprotocol/graph-ts";
import { KSFarm, KSProof } from "../../generated/schema";
import {
	decimals
} from '@amxx/graphprotocol-utils'

import {
	FarmInEvent,
	FarmOutEvent,
    FarmUpdateTime, 
    TransferProof as TransferProofEvent
} from '../../generated/Factory/Factory'

import {
	fetchAccount,
} from '../fetch/accountERC721'

import {
	fetchERC721,
	fetchERC721Token,
} from '../fetch/erc721'

let NFT_ADDRESS = "0xaf52B970D958F653A0097E7292599f13144CaaaC";

export function getOrCreateKSFarm(id: string): KSFarm {
    let farm = KSFarm.load(id);

    if (!farm) {
        farm = new KSFarm(id);
    }
    return farm;
}

export function getOrCreateKSProof(id: string): KSProof {
    let proof = KSProof.load(id);

    if (!proof) {
        proof = new KSProof(id);
    }
    return proof;
}

export function getKSFarmId(
    owner: Address,
    tokenId: BigInt
  ): string {
    return [
      owner.toHexString(),
      tokenId.toHexString(),
    ].join("-");
  }


export function getKSProofId(
    buyer: Address,
    seed: BigInt
  ): string {
    return [
        buyer.toHexString(),
        seed.toHexString(),
    ].join("-");
  }

export function handleFarmInEvent(event: FarmInEvent): void {
    let params = event.params;

    let contract = fetchERC721(Address.fromString(NFT_ADDRESS.toLowerCase()))
	if (contract != null) {
        let owner = fetchAccount(params.farmer)

        for(let i=0;i<params.ids.length;i++){
            let farm = getOrCreateKSFarm(getKSFarmId(params.farmer,params.ids[i]));
            let token = fetchERC721Token(contract, params.ids[i]);
            farm.owner = owner.id;
            farm.farmId = params.farmId;
            farm.token = token.id;
            farm.timestamp = event.block.timestamp;
            farm.active = true;

            farm.save()
        }
    }
}

export function handleFarmOutEvent(event: FarmOutEvent): void {
    let params = event.params;

    for(let i=0;i<params.ids.length;i++){
        let farm = getOrCreateKSFarm(getKSFarmId(params.farmer,params.ids[i]));
        farm.active = false;
        farm.save();;
    }
}

export function handleFarmUpdateTime(event: FarmUpdateTime): void {
    let params = event.params;

    for(let i=0;i<params.ids.length;i++){
        let farm = getOrCreateKSFarm(getKSFarmId(params.farmer,params.ids[i]));
        farm.timestamp = event.block.timestamp;
        farm.save();
    }
}

export function handleTransferProof(event: TransferProofEvent): void {
    let params = event.params;
    let proof = getOrCreateKSProof(getKSProofId(params.buyer, params.seed));
    proof.buyer = params.buyer.toHexString();
    proof.seed = params.seed;
    proof.value = decimals.toDecimals(event.params.value, 18);
    proof.valueExact = params.value;
    proof.timestamp = event.block.timestamp;
    proof.transferType = params.transferType;
    proof.save();
}