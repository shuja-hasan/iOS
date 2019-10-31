// Copyright DApps Platform Inc. All rights reserved.

import APIKit
import Foundation
import JSONRPCKit
import Result

extension Error {
    var prettyError: String {
        switch self {
        case let error as AnyError:
            switch error.error {
            case let error as APIKit.SessionTaskError:
                switch error {
                case let .connectionError(error):
                    return error.localizedDescription
                case let .requestError(error):
                    return error.localizedDescription
                case let .responseError(error):
                    guard let JSONError = error as? JSONRPCError else {
                        return error.localizedDescription
                    }
                    switch JSONError {
                    case let .responseError(_, message, _):
                        return message
                    default: return "Undefined error"
                    }
                }
            default:
                return error.errorDescription ?? error.description
            }
        case let error as LocalizedError:
            return error.errorDescription ?? "An unknown error occurred."
        case let error as NSError:
            return error.localizedDescription
        default:
            return "Undefined Error"
        }
    }

    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
