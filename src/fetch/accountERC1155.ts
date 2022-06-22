import {
	Address,
} from '@graphprotocol/graph-ts'

import {
	KSMAccount,
} from '../../generated/schema'

export function fetchAccount(address: Address): KSMAccount {
	let account = new KSMAccount(address.toHex())
	account.save()
	return account
}
