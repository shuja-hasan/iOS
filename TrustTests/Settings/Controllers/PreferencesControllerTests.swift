// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import XCTest

class PreferencesControllerTests: XCTestCase {
    func testDefaultValues() {
        let controller = PreferencesController(userDefaults: .test)

        XCTAssertEqual(controller.get(for: .airdropNotifications), false)
    }
}
