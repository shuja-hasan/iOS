// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

struct DappCommand: Decodable {
    let name: Method
    let id: Int
    let object: [String: DappCommandObjectValue]
}

struct DappCallback {
    let id: Int
    let value: DappCallbackValue
}

enum DappCallbackValue {
    case signTransaction(Data)
    case sentTransaction(Data)
    case signMessage(Data)
    case signPersonalMessage(Data)
    case signTypedMessage(Data)

    var object: String {
        switch self {
        case let .signTransaction(data):
            return data.hexEncoded
        case let .sentTransaction(data):
            return data.hexEncoded
        case let .signMessage(data):
            return data.hexEncoded
        case let .signPersonalMessage(data):
            return data.hexEncoded
        case let .signTypedMessage(data):
            return data.hexEncoded
        }
    }
}

struct DappCommandObjectValue: Decodable {
    public var value: String = ""
    public var array: [EthTypedData] = []
    public init(from coder: Decoder) throws {
        let container = try coder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            var arrayContainer = try coder.unkeyedContainer()
            while !arrayContainer.isAtEnd {
                array.append(try arrayContainer.decode(EthTypedData.self))
            }
        }
    }
}
