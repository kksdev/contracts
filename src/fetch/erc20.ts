import {
	Address,
} from '@graphprotocol/graph-ts'

import {
	KSTokenAccount,
	KSTokenContract,
	KSTokenBalance,
	KSTokenApproval,
} from '../../generated/schema'

import {
	ERC20,
} from '../../generated/ERC20/ERC20'

import {
	constants,
} from '@amxx/graphprotocol-utils'

import {
	fetchAccount
} from './accountERC20'

export function fetchERC20(address: Address): KSTokenContract {
	let account  = fetchAccount(address)
	let contract = KSTokenContract.load(account.id)

	if (contract == null) {
		let endpoint              = ERC20.bind(address)
		let name                  = "IMToken" //endpoint.try_name()
		let symbol                = "IMT"//endpoint.try_symbol()
		let decimals              = 18//endpoint.try_decimals()
		contract                  = new KSTokenContract(account.id)

		// Common
		contract.name        = name
		contract.symbol      = symbol
		contract.decimals    = decimals
		contract.totalSupply = fetchERC20Balance(contract as KSTokenContract, null).id
		contract.asAccount   = account.id
		account.asKSToken      = contract.id
		contract.save()
		account.save()
	}

	return contract as KSTokenContract
}

export function fetchERC20Balance(contract: KSTokenContract, account: KSTokenAccount | null): KSTokenBalance {
	let id      = contract.id.concat('/').concat(account ? account.id : 'totalSupply')
	let balance = KSTokenBalance.load(id)

	if (balance == null) {
		balance                 = new KSTokenBalance(id)
		balance.contract        = contract.id
		balance.account         = account ? account.id : null
		balance.value           = constants.BIGDECIMAL_ZERO
		balance.valueExact      = constants.BIGINT_ZERO
		balance.save()
	}

	return balance as KSTokenBalance
}

export function fetchERC20Approval(contract: KSTokenContract, owner: KSTokenAccount, spender: KSTokenAccount): KSTokenApproval {
	let id       = contract.id.concat('/').concat(owner.id).concat('/').concat(spender.id)
	let approval = KSTokenApproval.load(id)

	if (approval == null) {
		approval                = new KSTokenApproval(id)
		approval.contract       = contract.id
		approval.owner          = owner.id
		approval.spender        = spender.id
		approval.value          = constants.BIGDECIMAL_ZERO
		approval.valueExact     = constants.BIGINT_ZERO
	}

	return approval as KSTokenApproval
}
