// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import TrustCore

struct Config {
    private struct Keys {
        static let currencyID = "currencyID"
    }

    static let dbMigrationSchemaVersion: UInt64 = 77

    static let current: Config = Config()

    let defaults: UserDefaults

    init(
        defaults: UserDefaults = UserDefaults.standard
    ) {
        self.defaults = defaults
    }

    var currency: Currency {
        get {
            // If it is saved currency
            if let currency = defaults.string(forKey: Keys.currencyID) {
                return Currency(rawValue: currency)!
            }
            // If ther is not saved currency try to use user local currency if it is supported.
            let avaliableCurrency = Currency.allValues.first { currency in
                currency.rawValue == Locale.current.currencySymbol
            }
            if let isAvaliableCurrency = avaliableCurrency {
                return isAvaliableCurrency
            }
            // If non of the previous is not working return USD.
            return Currency.USD
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.currencyID) }
    }

    var servers: [Coin] {
        return [
            Coin.ether1,
            //            Coin.xerom,
            Coin.ethereum,
            Coin.ethereumClassic,
            Coin.poa,
            Coin.callisto,
            Coin.gochain,
        ]
    }
}
