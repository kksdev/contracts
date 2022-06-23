import { BigInt, Address, log, store } from "@graphprotocol/graph-ts";
import { Listing, NFTAttr, Listing1155, ListingEquip} from "../../generated/schema";
import {
	constants,
	decimals,
	events,
	
} from '@amxx/graphprotocol-utils'

import {
	NewListing       as NewListingEvent,
	ListingChange    as ListingChangeEvent,
	CancelledListing as CancelledListingEvent,
    PurchasedListing as PurchasedListingEvent,
    NewListing1155       as NewListing1155Event,
	ListingChange1155    as ListingChange1155Event,
	CancelledListing1155 as CancelledListing1155Event,
    PurchasedListing1155 as PurchasedListing1155Event
} from '../../generated/Market/Market'

import {
	fetchAccount,
} from '../fetch/accountERC721'

import {
	fetchAccount as fetchEquipAccount,
} from '../fetch/accountEQUIP'

import {
	fetchAccount as fetch1155Account,
} from '../fetch/accountERC1155'

import {
	fetchERC721_2,
	fetchERC721Token,
	fetchERC721Operator,
    getOrCreateNFTAttr,
} from '../fetch/erc721'

import {
	fetchERC721_2 as fetchEquip,
	fetchERC721Token as fetchEquipToken,
    getOrCreateEQUIPAttr,
} from '../fetch/equip'

import {
	fetchKSM,
	fetchKSMToken,
    //getOrCreateEQUIPAttr,
} from '../fetch/erc1155'

//let NFT_ADDRESS = "0x94Adb3978Ae782d6749f174033fd1248fd8b223E";
//let EQUIP_ADDRESS="0xd1F3f588f70cf8e27080838dC976f50c7a3EEe8b";

export function getOrCreateListing(id: string): Listing {
    let listing = Listing.load(id);

    if (!listing) {
        listing = new Listing(id);
    }
    return listing;
}

export function getOrCreateListingEquip(id: string): ListingEquip {
    let listing = ListingEquip.load(id);

    if (!listing) {
        listing = new ListingEquip(id);
    }
    return listing;
}

export function getOrCreateListing1155(id: string): Listing1155 {
    let listing = Listing1155.load(id);

    if (!listing) {
        listing = new Listing1155(id);
    }
    return listing;
}

export function getListingId(
    seller: Address,
    tokenAddress: Address,
    tokenId: BigInt
  ): string {
    return [
      seller.toHexString(),
      tokenAddress.toHexString(),
      tokenId.toHexString(),
    ].join("-");
  }

export function handleNewListing(event: NewListingEvent): void {
    let params = event.params;

    let contract = fetchERC721_2(params.nftAddress)
	if (contract != null) {
		let token = fetchERC721Token(contract, params.nftID)
        let user_seller = fetchAccount(params.seller)

        let listing = getOrCreateListing(getListingId(params.seller, params.nftAddress, params.nftID));
        let attr = getOrCreateNFTAttr(params.nftID.toHex());
        
        listing.seller = user_seller.id;
        listing.buyer = "";
        listing.token = token.id;
        listing.price = decimals.toDecimals(params.price, 18);
        listing.priceExact = params.price;
        listing.status = "Active";
        listing.addTimestamp = event.block.timestamp;
        listing.soldTimestamp = constants.BIGINT_ZERO;
        listing.contract = contract.id;
 
        listing.Name = attr.Name
        listing.ModelId = attr.ModelId
        listing.HeroId = attr.HeroId
        listing.Qualitity = attr.Qualitity
        
        listing.Ap = attr.Ap
        listing.Def = attr.Def
        listing.HpMAX = attr.HpMAX
        listing.HpCurrent = attr.HpCurrent
        listing.Luck = attr.Luck
        listing.Exp = attr.Exp
        listing.Star = attr.Star
        listing.Level = attr.Level

        listing.bAp = attr.bAp
        listing.bDef = attr.bDef
        listing.bHp = attr.bHp
        listing.bLuck = attr.bLuck

        listing.Equip0 = attr.Equip0
        listing.Equip1 = attr.Equip1
        listing.Equip2 = attr.Equip2
        listing.Equip3 = attr.Equip3

        listing.Pos0 = attr.Pos0
        listing.Pos1 = attr.Pos1
        listing.Pos2 = attr.Pos2
        listing.Pos3 = attr.Pos3

        contract.sellingTotal += 1
        contract.save()

        listing.save();
    } else {
        let equipContract = fetchEquip(params.nftAddress)
        if( equipContract != null ) {
            let token = fetchEquipToken(equipContract, params.nftID)
            let user_seller = fetchEquipAccount(params.seller)
    
            let listing = getOrCreateListingEquip(getListingId(params.seller, params.nftAddress, params.nftID));
            let attr = getOrCreateEQUIPAttr(params.nftID.toHex());

            listing.seller = user_seller.id;
            listing.buyer = "";
            listing.token = token.id;
            listing.price = decimals.toDecimals(params.price, 18);
            listing.priceExact = params.price;
            listing.status = "Active";
            listing.addTimestamp = event.block.timestamp;
            listing.soldTimestamp = constants.BIGINT_ZERO;
            listing.contract = equipContract.id;
     
            listing.Name = attr.Name
            listing.ModelId = attr.ModelId
            listing.Star = attr.Star
            listing.Attr = attr.Attr
            listing.SuitModelId = attr.SuitModelId
            listing.Slot = attr.Slot
    
            equipContract.sellingTotal += 1
            equipContract.save()
    
            listing.save();
        }
    }
}

export function handleListingChange(event: ListingChangeEvent): void {
    let params = event.params;

    let contract = fetchERC721_2(params.nftAddress)
    if( contract != null){
        let listing = getOrCreateListing(getListingId(params.seller, params.nftAddress, params.nftID));
    
        listing.price = decimals.toDecimals(params.newPrice, 18);
        listing.priceExact = params.newPrice;
        listing.save();
    } else {
        let equipContract = fetchEquip(params.nftAddress)
        if( equipContract!=null) {
            let listing = getOrCreateListingEquip(getListingId(params.seller, params.nftAddress, params.nftID));
        
            listing.price = decimals.toDecimals(params.newPrice, 18);
            listing.priceExact = params.newPrice;
            listing.save();            
        }
    }
}

export function handleCancelledListing(event: CancelledListingEvent): void {
    let params = event.params;

    let contract = fetchERC721_2(params.nftAddress)
    if (contract!=null){
        let listing = getOrCreateListing(getListingId(params.seller, params.nftAddress, params.nftID));

        listing.status = "Cancelled";
        listing.save();
    
        contract.sellingTotal -= 1
        contract.save()
   
    }else {
        let equipContract = fetchEquip(params.nftAddress)
        if( equipContract != null) {
            let listing = getOrCreateListingEquip(getListingId(params.seller, params.nftAddress, params.nftID));

            listing.status = "Cancelled";
            listing.save();
        
            equipContract.sellingTotal -= 1
            equipContract.save()
        }
    }
}

export function handlePurchasedListing(event: PurchasedListingEvent): void {
    let params = event.params;

    let contract = fetchERC721_2(params.nftAddress)
    if( contract != null) {
        let user_buyer = fetchAccount(params.buyer)
        let listing = getOrCreateListing(getListingId(params.seller, params.nftAddress, params.nftID));
    
        listing.buyer = user_buyer.id;
        listing.price = decimals.toDecimals(params.price, 18);
        listing.priceExact = params.price;
        listing.status = "Sold";
        listing.soldTimestamp = event.block.timestamp;
        listing.save();
    
        contract.sellingTotal -= 1
        contract.soldTotal += 1
        contract.save()
    }else {
        let equipContract = fetchEquip(params.nftAddress)
        if(equipContract != null) {
            let user_buyer = fetchEquipAccount(params.buyer)
            let listing = getOrCreateListingEquip(getListingId(params.seller, params.nftAddress, params.nftID));
        
            listing.buyer = user_buyer.id;
            listing.price = decimals.toDecimals(params.price, 18);
            listing.priceExact = params.price;
            listing.status = "Sold";
            listing.soldTimestamp = event.block.timestamp;
            listing.save();
        
            equipContract.sellingTotal -= 1
            equipContract.soldTotal += 1
            equipContract.save()    
        }
    }
}

export function handleNewListing1155(event: NewListing1155Event): void {
    let params = event.params;

    let contract = fetchKSM(params.tokenAddr)
	if (contract != null) {
		let token = fetchKSMToken(contract, params.tokenId)
        let user_seller = fetch1155Account(params.seller)

        let listing = getOrCreateListing1155(params.orderId.toHexString());
        listing.orderId = params.orderId;
        listing.seller = user_seller.id;
        listing.token = token.id;
        listing.price = decimals.toDecimals(params.price, 18);
        listing.priceExact = params.price;
        listing.status = "Active";
        listing.addTimestamp = event.block.timestamp;
        listing.soldTimestamp = constants.BIGINT_ZERO;
        listing.contract = contract.id;
        listing.amount = params.amount.toI32();

        contract.sellingTotal += 1
        contract.save()

        listing.save();
    }
}

export function handleListingChange1155(event: ListingChange1155Event): void {
    let params = event.params;

    let contract = fetchKSM(params.tokenAddr)
    if( contract != null){
        let listing = getOrCreateListing1155(params.orderId.toHexString());
    
        listing.price = decimals.toDecimals(params.newPrice, 18);
        listing.priceExact = params.newPrice;
        listing.amount = params.newAmount.toI32();
        listing.save();
    }
}

export function handleCancelledListing1155(event: CancelledListing1155Event): void {
    let params = event.params;

    let contract = fetchKSM(params.tokenAddr)
    if (contract!=null){
        let listing = getOrCreateListing1155(params.orderId.toHexString());

        listing.status = "Cancelled";
        listing.save();
    
        contract.sellingTotal -= 1
        contract.save()
    }
}

export function handlePurchasedListing1155(event: PurchasedListing1155Event): void {
    let params = event.params;

    let contract = fetchKSM(params.tokenAddr)
    if( contract != null) {
        let user_buyer = fetch1155Account(params.buyer)
        let listing = getOrCreateListing1155(params.orderId.toHexString());
    
        listing.buyer = user_buyer.id;
        listing.amount -= params.amount.toI32();

        if (listing.amount<=0) {
            listing.status = "Sold";
            listing.soldTimestamp = event.block.timestamp;
            
            contract.sellingTotal -= 1
            contract.soldTotal += 1
            contract.save()
        }

        listing.save();
    }
}