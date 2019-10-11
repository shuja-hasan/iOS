// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
@testable import Trust
import TrustCore

extension GetNonceProvider {
    static func make(
        storage: TransactionsStorage = FakeTransactionsStorage(),
        server: RPCServer = .main,
        address: Address = EthereumAddress.zero
    ) -> GetNonceProvider {
        return GetNonceProvider(
            storage: storage,
            server: server,
            address: address
        )
    }
}
