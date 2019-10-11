// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
@testable import Trust

extension WalletObject {
    static func make(
        id: String = "1"
    ) -> WalletObject {
        let object = WalletObject()
        object.id = id
        return object
    }
}
