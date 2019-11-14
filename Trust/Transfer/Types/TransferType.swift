// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

struct Transfer {
    let server: RPCServer
    let type: TransferType
}

enum TransferType {
    case ether(TokenObject, destination: EthereumAddress?)
    case token(TokenObject)
    case dapp(TokenObject, DAppRequester)
}

extension TransferType {
    func symbol(server: RPCServer) -> String {
        switch self {
        case .ether, .dapp:
            return server.symbol
        case let .token(token):
            return token.symbol
        }
    }

    // used for pricing
    var contract: String {
        switch self {
        case let .ether(token, _):
            return token.contract
        case let .dapp(token, _):
            return token.contract
        case let .token(token):
            return token.contract
        }
    }

    var token: TokenObject {
        switch self {
        case let .ether(token, _):
            return token
        case let .dapp(token, _):
            return token
        case let .token(token):
            return token
        }
    }

    var address: EthereumAddress {
        switch self {
        case let .ether(token, _):
            return token.address
        case let .dapp(token, _):
            return token.address
        case let .token(token):
            return token.address
        }
    }
}
