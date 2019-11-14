// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import RealmSwift
@testable import Trust
import TrustCore

extension WalletSession {
    static func make(
        account: Trust.WalletInfo = .make(),
        config: Config = .make(),
        realm: Realm = .make(),
        sharedRealm: Realm = .make()
    ) -> WalletSession {
        return WalletSession(
            account: account,
            realm: realm,
            sharedRealm: sharedRealm,
            config: config
        )
    }

//    static func makeWithEthBalance(
//        account: Trust.WalletInfo = .make(),
//        config: Config = .make(),
//        amount: String
//    ) -> WalletSession {
//        let balance =  BalanceCoordinator(storage: FakeTokensDataStore())
//        balance.balance = Balance(value:BigInt(amount)!)
//        return WalletSession(
//            account: account,
//            config: config,
//            nonceProvider: GetNonceProvider.make()
//        )
//    }
}
