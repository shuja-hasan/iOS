// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import XCTest

class WelcomeViewModelTests: XCTestCase {
    func testTitle() {
        let viewModel = WelcomeViewModel()

        XCTAssertEqual("Welcome", viewModel.title)
    }
}
