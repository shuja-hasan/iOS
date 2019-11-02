// Copyright DApps Platform Inc. All rights reserved.

import APIKit
import BigInt
import JSONRPCKit
import Moya
import PromiseKit
import Result
import TrustCore
import TrustKeystore

import enum Result.Result

enum TrustNetworkProtocolError: LocalizedError {
    case missingContractInfo
}

protocol NetworkProtocol: TrustNetworkProtocol {
    func collectibles() -> Promise<[CollectibleTokenCategory]>
    func tickers(with tokenPrices: [TokenPrice]) -> Promise<[CoinTicker]>

    func tokensList() -> Promise<[TokenObject]>
    func transactions(for address: Address, on server: RPCServer, startBlock: Int, page: Int, contract: String?, completion: @escaping (_ result: ([Transaction]?, Bool)) -> Void)
    func search(query: String) -> Promise<[TokenObject]>
    func search(query: String, tokens: Set<TokenObject>) -> Promise<[TokenObject]>
}

final class TrustNetwork: NetworkProtocol {
    static let deleteMissingInternalSeconds: Double = 60.0
    static let deleyedTransactionInternalSeconds: Double = 60.0
    let provider: MoyaProvider<TrustAPI>
    let wallet: WalletInfo

    private var dict: [String: [String]] {
        return TrustRequestFormatter.toAddresses(from: wallet.accounts)
    }

    private var networks: [Int] {
        return TrustRequestFormatter.networks(from: wallet.accounts)
    }

    init(
        provider: MoyaProvider<TrustAPI>,
        wallet: WalletInfo
    ) {
        self.provider = provider
        self.wallet = wallet
    }

    private func getTickerFrom(_ rawTicker: CoinTicker) -> CoinTicker? {
        guard let contract = EthereumAddress(string: rawTicker.contract) else { return .none }
        return CoinTicker(
            price: rawTicker.price,
            percent_change_24h: rawTicker.percent_change_24h,
            contract: contract,
            tickersKey: CoinTickerKeyMaker.makeCurrencyKey()
        )
    }

    func tokensList() -> Promise<[TokenObject]> {
        return Promise { seal in
            provider.request(.getTokens(dict)) { result in
                switch result {
                case let .success(response):
                    do {
                        let items = try response.map(ArrayResponse<TokenObjectList>.self).docs
                        let tokens = items.map { $0.contract }
                        seal.fulfill(tokens)
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }

    func tickers(with tokenPrices: [TokenPrice]) -> Promise<[CoinTicker]> {
        return Promise { seal in
            let tokensPriceToFetch = TokensPrice(
                currency: Config.current.currency.rawValue,
                tokens: tokenPrices
            )
            provider.request(.prices(tokensPriceToFetch)) { result in
                switch result {
                case let .success(response):
                    do {
                        let rawTickers = try response.map(ArrayResponse<CoinTicker>.self).docs
                        let tickers = rawTickers.compactMap { self.getTickerFrom($0) }
                        seal.fulfill(tickers)
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }

    func collectibles() -> Promise<[CollectibleTokenCategory]> {
        return Promise { seal in
            provider.request(.collectibles(dict)) { result in
                switch result {
                case let .success(response):
                    do {
                        let tokens = try response.map(ArrayResponse<CollectibleTokenCategory>.self).docs
                        seal.fulfill(tokens)
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }

    func transactions(for address: Address, on server: RPCServer, startBlock: Int, page: Int, contract: String?, completion: @escaping (([Transaction]?, Bool)) -> Void) {
        provider.request(.getTransactions(server: server, address: address.description, startBlock: startBlock, page: page, contract: contract)) { result in
            switch result {
            case let .success(response):
                do {
                    let transactions = try response.map(ArrayResponse<Transaction>.self).docs
                    completion((transactions, true))
                } catch {
                    completion((nil, false))
                }
            case .failure:
                completion((nil, false))
            }
        }
    }

    func search(query: String) -> Promise<[TokenObject]> {
        return search(query: query, tokens: Set<TokenObject>())
    }

    func search(query: String, tokens: Set<TokenObject>) -> Promise<[TokenObject]> {
        let localNetworks = networks.filter { net_id in
            tokens.contains { element in
                if element.order == net_id {
                    return true
                } else {
                    return false
                }
            }
        }
        return Promise { seal in
            provider.request(.search(query: query, networks: localNetworks)) { result in
                switch result {
                case let .success(response):
                    do {
                        let tokens = try response.map(ArrayResponse<TokenObject>.self).docs
                        seal.fulfill(tokens)
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
}
