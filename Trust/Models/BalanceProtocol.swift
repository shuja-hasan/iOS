// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation

protocol BalanceProtocol {
    var value: BigInt { get }
    var amountShort: String { get }
    var amountFull: String { get }
}
