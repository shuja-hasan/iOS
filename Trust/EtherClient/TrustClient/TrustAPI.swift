// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import Moya

enum TrustAPI {
    case getTransactions(server: RPCServer, address: String, startBlock: Int, page: Int, contract: String?)

    // all
    case prices(TokensPrice)
    case getAllTransactions(addresses: [String: String])
    case search(query: String, networks: [Int])
    case collectibles([String: [String]])
    case getTokens([String: [String]])
    case register(device: PushDevice)
    case unregister(device: PushDevice)
}

extension TrustAPI: TargetType {
    var baseURL: URL { return Constants.trustAPI }

    var path: String {
        switch self {
        case .prices:
            return "/prices"
        case let .getTransactions(value):
            return "/\(value.server.id)/transactions"
        case .getTokens:
            return "/tokens"
        case .getAllTransactions:
            return "/transactions"
        case .register:
            return "/notifications/register"
        case .unregister:
            return "/notifications/unregister"
        case .collectibles:
            return "/collectibles"
        case .search:
            return "/tokens/list"
        }
    }

    var method: Moya.Method {
        switch self {
        case .prices: return .post
        case .getTransactions: return .get
        case .getTokens: return .post
        case .getAllTransactions: return .post
        case .register: return .post
        case .unregister: return .post
        case .collectibles: return .post
        case .search: return .get
        }
    }

    var task: Task {
        switch self {
        case let .prices(tokensPrice):
            return .requestJSONEncodable(tokensPrice)
        case let .getTransactions(_, address, startBlock, page, contract):
            var params: [String: Any] = ["address": address, "startBlock": startBlock, "page": page]
            if let transactionContract = contract {
                params["contract"] = transactionContract
            }
            return .requestParameters(parameters: params, encoding: URLEncoding())
        case let .getAllTransactions(addresses):
            return .requestParameters(parameters: ["address": addresses], encoding: URLEncoding())
        case let .register(device):
            return .requestJSONEncodable(device)
        case let .unregister(device):
            return .requestJSONEncodable(device)
        case let .collectibles(value), let .getTokens(value):
            return .requestJSONEncodable(value)
        case let .search(query, networks):
            let networkString = networks.map { String($0) }.joined(separator: ",")
            return .requestParameters(parameters: ["query": query, "networks": networkString], encoding: URLEncoding())
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "client": Bundle.main.bundleIdentifier ?? "",
            "client-build": Bundle.main.buildNumber ?? "",
        ]
    }
}
