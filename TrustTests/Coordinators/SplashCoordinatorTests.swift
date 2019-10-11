// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class SplashCoordinatorTests: XCTestCase {
    func testStart() {
        let window = UIWindow()
        let coordinator = SplashCoordinator(window: window)
        coordinator.start()
        XCTAssertFalse(window.isHidden)
    }

    func testStop() {
        let window = UIWindow()
        let coordinator = SplashCoordinator(window: window)
        coordinator.start()
        coordinator.stop()
        XCTAssertTrue(window.isHidden)
    }
}
