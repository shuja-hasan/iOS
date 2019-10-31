// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation

public struct GasLimitConfiguration {
    static let `default` = BigInt(90000)
    static let min = BigInt(21000)
    static let max = BigInt(600_000)
    static let tokenTransfer = BigInt(144_000)
    static let dappTransfer = BigInt(600_000)
}
