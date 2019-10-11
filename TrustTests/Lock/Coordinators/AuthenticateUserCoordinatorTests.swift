// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class AuthenticateUserCoordinatorTests: XCTestCase {
    func testStart() {
        let coordinator = AuthenticateUserCoordinator(navigationController: FakeNavigationController())

        coordinator.start()

        // XCTAssertTrue(coordinator.navigationController.presentedViewController is LockEnterPasscodeViewController)
    }
}
