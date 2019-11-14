// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import XCTest

class BackupCoordinatorTests: XCTestCase {
    func testStart() {
        let coordinator = BackupCoordinator(
            navigationController: FakeNavigationController(),
            keystore: FakeKeystore(),
            account: .make()
        )
        coordinator.start()

        XCTAssertTrue((coordinator.navigationController.presentedViewController as? NavigationController)?.viewControllers[0] is EnterPasswordViewController)
    }
}
