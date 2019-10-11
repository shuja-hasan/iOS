// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import RealmSwift
@testable import Trust

class FakeTransactionsStorage: TransactionsStorage {
    convenience init() {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm" + UUID().uuidString))
        self.init(realm: realm, account: .make())
    }
}

class FakeWalletStorage: WalletStorage {
    convenience init() {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm" + UUID().uuidString))
        self.init(realm: realm)
    }
}
