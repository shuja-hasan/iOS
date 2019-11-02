// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation

struct TransactionConfiguration {
    let gasPrice: BigInt
    let gasLimit: BigInt
    let data: Data
    let nonce: BigInt
}
