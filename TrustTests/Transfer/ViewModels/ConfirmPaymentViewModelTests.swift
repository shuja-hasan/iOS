// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class ConfirmPaymentViewModelTests: XCTestCase {
    func testActionButtonTitleOnSign() {
        let viewModel = ConfirmPaymentViewModel(type: .sign)

        XCTAssertEqual("Approve", viewModel.actionButtonText)
    }

    func testActionButtonTitleOnSignAndSend() {
        let viewModel = ConfirmPaymentViewModel(type: .signThenSend)

        XCTAssertEqual("Send", viewModel.actionButtonText)
    }
}
