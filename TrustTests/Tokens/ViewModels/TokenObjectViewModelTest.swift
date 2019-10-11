// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class TokenObjectViewModelTest: XCTestCase {
    func testTitle() {
        let viewModel = TokenObjectViewModel(token: .make(name: "Viktor", symbol: "VIK"))

        XCTAssertEqual("Viktor (VIK)", viewModel.title)
    }
}
