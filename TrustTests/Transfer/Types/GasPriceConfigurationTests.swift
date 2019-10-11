// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
@testable import Trust
import XCTest

class GasPriceConfigurationTests: XCTestCase {
    func testDefault() {
        XCTAssertEqual(BigInt(24_000_000_000), GasPriceConfiguration.default)
        XCTAssertEqual(BigInt(1_000_000_000), GasPriceConfiguration.min)
        XCTAssertEqual(BigInt(100_000_000_000), GasPriceConfiguration.max)
    }
}
