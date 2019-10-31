// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import XCTest

class ExportPrivateKeyCoordinatorTests: XCTestCase {
    func testInit() {
        let coordinator = ExportPrivateKeyCoordinator(
            privateKey: Data()
        )

        XCTAssertTrue(coordinator.rootViewController is ExportPrivateKeyViewConroller)
    }
}
