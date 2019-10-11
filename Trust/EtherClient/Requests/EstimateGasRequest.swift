// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
import JSONRPCKit
import TrustCore

struct EstimateGasRequest: JSONRPCKit.Request {
    typealias Response = String

    let transaction: SignTransaction

    var method: String {
        return "eth_estimateGas"
    }

    var parameters: Any? {
        return [
            [
                "from": transaction.account.address.description.lowercased(),
                "to": transaction.to?.description.lowercased() ?? "",
                // TODO: Update gas limit when changed by the user.
                // Hardcoded for simplicify to fetch estimated gas
                // "gas": BigInt(7_000_000).hexEncoded,
                "gasPrice": transaction.gasPrice.hexEncoded,
                "value": transaction.value.hexEncoded,
                "data": transaction.data.hexEncoded,
            ],
        ]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
