// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import Result
@testable import Trust
import TrustCore
import TrustKeystore

struct FakeKeystore: Keystore {
    var mainWallet: WalletInfo? {
        return wallets.filter { $0.mainWallet }.first
    }

    var storage: WalletStorage {
        return WalletStorage(realm: .make())
    }

    func createAccount(with _: String, completion _: @escaping (Result<Wallet, KeystoreError>) -> Void) {
        //
    }

    func importWallet(type _: ImportType, coin _: Coin, completion _: @escaping (Result<WalletInfo, KeystoreError>) -> Void) {
        //
    }

    func importKeystore(value _: String, password _: String, newPassword _: String, coin _: Coin, completion _: @escaping (Result<WalletInfo, KeystoreError>) -> Void) {
        //
    }

    func createAccout(password _: String) -> Wallet {
        return .make()
    }

    func importKeystore(value _: String, password _: String, newPassword _: String, coin _: Coin) -> Result<WalletInfo, KeystoreError> {
        return .failure(KeystoreError.accountNotFound)
    }

    func importPrivateKey(privateKey _: PrivateKey, password _: String, coin _: Coin) -> Result<WalletInfo, KeystoreError> {
        return .failure(KeystoreError.accountNotFound)
    }

    func exportMnemonic(wallet _: Wallet, completion _: @escaping (Result<[String], KeystoreError>) -> Void) {
        //
    }

    func delete(wallet _: Wallet) -> Result<Void, KeystoreError> {
        return .failure(KeystoreError.accountNotFound)
    }

    func delete(wallet _: WalletInfo, completion _: @escaping (Result<Void, KeystoreError>) -> Void) {
        ///
    }

    func getPassword(for _: Wallet) -> String? {
        return "test"
    }

    func setPassword(_: String, for _: Wallet) -> Bool {
        return true
    }

    func addAccount(to _: Wallet, derivationPaths _: [DerivationPath]) -> Result<Void, KeystoreError> {
        return .failure(KeystoreError.accountNotFound)
    }

    func update(wallet _: Wallet) -> Result<Void, KeystoreError> {
        return .failure(KeystoreError.accountNotFound)
    }

    var hasWallets: Bool {
        return wallets.count > 0
    }

    var keysDirectory: URL {
        return URL(fileURLWithPath: "file://")
    }

    var walletsDirectory: URL {
        return URL(fileURLWithPath: "file://")
    }

    var wallets: [Trust.WalletInfo]
    var recentlyUsedWallet: Trust.WalletInfo?

    init(
        wallets: [Trust.WalletInfo] = [],
        recentlyUsedWallet: Trust.WalletInfo? = .none
    ) {
        self.wallets = wallets
        self.recentlyUsedWallet = recentlyUsedWallet
    }

    func createAccount(with _: String, completion: @escaping (Result<Account, KeystoreError>) -> Void) {
        completion(.success(.make()))
    }

    func keystore(for _: String, password _: String, completion _: @escaping (Result<String, KeystoreError>) -> Void) {
        // TODO: Implement
    }

    func importKeystore(value _: String, password _: String, newPassword _: String, completion _: @escaping (Result<Account, KeystoreError>) -> Void) {
        // TODO: Implement
    }

    func createAccout(password _: String) -> Account {
        // TODO: Implement
        return .make(address: .make())
    }

    func importKeystore(value _: String, password _: String, newPassword _: String) -> Result<Account, KeystoreError> {
        // TODO: Implement
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func export(account _: Account, password _: String, newPassword _: String) -> Result<String, KeystoreError> {
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func export(account _: Account, password _: String, newPassword _: String, completion: @escaping (Result<String, KeystoreError>) -> Void) {
        // TODO: Implement
        return completion(.failure(KeystoreError.failedToSignTransaction))
    }

    func exportData(account _: Account, password _: String, newPassword _: String) -> Result<Data, KeystoreError> {
        // TODO: Implement
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func exportMnemonic(account _: Account, completion: @escaping (Result<[String], KeystoreError>) -> Void) {
        // TODO: Implement
        return completion(.success([]))
    }

    func updateAccount(account _: Account, password _: String, newPassword _: String) -> Result<Void, KeystoreError> {
        // TODO: Implement
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func signPersonalMessage(_: Data, for _: Account) -> Result<Data, KeystoreError> {
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func signMessage(_: Data, for _: Account) -> Result<Data, KeystoreError> {
        return .failure(KeystoreError.failedToSignMessage)
    }

    func signTypedMessage(_: [EthTypedData], for _: Account) -> Result<Data, KeystoreError> {
        return .failure(KeystoreError.failedToSignTypedMessage)
    }

    func signHash(_: Data, for _: Account) -> Result<Data, KeystoreError> {
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func signTransaction(_: SignTransaction) -> Result<Data, KeystoreError> {
        // TODO: Implement
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func getPassword(for _: Account) -> String? {
        // TODO: Implement
        return .none
    }

    func convertPrivateKeyToKeystoreFile(privateKey _: String, passphrase _: String) -> Result<[String: Any], KeystoreError> {
        // TODO: Implement
        return .failure(KeystoreError.failedToSignTransaction)
    }

    func exportPrivateKey(account _: Account, completion: @escaping (Result<Data, KeystoreError>) -> Void) {
        // TODO: Implement
        return completion(.failure(KeystoreError.failedToExportPrivateKey))
    }

    func store(object _: WalletObject, fields _: [WalletInfoField]) {
        // TODO:
    }
}

extension FakeKeystore {
    static func make(
        wallets: [Trust.WalletInfo] = [],
        recentlyUsedWallet: Trust.WalletInfo? = .none
    ) -> FakeKeystore {
        return FakeKeystore(
            wallets: wallets,
            recentlyUsedWallet: recentlyUsedWallet
        )
    }
}
