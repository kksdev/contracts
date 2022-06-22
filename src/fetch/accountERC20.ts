import {
	Address,
} from '@graphprotocol/graph-ts'

import {
	KSTokenAccount,
} from '../../generated/schema'

export function fetchAccount(address: Address): KSTokenAccount {
	let account = new KSTokenAccount(address.toHex())
	account.save()
	return account
}
