// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class InitialWalletCreationCoordinatorTests: XCTestCase {
    func testImportWallet() {
        let coordinator = InitialWalletCreationCoordinator(
            navigationController: FakeNavigationController(),
            keystore: FakeKeystore(),
            entryPoint: .importWallet
        )

        coordinator.start()

        XCTAssertTrue((coordinator.navigationController.presentedViewController as? NavigationController)?.viewControllers[0] is ImportMainWalletViewController)
    }

    // TODO. Create unit test when you have already main wallet imported
}
