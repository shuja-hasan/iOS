// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Eureka
import Foundation

public struct PrivateKeyRule<T: Equatable>: RuleType {
    public init(msg: String = "Private Key has to be 64 characters long") {
        validationError = ValidationError(msg: msg)
    }

    public var id: String?
    public var validationError: ValidationError

    public func isValid(value: T?) -> ValidationError? {
        if let str = value as? String {
            return (str.count != 64) ? validationError : nil
        }
        return value != nil ? nil : validationError
    }
}
