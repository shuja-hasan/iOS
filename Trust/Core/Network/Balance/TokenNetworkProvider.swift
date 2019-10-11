// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import APIKit
import BigInt
import Foundation
import JSONRPCKit
import PromiseKit
import TrustCore

final class TokenNetworkProvider: BalanceNetworkProvider {
    let server: RPCServer
    let address: EthereumAddress
    let contract: EthereumAddress
    let addressUpdate: EthereumAddress

    init(
        server: RPCServer,
        address: EthereumAddress,
        contract: EthereumAddress,
        addressUpdate: EthereumAddress
    ) {
        self.server = server
        self.address = address
        self.contract = contract
        self.addressUpdate = addressUpdate
    }

    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let encoded = ERC20Encoder.encodeBalanceOf(address: address)
            let request = EtherServiceRequest(
                for: server,
                batch: BatchFactory().create(CallRequest(to: contract.description, data: encoded.hexEncoded))
            )
            Session.send(request) { result in
                switch result {
                case let .success(balance):
                    guard let value = BigInt(balance.drop0x, radix: 16) else {
                        return seal.reject(CookiesStoreError.empty)
                    }
                    seal.fulfill(value)
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
