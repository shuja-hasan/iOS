// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
@testable import Trust
import TrustCore
import TrustKeystore

extension PreviewTransaction {
    static func make(
        account: Account = .make(),
        address _: Address = EthereumAddress.zero
    ) -> PreviewTransaction {
        return PreviewTransaction(
            value: BigInt(),
            account: account,
            address: EthereumAddress.zero,
            contract: EthereumAddress.zero,
            nonce: BigInt(),
            data: Data(),
            gasPrice: BigInt(),
            gasLimit: BigInt(),
            transfer: Transfer(server: .make(), type: .token(.make()))
        )
    }
}
