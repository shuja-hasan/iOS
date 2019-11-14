// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import TrustCore

struct UnconfirmedTransaction {
    let transfer: Transfer
    let value: BigInt
    let to: EthereumAddress?
    let data: Data?

    let gasLimit: BigInt?
    let gasPrice: BigInt?
    let nonce: BigInt?
}
