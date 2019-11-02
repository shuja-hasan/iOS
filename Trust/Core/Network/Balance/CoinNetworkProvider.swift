// Copyright DApps Platform Inc. All rights reserved.

import APIKit
import BigInt
import Foundation
import JSONRPCKit
import PromiseKit
import TrustCore

final class CoinNetworkProvider: BalanceNetworkProvider {
    let server: RPCServer
    let address: Address
    let addressUpdate: EthereumAddress

    init(
        server: RPCServer,
        address: Address,
        addressUpdate: EthereumAddress
    ) {
        self.server = server
        self.address = address
        self.addressUpdate = addressUpdate
    }

    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(BalanceRequest(address: address.description)))
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
