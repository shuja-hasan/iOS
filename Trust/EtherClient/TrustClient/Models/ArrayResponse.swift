// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

struct ArrayResponse<T: Decodable>: Decodable {
    let docs: [T]
}
