import {
	Address,
} from '@graphprotocol/graph-ts'

import {
	KSEQUIPAccount,
} from '../../generated/schema'

export function fetchAccount(address: Address): KSEQUIPAccount {
	let account = new KSEQUIPAccount(address.toHex())
	account.save()
	return account
}
