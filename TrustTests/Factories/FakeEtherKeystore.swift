// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import KeychainSwift
import Result
@testable import Trust
import TrustKeystore

class FakeEtherKeystore: EtherKeystore {
    convenience init() {
        let uniqueString = NSUUID().uuidString
        self.init(
            keychain: KeychainSwift(keyPrefix: "fake" + uniqueString),
            keysSubfolder: "/keys" + uniqueString,
            userDefaults: UserDefaults.test,
            storage: FakeWalletStorage()
        )
    }

    override func createAccount(with _: String, completion: @escaping (Result<Wallet, KeystoreError>) -> Void) {
        completion(.success(.make()))
    }
}
