// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import XCTest

class TokenObjectViewModelTest: XCTestCase {
    func testTitle() {
        let viewModel = TokenObjectViewModel(token: .make(name: "Viktor", symbol: "VIK"))

        XCTAssertEqual("Viktor (VIK)", viewModel.title)
    }
}
