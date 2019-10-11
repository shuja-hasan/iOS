// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

extension UserDefaults {
    static var test: UserDefaults {
        return UserDefaults(suiteName: NSUUID().uuidString)!
    }
}
