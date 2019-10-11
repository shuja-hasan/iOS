// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import TrustKeystore

extension DecryptError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return "Invalid Password"
        case .invalidCipher:
            return "Invalid Cipher"
        case .unsupportedCipher:
            return "Unsupported Cipher"
        case .unsupportedKDF:
            return "Unsupported KDF"
        }
    }
}
