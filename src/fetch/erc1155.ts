import {
	Address,
	BigInt,
} from '@graphprotocol/graph-ts'

import {
	KSMAccount,
	KSMContract,
	KSMToken,
	KSMBalance,
	KSMOperator,
} from '../../generated/schema'

import {
	constants,
} from '@amxx/graphprotocol-utils'

import {
	fetchAccount,
} from './accountERC1155'

export function fetchKSM(address: Address): KSMContract {
	let account        = fetchAccount(address)
	let contract       = KSMContract.load(account.id)
	if ( contract == null )
	{
		contract       = new KSMContract(account.id)
		contract.asAccount = account.id
		account.asKSM  = contract.id
		contract.sellingTotal = 0;
		contract.soldTotal = 0;
		contract.save()
		account.save()
	}


	return contract
}

export function fetchKSMToken(contract: KSMContract, identifier: BigInt): KSMToken {
	let id = contract.id.concat('/').concat(identifier.toHex())
	let token = KSMToken.load(id)

	if (token == null) {
		token                  = new KSMToken(id)
		token.contract         = contract.id
		token.identifier       = identifier
		token.totalSupply      = fetchKSMBalance(token as KSMToken, null).id
		token.save()
	}

	return token as KSMToken
}

export function fetchKSMBalance(token: KSMToken, account: KSMAccount | null): KSMBalance {
	let id = token.id.concat('/').concat(account ? account.id : 'totalSupply')
	let balance = KSMBalance.load(id)

	if (balance == null) {
		balance            = new KSMBalance(id)
		balance.contract   = token.contract
		balance.token      = token.id
		balance.account    = account ? account.id : null
		balance.value      = constants.BIGDECIMAL_ZERO
		balance.valueExact = constants.BIGINT_ZERO
		balance.save()
	}

	return balance as KSMBalance
}

export function fetchERC721Operator(contract: KSMContract, owner: KSMAccount, operator: KSMAccount): KSMOperator {
	let id = contract.id.concat('/').concat(owner.id).concat('/').concat(operator.id)
	let op = KSMOperator.load(id)

	if (op == null) {
		op          = new KSMOperator(id)
		op.contract = contract.id
		op.owner    = owner.id
		op.operator = operator.id
	}

	return op as KSMOperator
}
