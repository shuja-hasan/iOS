// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import XCTest

class LockCreatePasscodeCoordinatorTest: XCTestCase {
    func testStart() {
        let navigationController = NavigationController()
        let coordinator = LockCreatePasscodeCoordinator(navigationController: navigationController, model: LockCreatePasscodeViewModel())
        coordinator.start()
        XCTAssertTrue(navigationController.viewControllers.first is LockCreatePasscodeViewController)
    }

    func testStop() {
        let navigationController = NavigationController()
        let coordinator = LockCreatePasscodeCoordinator(navigationController: navigationController, model: LockCreatePasscodeViewModel())
        coordinator.start()
        XCTAssertTrue(navigationController.viewControllers.first is LockCreatePasscodeViewController)
        XCTAssertNil(navigationController.presentedViewController)
    }
}
