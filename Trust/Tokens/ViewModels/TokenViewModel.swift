// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import RealmSwift
import TrustCore
import TrustKeystore

final class TokenViewModel {
    private let shortFormatter = EtherNumberFormatter.short
    private let config: Config
    private let store: TokensDataStore
    private let session: WalletSession
    private var tokensNetwork: NetworkProtocol
    private let transactionsStore: TransactionsStorage
    private var tokenTransactions: Results<Transaction>?
    private var tokenTransactionSections: [TransactionSection] = []
    private var tokenTransactionSendSections: [TransactionSection] = []
    private var tokenTransactionRecievedSections: [TransactionSection] = []
    private var notificationToken: NotificationToken?
    private var transactionToken: NotificationToken?

    let token: TokenObject
    private lazy var tokenObjectViewModel: TokenObjectViewModel = {
        TokenObjectViewModel(token: token)
    }()

    var title: String {
        return tokenObjectViewModel.title
    }

    var imageURL: URL? {
        return tokenObjectViewModel.imageURL
    }

    var imagePlaceholder: UIImage? {
        return tokenObjectViewModel.placeholder
    }

    private var symbol: String {
        return token.symbol
    }

    var amountFont: UIFont {
        return UIFont(name: "Trenda-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
    }

    let titleFormmater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter
    }()

    let backgroundColor: UIColor = {
        .white
    }()

    lazy var transactionsProvider: EthereumTransactionsProvider = {
        EthereumTransactionsProvider(server: server)
    }()

    var amount: String {
        return String(
            format: "%@ %@",
            shortFormatter.string(from: BigInt(token.value) ?? BigInt(), decimals: token.decimals),
            symbol
        )
    }

    var server: RPCServer {
        return TokensDataStore.getServer(for: token)
    }

    lazy var currentAccount: Account = {
        session.account.accounts.filter { $0.coin == token.coin }.first!
    }()

    init(
        token: TokenObject,
        config: Config = Config(),
        store: TokensDataStore,
        transactionsStore: TransactionsStorage,
        tokensNetwork: NetworkProtocol,
        session: WalletSession
    ) {
        self.token = token
        self.transactionsStore = transactionsStore
        self.config = config
        self.store = store
        self.tokensNetwork = tokensNetwork
        self.session = session
        prepareDataSource(for: token)
    }

    var ticker: CoinTicker? {
        return store.coinTicker(by: token.address)
    }

    var allTransactions: [Transaction] {
        return Array(tokenTransactions!)
    }

    var pendingTransactions: [Transaction] {
        return Array(tokenTransactions!.filter { $0.state == TransactionState.pending })
    }

    // Market Price

    var marketPrice: String? {
        return TokensLayout.cell.marketPrice(for: ticker)
    }

    var marketPriceFont: UIFont {
        return UIFont(name: "Trenda-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    var marketPriceTextColor: UIColor {
        return TokensLayout.cell.fiatAmountTextColor
    }

    var totalFiatAmount: String? {
        guard let value = TokensLayout.cell.totalFiatAmount(token: token, ticker: ticker) else { return .none }
        return " (" + value + ")"
    }

    var fiatAmountTextColor: UIColor {
        return TokensLayout.cell.fiatAmountTextColor
    }

    var fiatAmountFont: UIFont {
        return UIFont(name: "Trenda-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    var amountTextColor: UIColor {
        return TokensLayout.cell.amountTextColor
    }

    var currencyAmountTextColor: UIColor {
        return TokensLayout.cell.currencyAmountTextColor
    }

    var percentChangeColor: UIColor {
        return TokensLayout.cell.percentChangeColor(for: ticker)
    }

    var percentChangeFont: UIFont {
        return UIFont(name: "Trenda-Light", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .light)
    }

    var percentChange: String? {
        return TokensLayout.cell.percentChange(for: ticker)
    }

    var currencyAmountFont: UIFont {
        return UIFont(name: "Trenda-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    func fetch() {
        updateTokenBalance()
        fetchTransactions()
        updatePending()
    }

    func tokenObservation(with completion: @escaping (() -> Void)) {
        notificationToken = token.observe { change in
            switch change {
            case .change, .deleted, .error:
                completion()
            }
        }
    }

    func transactionObservation(with completion: @escaping (() -> Void)) {
        transactionToken = tokenTransactions?.observe { [weak self] _ in
            self?.updateSections()
            completion()
        }
    }

    func numberOfSections(type: TokenViewType) -> Int {
        switch type {
        case .All:
            return tokenTransactionSections.count
        case .Send:
            return tokenTransactionSendSections.count
        case .Recieve:
            return tokenTransactionRecievedSections.count
        }
    }

    func numberOfItems(for section: Int, type: TokenViewType) -> Int {
        switch type {
        case .All:
            return tokenTransactionSections[section].items.count
        case .Send:
            return tokenTransactionSendSections[section].items.count
        case .Recieve:
            return tokenTransactionRecievedSections[section].items.count
        }
    }

    func item(for row: Int, section: Int, type: TokenViewType) -> Transaction {
        switch type {
        case .All:
            return tokenTransactionSections[section].items[row]
        case .Send:
            return tokenTransactionSendSections[section].items[row]
        case .Recieve:
            return tokenTransactionRecievedSections[section].items[row]
        }
    }

    func convert(from title: String) -> Date? {
        return titleFormmater.date(from: title)
    }

    func titleForHeader(in section: Int, type: TokenViewType) -> String {
        var stringDate = tokenTransactionSections[section].title
        switch type {
        case .All:
            stringDate = tokenTransactionSections[section].title
        case .Send:
            stringDate = tokenTransactionSendSections[section].title
        case .Recieve:
            stringDate = tokenTransactionRecievedSections[section].title
        }
        guard let date = convert(from: stringDate) else {
            return stringDate
        }

        if NSCalendar.current.isDateInToday(date) {
            return R.string.localizable.today()
        }
        if NSCalendar.current.isDateInYesterday(date) {
            return R.string.localizable.yesterday()
        }
        return stringDate
    }

    func cellViewModel(for indexPath: IndexPath, type: TokenViewType) -> TransactionCellViewModel {
        switch type {
        case .All:
            return TransactionCellViewModel(
                transaction: tokenTransactionSections[indexPath.section].items[indexPath.row],
                config: config,
                chainState: ChainState(server: server),
                currentAccount: currentAccount,
                server: token.coin.server,
                token: token
            )
        case .Send:
            return TransactionCellViewModel(
                transaction: tokenTransactionSendSections[indexPath.section].items[indexPath.row],
                config: config,
                chainState: ChainState(server: server),
                currentAccount: currentAccount,
                server: token.coin.server,
                token: token
            )
        case .Recieve:
            return TransactionCellViewModel(
                transaction: tokenTransactionRecievedSections[indexPath.section].items[indexPath.row],
                config: config,
                chainState: ChainState(server: server),
                currentAccount: currentAccount,
                server: token.coin.server,
                token: token
            )
        }
    }

    func hasContent() -> Bool {
        return !tokenTransactionSections.isEmpty
    }

    private func updateTokenBalance() {
        guard let provider = TokenViewModel.balance(for: token, wallet: session.account) else {
            return
        }
        _ = provider.balance().done { [weak self] balance in
            self?.store.update(balance: balance, for: provider.addressUpdate)
        }
    }

    static func balance(for token: TokenObject, wallet: WalletInfo) -> BalanceNetworkProvider? {
        let first = wallet.accounts.filter { $0.coin == token.coin }.first
        guard let account = first else { return .none }
        let networkBalance: BalanceNetworkProvider? = {
            switch token.type {
            case .coin:
                return CoinNetworkProvider(
                    server: token.coin.server,
                    address: EthereumAddress(string: account.address.description)!,
                    addressUpdate: token.address
                )
            case .ERC20:
                return TokenNetworkProvider(
                    server: token.coin.server,
                    address: EthereumAddress(string: account.address.description)!,
                    contract: token.address,
                    addressUpdate: token.address
                )
            }
        }()
        return networkBalance
    }

    func updatePending() {
        let transactions = pendingTransactions

        for transaction in transactions {
            transactionsProvider.update(for: transaction) { result in
                switch result {
                case let .success(transaction, state):
                    self.transactionsStore.update(state: state, for: transaction)
                case .failure: break
                }
            }
        }
    }

    private func fetchTransactions() {
        let contract: String? = {
            switch token.type {
            case .coin: return .none
            case .ERC20: return token.contract
            }
        }()
        tokensNetwork.transactions(for: currentAccount.address, on: server, startBlock: 1, page: 0, contract: contract) { result in
            guard let transactions = result.0 else { return }
            self.transactionsStore.add(transactions)
        }
    }

    private func prepareDataSource(for token: TokenObject) {
        switch token.type {
        case .coin:
            tokenTransactions = transactionsStore.realm.objects(Transaction.self)
                .filter(NSPredicate(format: "rawCoin = %d", server.coin.rawValue))
                .sorted(byKeyPath: "date", ascending: false)
        case .ERC20:
            tokenTransactions = transactionsStore.realm.objects(Transaction.self)
                .filter(NSPredicate(format: "rawCoin = %d && %K ==[cd] %@", server.coin.rawValue, "to", token.contract))
                .sorted(byKeyPath: "date", ascending: false)
        }
        updateSections()
    }

    private func updateSections() {
        guard let tokens = tokenTransactions else { return }
        tokenTransactionSections = transactionsStore.mappedSections(for: Array(tokens))
        tokenTransactionSendSections = [TransactionSection]()
        tokenTransactionRecievedSections = [TransactionSection]()
        for each in tokenTransactionSections {
            var sendItems = [Transaction]()
            var recievedItems = [Transaction]()
            for item in each.items {
                let transaction = TransactionCellViewModel(
                    transaction: item,
                    config: config,
                    chainState: ChainState(server: server),
                    currentAccount: currentAccount,
                    server: token.coin.server,
                    token: token
                )
                if transaction.transactionViewModel.direction == .outgoing {
                    sendItems.append(item)
                } else {
                    recievedItems.append(item)
                }
            }
            if !sendItems.isEmpty {
                var section = each
                section.items = sendItems
                tokenTransactionSendSections.append(section)
            }
            if !recievedItems.isEmpty {
                var section = each
                section.items = recievedItems
                tokenTransactionRecievedSections.append(section)
            }
        }
    }

    func invalidateObservers() {
        notificationToken?.invalidate()
        notificationToken = nil
        transactionToken?.invalidate()
        transactionToken = nil
    }
}
