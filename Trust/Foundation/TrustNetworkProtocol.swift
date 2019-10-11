// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Moya
import TrustCore

protocol TrustNetworkProtocol {
    var provider: MoyaProvider<TrustAPI> { get }
}
