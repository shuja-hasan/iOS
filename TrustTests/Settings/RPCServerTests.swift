// Copyright DApps Platform Inc. All rights reserved.

@testable import Trust
import TrustCore
import XCTest

class RPCServerTests: XCTestCase {
    func testServerToCoinMapping() {
        XCTAssertEqual(RPCServer.main.coin, Coin.ethereum)
        XCTAssertEqual(RPCServer.poa.coin, Coin.poa)
        XCTAssertEqual(RPCServer.classic.coin, Coin.ethereumClassic)
        XCTAssertEqual(RPCServer.callisto.coin, Coin.callisto)
        XCTAssertEqual(RPCServer.gochain.coin, Coin.gochain)
        XCTAssertEqual(RPCServer.ether1.coin, Coin.ether1)
        XCTAssertEqual(RPCServer.xerom.coin, Coin.xerom)
    }

    func testisDisabledByDefault() {
        XCTAssertEqual(RPCServer.main.isDisabledByDefault, false)
        XCTAssertEqual(RPCServer.poa.isDisabledByDefault, true)
        XCTAssertEqual(RPCServer.classic.isDisabledByDefault, true)
        XCTAssertEqual(RPCServer.callisto.isDisabledByDefault, true)
        XCTAssertEqual(RPCServer.gochain.isDisabledByDefault, true)
        XCTAssertEqual(RPCServer.ether1.isDisabledByDefault, true)
        XCTAssertEqual(RPCServer.xerom.isDisabledByDefault, true)
    }
}
