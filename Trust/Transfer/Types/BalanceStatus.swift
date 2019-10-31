// Copyright DApps Platform Inc. All rights reserved.

import Foundation

enum BalanceStatus {
    case ether(etherSufficient: Bool, gasSufficient: Bool)
    case token(tokenSufficient: Bool, gasSufficient: Bool)
}

extension BalanceStatus {
    enum Key {
        case insufficientEther
        case insufficientGas
        case insufficientToken
        case correct

        var string: String {
            switch self {
            case .insufficientEther:
                return NSLocalizedString("send.error.insufficientEther", value: "Insufficient %@ balance", comment: "")
            case .insufficientGas:
                return NSLocalizedString("send.error.insufficientGas", value: "Insufficient %@ to cover gas fee", comment: "")
            case .insufficientToken:
                return NSLocalizedString("send.error.insufficientToken", value: "Insufficient %@ token balance", comment: "")
            case .correct:
                return ""
            }
        }
    }

    var sufficient: Bool {
        switch self {
        case let .ether(etherSufficient, gasSufficient):
            return etherSufficient && gasSufficient
        case let .token(tokenSufficient, gasSufficient):
            return tokenSufficient && gasSufficient
        }
    }

    var insufficientTextKey: Key {
        switch self {
        case let .ether(etherSufficient, gasSufficient):
            if !etherSufficient {
                return .insufficientEther
            }
            if !gasSufficient {
                return .insufficientGas
            }
        case let .token(tokenSufficient, gasSufficient):
            if !tokenSufficient {
                return .insufficientToken
            }
            if !gasSufficient {
                return .insufficientGas
            }
        }
        return .correct
    }

    var insufficientText: String {
        return insufficientTextKey.string
    }
}
