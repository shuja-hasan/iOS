// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
@testable import Trust
import TrustCore
import XCTest

class GetNonceProviderTests: XCTestCase {
    func testDefault() {
        let provider = GetNonceProvider(storage: FakeTransactionsStorage(), server: .make(), address: EthereumAddress.make())

        XCTAssertNil(provider.latestNonce)
        XCTAssertNil(provider.nextNonce)
    }

    func testExistOneTransaction() {
        let storage = FakeTransactionsStorage()
        storage.add([.make(nonce: 0)])
        let provider = GetNonceProvider(
            storage: storage,
            server: .make(),
            address: EthereumAddress.make()
        )

        XCTAssertEqual(BigInt(0), provider.latestNonce)
        XCTAssertEqual(BigInt(1), provider.nextNonce)
    }

    func testTransactionsSplitByCoins() {
        let storage = FakeTransactionsStorage()
        storage.add([
            .make(nonce: 0, coin: .poa),
        ])
        let provider = GetNonceProvider(
            storage: storage,
            server: .make(),
            address: EthereumAddress.make()
        )

        XCTAssertNil(provider.latestNonce)
        XCTAssertNil(provider.nextNonce)
    }

    func testExistMultipleTransactions() {
        let storage = FakeTransactionsStorage()
        storage.add([.make(nonce: 5), .make(nonce: 6)])
        let provider = GetNonceProvider(
            storage: storage,
            server: .make(),
            address: EthereumAddress.make()
        )

        XCTAssertEqual(BigInt(6), provider.latestNonce)
        XCTAssertEqual(BigInt(7), provider.nextNonce)
    }

    func testChangingNonceWhenNewTransactionIsAdded() {
        let storage = FakeTransactionsStorage()
        storage.add([.make(nonce: 5)])
        let provider = GetNonceProvider(
            storage: storage,
            server: .make(),
            address: EthereumAddress.make()
        )

        XCTAssertEqual(BigInt(5), provider.latestNonce)
        XCTAssertEqual(BigInt(6), provider.nextNonce)

        storage.add([.make(nonce: 6)])

        XCTAssertEqual(BigInt(6), provider.latestNonce)
        XCTAssertEqual(BigInt(7), provider.nextNonce)
    }

    func testChangingNonceWhenNewPendingTransactionIsAdded() {
        let storage = FakeTransactionsStorage()
        storage.add([.make(nonce: 5)])
        let provider = GetNonceProvider(
            storage: storage,
            server: .make(),
            address: EthereumAddress.make()
        )

        XCTAssertEqual(BigInt(5), provider.latestNonce)
        XCTAssertEqual(BigInt(6), provider.nextNonce)

        storage.add([.make(nonce: 6, state: .pending)])

        XCTAssertEqual(BigInt(6), provider.latestNonce)
        XCTAssertEqual(BigInt(7), provider.nextNonce)
    }
}
