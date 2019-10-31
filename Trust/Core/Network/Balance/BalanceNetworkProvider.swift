// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import PromiseKit
import TrustCore

protocol BalanceNetworkProvider {
    var addressUpdate: EthereumAddress { get }
    func balance() -> Promise<BigInt>
}
