// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class WelcomeViewModelTests: XCTestCase {
    func testTitle() {
        let viewModel = WelcomeViewModel()

        XCTAssertEqual("Welcome", viewModel.title)
    }
}
