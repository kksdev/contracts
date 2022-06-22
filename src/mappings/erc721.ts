import {
	KSNFTTransfer,
	KSNFTTransaction,
} from '../../generated/schema'

import {
	Approval       as ApprovalEvent,
	ApprovalForAll as ApprovalForAllEvent,
	Transfer       as TransferEvent,
} from '../../generated/ERC721/ERC721'

import {
	events,
} from '@amxx/graphprotocol-utils'

import {
	fetchAccount,
} from '../fetch/accountERC721'

import {
	fetchERC721,
	fetchERC721Token,
	fetchERC721Operator,
} from '../fetch/erc721'

import {
	ethereum,
} from '@graphprotocol/graph-ts'



export namespace transactions {
	export function log(event: ethereum.Event): KSNFTTransaction {
		let tx = new KSNFTTransaction(event.transaction.hash.toHex())
		tx.timestamp   = event.block.timestamp
		tx.blockNumber = event.block.number
		tx.save()
		return tx as KSNFTTransaction
	}
	export type Tx = KSNFTTransaction
}


export function handleTransfer(event: TransferEvent): void {
	let contract = fetchERC721(event.address)
	if (contract != null) {
		let token = fetchERC721Token(contract, event.params.tokenId)
		let from  = fetchAccount(event.params.from)
		let to    = fetchAccount(event.params.to)
		
		token.owner = to.id

		contract.save()
		token.save()

		let ev         = new KSNFTTransfer(events.id(event))
		ev.emitter     = contract.id
		ev.transaction = transactions.log(event).id
		ev.timestamp   = event.block.timestamp
		ev.contract    = contract.id
		ev.token       = token.id
		ev.from        = from.id
		ev.to          = to.id
		ev.save()
	}
}

export function handleApproval(event: ApprovalEvent): void {
	let contract = fetchERC721(event.address)
	if (contract != null) {
		let token    = fetchERC721Token(contract, event.params.tokenId)
		let owner    = fetchAccount(event.params.owner)
		let approved = fetchAccount(event.params.approved)

		token.owner    = owner.id
		token.approval = approved.id

		token.save()
		owner.save()
		approved.save()

		// let ev = new Approval(events.id(event))
		// ev.emitter     = contract.id
		// ev.transaction = transactions.log(event).id
		// ev.timestamp   = event.block.timestamp
		// ev.token       = token.id
		// ev.owner       = owner.id
		// ev.approved    = approved.id
		// ev.save()
	}
}

export function handleApprovalForAll(event: ApprovalForAllEvent): void {
	let contract = fetchERC721(event.address)
	if (contract != null) {
		let owner      = fetchAccount(event.params.owner)
		let operator   = fetchAccount(event.params.operator)
		let delegation = fetchERC721Operator(contract, owner, operator)

		delegation.approved = event.params.approved

		delegation.save()

		// 	let ev = new ApprovalForAll(events.id(event))
		// 	ev.emitter     = contract.id
		// 	ev.transaction = transactions.log(event).id
		// 	ev.timestamp   = event.block.timestamp
		// 	ev.delegation  = delegation.id
		// 	ev.owner       = owner.id
		// 	ev.operator    = operator.id
		// 	ev.approved    = event.params.approved
		// 	ev.save()
	}
}
