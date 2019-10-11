// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import XCTest

class GasViewModelTest: XCTestCase {
    let viewModel = GasViewModel.make()

    func testEtherFee() {
        let expectedResult = "\(viewModel.formatter.string(from: viewModel.fee)) \(viewModel.server.symbol)"
        let result = viewModel.etherFee
        XCTAssertEqual(expectedResult, result)
    }
}
