// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class EnterPasswordCoordinatorTests: XCTestCase {
    func testStart() {
        let coordinator = EnterPasswordCoordinator(account: .make())

        coordinator.start()

        XCTAssertTrue(coordinator.navigationController.viewControllers[0] is EnterPasswordViewController)
    }
}
