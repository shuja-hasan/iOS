// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
import Result

protocol NonceProvider {
    var remoteNonce: BigInt? { get }
    var latestNonce: BigInt? { get }
    var nextNonce: BigInt? { get }
    var nonceAvailable: Bool { get }
    func getNextNonce(force: Bool, completion: @escaping (Result<BigInt, AnyError>) -> Void)
}
