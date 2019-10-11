// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
@testable import Trust

extension ChainState {
    static func make(
        server _: RPCServer = .make()
    ) -> ChainState {
        return ChainState(
            server: .make()
        )
    }
}
