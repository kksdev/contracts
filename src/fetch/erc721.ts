import {
	Address,
	BigInt,
} from '@graphprotocol/graph-ts'

import {
	KSNFTAccount,
	KSNFTContract,
	KSNFTToken,
	KSNFTOperator,
	NFTAttr,
} from '../../generated/schema'

import {
	ERC721,
} from '../../generated/ERC721/ERC721'

import {
	constants,
} from '@amxx/graphprotocol-utils'

import {
	fetchAccount
} from './accountERC721'

import {
	supportsInterface,
} from './erc165'

export function fetchERC721(address: Address): KSNFTContract | null {
	let erc721           = ERC721.bind(address)

	let account          = fetchAccount(address)
	let detectionId      = account.id.concat('/erc721detection')
	let detectionAccount = KSNFTAccount.load(detectionId)

	if (detectionAccount == null) {
		detectionAccount = new KSNFTAccount(detectionId)
		let introspection_01ffc9a7 = supportsInterface(erc721, '01ffc9a7') // ERC165
		let introspection_80ac58cd = supportsInterface(erc721, '80ac58cd') // ERC721
		let introspection_00000000 = supportsInterface(erc721, '00000000', false)
		let isERC721               = introspection_01ffc9a7 && introspection_80ac58cd && introspection_00000000
		detectionAccount.asKSNFT  = isERC721 ? account.id : null
		detectionAccount.save()
	}

	if (detectionAccount.asKSNFT != null) {
		let contract = KSNFTContract.load(account.id)

		if (contract == null) {
			contract                  = new KSNFTContract(account.id)
			let try_name              = erc721.try_name()
			let try_symbol            = erc721.try_symbol()
			contract.name             = try_name.reverted   ? '' : try_name.value
			contract.symbol           = try_symbol.reverted ? '' : try_symbol.value
			contract.supportsMetadata = supportsInterface(erc721, '5b5e139f') // KSNFTMetadata
			contract.asAccount        = account.id
			account.asKSNFT          = account.id
			contract.sellingTotal	= 0
			contract.soldTotal		= 0
			
			contract.save()
			account.save()
		}
		return contract as KSNFTContract
	}

	return null;
}

export function fetchERC721_2(address: Address): KSNFTContract | null {

	let account          = fetchAccount(address)
	let contract = KSNFTContract.load(account.id)
	return contract;
}

export function fetchERC721Token(contract: KSNFTContract, identifier: BigInt): KSNFTToken {
	let id = contract.id.concat('/').concat(identifier.toHex())
	let token = KSNFTToken.load(id)

	if (token == null) {
		token            = new KSNFTToken(id)
		token.contract   = contract.id
		token.identifier = identifier
		token.approval   = fetchAccount(Address.fromString(constants.ADDRESS_ZERO)).id

		if (contract.supportsMetadata) {
			let erc721       = ERC721.bind(Address.fromString(contract.id))
			let try_tokenURI = erc721.try_tokenURI(identifier)
			token.uri        = try_tokenURI.reverted ? '' : try_tokenURI.value
		}
	}

	return token as KSNFTToken
}

export function fetchERC721Operator(contract: KSNFTContract, owner: KSNFTAccount, operator: KSNFTAccount): KSNFTOperator {
	let id = contract.id.concat('/').concat(owner.id).concat('/').concat(operator.id)
	let op = KSNFTOperator.load(id)

	if (op == null) {
		op          = new KSNFTOperator(id)
		op.contract = contract.id
		op.owner    = owner.id
		op.operator = operator.id
	}

	return op as KSNFTOperator
}

export function getOrCreateNFTAttr(id: string): NFTAttr {
    let attr = NFTAttr.load(id);

    if (attr == null) {
        attr = new NFTAttr(id);
    }
    return attr;
}