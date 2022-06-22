import {
	Address,
} from '@graphprotocol/graph-ts'

import {
	KSNFTAccount,
} from '../../generated/schema'

export function fetchAccount(address: Address): KSNFTAccount {
	let account = new KSNFTAccount(address.toHex())
	account.save()
	return account
}
