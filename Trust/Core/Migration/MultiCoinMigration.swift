// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import KeychainSwift
import TrustCore
import TrustKeystore

class MultiCoinMigration {
    struct Keys {
        static let watchAddresses = "watchAddresses"
    }

    let keystore: Keystore
    let appTracker: AppTracker
    let keychain = KeychainSwift(keyPrefix: Constants.keychainKeyPrefix)

    // Deprecated
    private var watchAddresses: [String] {
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            return UserDefaults.standard.set(data, forKey: Keys.watchAddresses)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.watchAddresses) else { return [] }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [String] ?? []
        }
    }

    init(
        keystore: Keystore,
        appTracker: AppTracker
    ) {
        self.keystore = keystore
        self.appTracker = appTracker
    }

    func start(completion: @escaping (Bool) -> Void) {
        if !keystore.wallets.isEmpty, appTracker.completeMultiCoinMigration == false {
            appTracker.completeMultiCoinMigration = true
            runMigrate(completion: completion)
        }
        appTracker.completeMultiCoinMigration = true
    }

    // TODO: Just run this once
    @discardableResult func runMigrate(completion: @escaping (Bool) -> Void) -> Bool {
        func keychainOldKey(for account: Account) -> String {
            guard let wallet = account.wallet else {
                return account.address.description.lowercased()
            }
            switch wallet.type {
            case .encryptedKey:
                return account.address.description.lowercased()
            case .hierarchicalDeterministicWallet:
                return "hd-wallet-" + account.address.description
            }
        }
        keystore.wallets.filter { !$0.accounts.isEmpty }.forEach { wallet in
            // Each wallet needs to be converted to Ether-1 wallet
            switch wallet.type {
            case .hd, .privateKey:
                if let account = wallet.accounts.first, let password = keychain.get(keychainOldKey(for: account)), let walletI = account.wallet {
                    keystore.export(account: account, password: password, newPassword: password) { [self] exportResult in
                        switch exportResult {
                        case let .success(data):
                            let importType: ImportType = .keystore(string: data, password: password)
                            self.keystore.importWallet(type: importType, coin: .ether1) { [self] importResult in
                                _ = self.keystore.setPassword(password, for: walletI)
                                switch importResult {
                                case .success:
                                    self.keystore.delete(wallet: wallet) { deleteResult in
                                        switch deleteResult {
                                        case .success: completion(true)
                                        case .failure: completion(false)
                                        }
                                    }
                                case .failure:
                                    completion(false)
                                }
                            }
                        case .failure:
                            completion(false)
                        }
                    }
                }
            case .address:
                break
            }
        }

        // Move string addresses to WalletAddress
        let addresses = watchAddresses.compactMap {
            EthereumAddress(string: $0)
        }.compactMap {
            WalletAddress(coin: .ether1, address: $0)
        }
        keystore.storage.store(address: addresses)
        return true
    }
}
