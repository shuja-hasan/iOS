// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
@testable import Trust

extension Config {
    static func make(
        defaults: UserDefaults = .test
    ) -> Config {
        return Config(
            defaults: defaults
        )
    }
}
