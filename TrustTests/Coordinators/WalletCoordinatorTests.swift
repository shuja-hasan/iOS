// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import TrustCore
import XCTest

class WalletCoordinatorTests: XCTestCase {
    func testWelcome() {
        let coordinator = WalletCoordinator(
            navigationController: FakeNavigationController(),
            keystore: FakeKeystore()
        )

        coordinator.start(.welcome)

        XCTAssertTrue(coordinator.navigationController.viewControllers[0] is WelcomeViewController)
    }

    func testImportWallet() {
        let coordinator = WalletCoordinator(
            navigationController: FakeNavigationController(),
            keystore: FakeKeystore()
        )

        coordinator.start(.importWallet)

        XCTAssertTrue(coordinator.navigationController.viewControllers[0] is ImportMainWalletViewController)
    }

    // TODO: Add test to import wallet once main. Should open ImportWalletViewController

    func testCreateInstantWallet() {
        let delegate = FakeWalletCoordinatorDelegate()
        let coordinator = WalletCoordinator(
            navigationController: FakeNavigationController(),
            keystore: FakeEtherKeystore()
        )
        coordinator.delegate = delegate

        coordinator.pushBackup(for: .make(), words: [])

        XCTAssertTrue(coordinator.navigationController.viewControllers.last is PassphraseViewController)
    }

    func testPushImportWallet() {
        let walletObject = WalletObject()
        walletObject.mainWallet = true

        let wallet = WalletInfo.make(type: .privateKey(.make()), info: walletObject)
        let coordinator = WalletCoordinator(
            navigationController: FakeNavigationController(),
            keystore: FakeKeystore(wallets: [wallet])
        )

        coordinator.start(.welcome)

        coordinator.pushImportWallet()

        XCTAssertTrue(coordinator.navigationController.viewControllers[1] is SelectCoinViewController)
    }

    // TODO: Test use case
}

class FakeWalletCoordinatorDelegate: WalletCoordinatorDelegate {
    var didFail: Error? = .none
    var didFinishAccount: Trust.WalletInfo? = .none
    var didCancel: Bool = false

    func didCancel(in _: WalletCoordinator) {
        didCancel = true
    }

    func didFinish(with account: Trust.WalletInfo, in _: WalletCoordinator) {
        didFinishAccount = account
    }

    func didFail(with error: Error, in _: WalletCoordinator) {
        didFail = error
    }
}
