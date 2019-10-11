// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

struct SendTransaction: Decodable {
    let from: String
    let to: String?
    let value: String?
    let gas: String?
    let gasPrice: String?
    let data: String?
    let nonce: String?
}
