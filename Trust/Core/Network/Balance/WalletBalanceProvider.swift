// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import APIKit
import BigInt
import Foundation
import JSONRPCKit
import PromiseKit
import TrustCore

final class WalletBalanceProvider: BalanceNetworkProvider {
    let server: RPCServer
    let addressUpdate: EthereumAddress

    init(
        server: RPCServer,
        addressUpdate: EthereumAddress
    ) {
        self.server = server
        self.addressUpdate = addressUpdate
    }

    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(BalanceRequest(address: addressUpdate.description)))
            Session.send(request) { result in
                switch result {
                case let .success(balance):
                    seal.fulfill(balance.value)
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
