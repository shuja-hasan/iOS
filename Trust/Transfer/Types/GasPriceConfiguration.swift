// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation

public struct GasPriceConfiguration {
    static let `default`: BigInt = EtherNumberFormatter.full.number(from: "24", units: UnitConfiguration.gasPriceUnit)!
    static let min: BigInt = EtherNumberFormatter.full.number(from: "1", units: UnitConfiguration.gasPriceUnit)!
    static let max: BigInt = EtherNumberFormatter.full.number(from: "100", units: UnitConfiguration.gasPriceUnit)!
}
