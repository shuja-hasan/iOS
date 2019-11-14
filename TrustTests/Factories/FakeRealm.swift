// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import RealmSwift
@testable import Trust

extension Realm {
    static func make() -> Realm {
        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
    }
}
