// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

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
