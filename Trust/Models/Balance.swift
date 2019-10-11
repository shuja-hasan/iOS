// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation

struct Balance: BalanceProtocol {
    let value: BigInt

    init(value: BigInt) {
        self.value = value
    }

    var isZero: Bool {
        return value.isZero
    }

    var amountShort: String {
        return EtherNumberFormatter.short.string(from: value)
    }

    var amountFull: String {
        return EtherNumberFormatter.full.string(from: value)
    }
}
