// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class LockEnterPasscodeCoordinatorTest: XCTestCase {
    func testStart() {
        let viewModel = LockEnterPasscodeViewModel()
        let fakeLock = FakeLockProtocol()
        let coordinator = LockEnterPasscodeCoordinator(model: viewModel, lock: fakeLock)
        XCTAssertTrue(coordinator.window.isHidden)
        coordinator.start()
        XCTAssertFalse(coordinator.window.isHidden)
    }

    func testStop() {
        let viewModel = LockEnterPasscodeViewModel()
        let fakeLock = FakeLockProtocol()
        let coordinator = LockEnterPasscodeCoordinator(model: viewModel, lock: fakeLock)
        coordinator.start()
        XCTAssertFalse(coordinator.window.isHidden)
        coordinator.stop()
        XCTAssertTrue(coordinator.window.isHidden)
    }

    func testDisabledLock() {
        let viewModel = LockEnterPasscodeViewModel()
        let fakeLock = FakeLockProtocol()
        fakeLock.passcodeSet = false
        let coordinator = LockEnterPasscodeCoordinator(model: viewModel, lock: fakeLock)
        XCTAssertTrue(coordinator.window.isHidden)
        coordinator.start()
        XCTAssertTrue(coordinator.window.isHidden)
    }

    func testDisabledAutoLock() {
        let viewModel = LockEnterPasscodeViewModel()
        let fakeLock = FakeLockProtocol()
        fakeLock.passcodeSet = true
        fakeLock.showProtection = false
        let coordinator = LockEnterPasscodeCoordinator(model: viewModel, lock: fakeLock)
        XCTAssertTrue(coordinator.window.isHidden)
        coordinator.start()
        XCTAssertTrue(coordinator.window.isHidden)
    }
}
