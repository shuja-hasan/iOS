// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
@testable import Trust
import TrustCore

extension UnconfirmedTransaction {
    static func make(
        transfer: Transfer = Transfer(server: .make(), type: .ether(.make(), destination: .none)),
        value: BigInt = BigInt(1),
        to: EthereumAddress = .make(),
        data: Data = Data(),
        gasLimit: BigInt? = BigInt(100_000),
        gasPrice: BigInt? = BigInt(1000),
        nonce: BigInt? = BigInt(1)
    ) -> UnconfirmedTransaction {
        return UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: to,
            data: data,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            nonce: nonce
        )
    }

    static func makeToken(
        transfer: Transfer = Transfer(server: .make(), type: .token(TokenObject(contract: "0xe41d2489571d322189246dafa5ebde1f4699f498", name: "0x project", coin: .ethereum, type: .ERC20, symbol: "ZRX", decimals: 6, value: "30000000", isCustom: true, isDisabled: false))),
        value: BigInt = BigInt(6),
        to: EthereumAddress = .make(),
        data: Data = Data(),
        gasLimit: BigInt? = BigInt(100_000),
        gasPrice: BigInt? = BigInt(1000),
        nonce: BigInt? = BigInt(1)
    ) -> UnconfirmedTransaction {
        return UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: to,
            data: data,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            nonce: nonce
        )
    }

    static func makeNotEnoughtToken(
        transfer: Transfer = Transfer(server: .make(), type: .token(TokenObject(contract: "0xe41d2489571d322189246dafa5ebde1f4699f498", name: "0x project", coin: .ethereum, type: .ERC20, symbol: "ZRX", decimals: 6, value: "30000000", isCustom: true, isDisabled: false))),
        value: BigInt = BigInt(9_000_000_000_000),
        to: EthereumAddress = .make(),
        data: Data = Data(),
        gasLimit: BigInt? = BigInt(100_000),
        gasPrice: BigInt? = BigInt(1000),
        nonce: BigInt? = BigInt(1)
    ) -> UnconfirmedTransaction {
        return UnconfirmedTransaction(
            transfer: transfer,
            value: value,
            to: to,
            data: data,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            nonce: nonce
        )
    }
}
