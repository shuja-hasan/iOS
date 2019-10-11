// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
import UIKit

struct TokensLayout {
    struct tableView {
        static let height: CGFloat = 80
        static let layoutInsets = UIEdgeInsets(top: 0, left: 84, bottom: 0, right: 0)
    }

    struct cell {
        static let stackVericalOffset: CGFloat = 10
        static let arrangedSubviewsOffset: CGFloat = 4
        static var imageSize: CGFloat {
            return 52
            // TODO: return 44 for 2 scale, same for xib file.
            // if UIScreen.main.scale == 3 { return 54 }
            // return 44
        }

        static let amountTextColor = Colors.black
        static let currencyAmountTextColor = Colors.lightGray
        static let fiatAmountTextColor = Colors.gray

        static func percentChangeColor(for ticker: CoinTicker?) -> UIColor {
            guard let ticker = ticker else { return Colors.lightGray }
            return ticker.percent_change_24h.starts(with: "-") ? Colors.red : Colors.green
        }

        static func percentChange(for ticker: CoinTicker?) -> String? {
            guard let ticker = ticker, let price = Double(ticker.price), price > 0 else { return nil }
            let percent_change_24h = ticker.percent_change_24h
            guard !percent_change_24h.isEmpty else { return nil }
            return "" + percent_change_24h + "%"
        }

        static func totalFiatAmount(token: TokenObject, ticker: CoinTicker?) -> String? {
            guard let ticker = ticker, let price = Double(ticker.price), price > 0 else { return nil }
            let amount = token.balance
            guard amount > 0 else { return nil }
            if ticker.tickersKey == "tickers-BTC" {
                let nf = NumberFormatter()
                nf.numberStyle = .decimal
                nf.minimumIntegerDigits = 1
                nf.minimumFractionDigits = 8
                nf.maximumFractionDigits = 8
                let res = nf.string(from: NSNumber(value: price))
                if res != nil {
                    return res! + " BTC"
                }
            }
            return CurrencyFormatter.formatter.string(from: NSNumber(value: amount))
        }

        static func marketPrice(for ticker: CoinTicker?) -> String? {
            guard let ticker = ticker, let price = Double(ticker.price), price > 0 else { return nil }
            if ticker.tickersKey == "tickers-BTC" {
                let nf = NumberFormatter()
                nf.numberStyle = .decimal
                nf.minimumIntegerDigits = 1
                nf.minimumFractionDigits = 0
                nf.maximumFractionDigits = 0
                let res = nf.string(from: NSNumber(value: price * 100_000_000))
                if res != nil {
                    return res! + " sats"
                }
            }
            return CurrencyFormatter.formatter.string(from: NSNumber(value: price))
        }
    }
}
