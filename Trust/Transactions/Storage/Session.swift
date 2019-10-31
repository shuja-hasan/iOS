// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import RealmSwift
import TrustCore

final class WalletSession {
    let account: WalletInfo
    let config: Config
    let realm: Realm
    let sharedRealm: Realm

    var sessionID: String {
        return "\(account.description))"
    }

    lazy var walletStorage: WalletStorage = {
        WalletStorage(realm: sharedRealm)
    }()

    lazy var tokensStorage: TokensDataStore = {
        TokensDataStore(realm: realm, account: account)
    }()

    lazy var transactionsStorage: TransactionsStorage = {
        TransactionsStorage(
            realm: realm,
            account: account
        )
    }()

    lazy var currentRPC: RPCServer = {
        if account.multiWallet {
            return .ether1
        }
        return account.coin!.server
    }()

    init(
        account: WalletInfo,
        realm: Realm,
        sharedRealm: Realm,
        config: Config
    ) {
        self.account = account
        self.realm = realm
        self.sharedRealm = sharedRealm
        self.config = config
    }
}
