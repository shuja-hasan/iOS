// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
@testable import Trust
import XCTest

class GasLimitConfigurationTests: XCTestCase {
    func testDefault() {
        XCTAssertEqual(BigInt(90000), GasLimitConfiguration.default)
        XCTAssertEqual(BigInt(21000), GasLimitConfiguration.min)
        XCTAssertEqual(BigInt(600_000), GasLimitConfiguration.max)
    }
}
