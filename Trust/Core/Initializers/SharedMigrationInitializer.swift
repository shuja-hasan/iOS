// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import RealmSwift

final class SharedMigrationInitializer: Initializer {
    lazy var config: Realm.Configuration = {
        RealmConfiguration.sharedConfiguration()
    }()

    init() {}

    func perform() {
        config.schemaVersion = Config.dbMigrationSchemaVersion
        config.migrationBlock = { migration, oldSchemaVersion in
            switch oldSchemaVersion {
            case 0 ... 52:
                migration.deleteData(forType: CoinTicker.className)
            default:
                break
            }
        }
    }
}
