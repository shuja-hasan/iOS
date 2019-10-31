// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation

extension BigInt {
    var hexEncoded: String {
        return "0x" + String(self, radix: 16)
    }
}
