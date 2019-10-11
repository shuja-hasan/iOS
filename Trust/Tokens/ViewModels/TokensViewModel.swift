// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import PromiseKit
import RealmSwift
import TrustCore
import TrustKeystore
import UIKit

protocol TokensViewModelDelegate: class {
    func refresh()
}

final class TokensViewModel: NSObject {
    let config: Config

    let store: TokensDataStore
    var tokensNetwork: NetworkProtocol
    let tokens: Results<TokenObject>
    var tokensObserver: NotificationToken?
    let transactionStore: TransactionsStorage
    let session: WalletSession

    var headerBalance: String {
        return amount ?? "0.00"
    }

    var headerBalanceTextColor: UIColor {
        return Colors.black
    }

    var headerBackgroundColor: UIColor {
        return Colors.veryVeryLightGray
    }

    var headerBalanceFont: UIFont {
        return UIFont.systemFont(ofSize: 28, weight: .medium)
    }

    var title: String {
        return NSLocalizedString("wallet.navigation.title", value: "Wallet", comment: "")
    }

    var backgroundColor: UIColor {
        return .white
    }

    var footerTitle: String {
        return NSLocalizedString("tokens.footer.label.title", value: "Tokens will appear automagically. Tap + to add manually.", comment: "")
    }

    var footerTextColor: UIColor {
        return Colors.black
    }

    var footerTextFont: UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .light)
    }

    var all: [TokenViewModel] {
        return Array(tokens).map { token in
            TokenViewModel(token: token, config: config, store: store, transactionsStore: transactionStore, tokensNetwork: tokensNetwork, session: session)
        }
    }

    weak var delegate: TokensViewModelDelegate?

    init(
        session: WalletSession,
        config: Config = Config(),
        store: TokensDataStore,
        tokensNetwork: NetworkProtocol,
        transactionStore: TransactionsStorage
    ) {
        self.session = session
        self.config = config
        self.store = store
        self.tokensNetwork = tokensNetwork
        tokens = store.tokens
        self.transactionStore = transactionStore
        super.init()
    }

    func setTokenObservation(with block: @escaping (RealmCollectionChange<Results<TokenObject>>) -> Void) {
        tokensObserver = tokens.observe(block)
    }

    private var amount: String? {
        let totalAmount = tokens.lazy.map { $0.balance }.reduce(0.0, +)

        if config.currency.rawValue == "BTC" {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.minimumIntegerDigits = 1
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 8
            let res = nf.string(from: NSNumber(value: totalAmount))
            if res != nil {
                return res! + " BTC"
            }
        }
        return CurrencyFormatter.formatter.string(from: NSNumber(value: totalAmount))
    }

    func numberOfItems(for _: Int) -> Int {
        return tokens.count
    }

    func item(for path: IndexPath) -> TokenObject {
        return tokens[path.row]
    }

    func canEdit(for path: IndexPath) -> Bool {
        return tokens[path.row].isCustom
    }

    func cellViewModel(for path: IndexPath) -> TokenViewCellViewModel {
        let token = tokens[path.row]
        return TokenViewCellViewModel(
            viewModel: TokenObjectViewModel(token: token),
            ticker: store.coinTicker(by: token.address),
            store: transactionStore
        )
    }

    func updateBalances() {
        balances(for: Array(store.tokensBalance))
    }

    private func tokensInfo() {
        firstly {
            tokensNetwork.tokensList()
        }.done { [weak self] tokens in
            self?.store.update(tokens: tokens, action: .updateInfo)
        }.catch { error in
            NSLog("tokensInfo \(error)")
        }.finally { [weak self] in
            guard let strongSelf = self else { return }
            let tokens = Array(strongSelf.store.tokensBalance)
            strongSelf.prices(for: tokens)
        }
    }

    private func prices(for tokens: [TokenObject]) {
        let prices = tokens.map { TokenPrice(contract: $0.contract, symbol: $0.symbol) }
        firstly {
            tokensNetwork.tickers(with: prices)
        }.done { [weak self] tickers in
            guard let strongSelf = self else { return }
            strongSelf.store.saveTickers(tickers: tickers)
        }.catch { error in
            NSLog("prices \(error)")
        }.finally { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.balances(for: tokens)
        }
    }

    private func balances(for tokens: [TokenObject]) {
        let balances: [BalanceNetworkProvider] = tokens.compactMap {
            TokenViewModel.balance(for: $0, wallet: session.account)
        }
        let operationQueue: OperationQueue = OperationQueue()
        operationQueue.qualityOfService = .background

        let balancesOperations = Array(balances.lazy.map {
            TokenBalanceOperation(balanceProvider: $0, store: self.store)
        })

        operationQueue.operations.onFinish { [weak self] in
            DispatchQueue.main.async {
                self?.delegate?.refresh()
            }
        }

        operationQueue.addOperations(balancesOperations, waitUntilFinished: false)
    }

    func updatePendingTransactions() {
        all.forEach { $0.updatePending() }
    }

    func fetch() {
        tokensInfo()
        updatePendingTransactions()
    }

    func invalidateTokensObservation() {
        tokensObserver?.invalidate()
        tokensObserver = nil
    }
}

extension Array where Element: Operation {
    /// Execute block after all operations from the array.
    func onFinish(block: @escaping () -> Void) {
        let doneOperation = BlockOperation(block: block)
        forEach { [unowned doneOperation] in
            doneOperation.addDependency($0)
        }
        OperationQueue().addOperation(doneOperation)
    }
}
