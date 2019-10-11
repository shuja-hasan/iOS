// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
@testable import Trust

extension GasViewModel {
    static func make(fee: BigInt = BigInt(100), server: RPCServer = .main, store: TokensDataStore = FakeTokensDataStore()) -> GasViewModel {
        return GasViewModel(fee: fee, server: server, store: store)
    }
}
