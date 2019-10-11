// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

struct ERC20Contract: Decodable {
    let address: String
    let name: String
    let totalSupply: String
    let decimals: Int
    let symbol: String
}
