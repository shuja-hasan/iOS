// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
@testable import Trust
import TrustCore
import TrustKeystore

extension Wallet {
    static func k() -> KeystoreKey {
        var key = try! KeystoreKey(password: "hello", for: .ethereum)
        key.activeAccounts.append(.make())
        return key
    }

    static func make(
        key: KeystoreKey = Wallet.k()
    ) -> Wallet {
        let datadir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: datadir + "/k/test.json")

        let wallet = Wallet(
            keyURL: url,
            key: key
        )
        _ = try! wallet.getAccount(password: "hello")
        return wallet
    }
}

extension Account {
    static func make(wallet _: Wallet) -> Account {
        return Account(
            wallet: .make(),
            address: EthereumAddress.make(),
            derivationPath: Coin.ethereum.derivationPath(at: 0)
        )
    }
}
