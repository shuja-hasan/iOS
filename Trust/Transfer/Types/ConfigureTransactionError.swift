// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation

enum ConfigureTransactionError: LocalizedError {
    case gasLimitTooHigh
    case gasFeeTooHigh(RPCServer)

    var errorDescription: String? {
        switch self {
        case .gasLimitTooHigh:
            return String(
                format: NSLocalizedString(
                    "configureTransaction.error.gasLimitTooHigh",
                    value: "Gas Limit too high. Max available: %d",
                    comment: ""
                ),
                ConfigureTransaction.gasLimitMax
            )
        case let .gasFeeTooHigh(server):
            return String(
                format: NSLocalizedString(
                    "configureTransaction.error.gasFeeHigh",
                    value: "Gas Fee is too high. Max available: %@ %@",
                    comment: ""
                ),
                EtherNumberFormatter.full.string(from: ConfigureTransaction.gasFeeMax),
                server.symbol
            )
        }
    }
}
