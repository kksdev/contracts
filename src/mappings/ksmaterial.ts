import {
	ethereum,
	BigInt,
} from '@graphprotocol/graph-ts'

import {
	KSMAccount,
	KSMContract,
	KSMTransfer,
	KSMTransaction
} from '../../generated/schema'

import {
	ApprovalForAll as ApprovalForAllEvent,
	TransferBatch  as TransferBatchEvent,
	TransferSingle as TransferSingleEvent,
	URI            as URIEvent,
} from '../../generated/KSMaterial/IERC1155'

import {
	constants,
	decimals,
	events,
	//transactions,
} from '@amxx/graphprotocol-utils'

import {
	fetchAccount,
} from '../fetch/accountERC1155'

import {
	fetchKSM,
	fetchKSMToken,
	fetchKSMBalance,
	fetchERC721Operator,
} from '../fetch/erc1155'


export namespace transactions {
	export function log(event: ethereum.Event): KSMTransaction {
		let tx = new KSMTransaction(event.transaction.hash.toHex())
		tx.timestamp   = event.block.timestamp
		tx.blockNumber = event.block.number
		tx.save()
		return tx as KSMTransaction
	}
	export type Tx = KSMTransaction
}


function registerTransfer(
	event:    ethereum.Event,
	suffix:   string,
	contract: KSMContract,
	operator: KSMAccount,
	from:     KSMAccount,
	to:       KSMAccount,
	id:       BigInt,
	value:    BigInt)
: void
{
	let token      = fetchKSMToken(contract, id)
	let ev         = new KSMTransfer(events.id(event).concat(suffix))
	ev.emitter     = token.id
	ev.transaction = transactions.log(event).id
	ev.timestamp   = event.block.timestamp
	ev.contract    = contract.id
	ev.token       = token.id
	ev.operator    = operator.id
	ev.value       = decimals.toDecimals(value)
	ev.valueExact  = value

	if (from.id == constants.ADDRESS_ZERO.toHex()) {
		let totalSupply        = fetchKSMBalance(token, null)
		totalSupply.valueExact = totalSupply.valueExact.plus(value)
		totalSupply.value      = decimals.toDecimals(totalSupply.valueExact)
		totalSupply.save()
	} else {
		let balance            = fetchKSMBalance(token, from)
		balance.valueExact     = balance.valueExact.minus(value)
		balance.value          = decimals.toDecimals(balance.valueExact)
		balance.save()

		ev.from                = from.id
		ev.fromBalance         = balance.id
	}

	if (to.id == constants.ADDRESS_ZERO.toHex()) {
		let totalSupply        = fetchKSMBalance(token, null)
		totalSupply.valueExact = totalSupply.valueExact.minus(value)
		totalSupply.value      = decimals.toDecimals(totalSupply.valueExact)
		totalSupply.save()
	} else {
		let balance            = fetchKSMBalance(token, to)
		balance.valueExact     = balance.valueExact.plus(value)
		balance.value          = decimals.toDecimals(balance.valueExact)
		balance.save()

		ev.to                  = to.id
		ev.toBalance           = balance.id
	}

	token.save()
	ev.save()
}

export function handleTransferSingle(event: TransferSingleEvent): void
{
	let contract = fetchKSM(event.address)
	let operator = fetchAccount(event.params.operator)
	let from     = fetchAccount(event.params.from)
	let to       = fetchAccount(event.params.to)

	registerTransfer(
		event,
		"",
		contract,
		operator,
		from,
		to,
		event.params.id,
		event.params.value
	)
}

export function handleTransferBatch(event: TransferBatchEvent): void
{
	let contract = fetchKSM(event.address)
	let operator = fetchAccount(event.params.operator)
	let from     = fetchAccount(event.params.from)
	let to       = fetchAccount(event.params.to)

	let ids    = event.params.ids
	let values = event.params.values
	for (let i = 0;  i < ids.length; ++i)
	{
		registerTransfer(
			event,
			"/".concat(i.toString()),
			contract,
			operator,
			from,
			to,
			ids[i],
			values[i]
		)
	}
}

export function handleApprovalForAll(event: ApprovalForAllEvent): void {
	let contract         = fetchKSM(event.address)
	let owner            = fetchAccount(event.params.account)
	let operator         = fetchAccount(event.params.operator)
	let delegation       = fetchERC721Operator(contract, owner, operator)
	delegation.approved  = event.params.approved
	delegation.save()
}

export function handleURI(event: URIEvent): void
{
	let contract = fetchKSM(event.address)
	let token    = fetchKSMToken(contract, event.params.id)
	token.uri    = event.params.value
	token.save()
}
