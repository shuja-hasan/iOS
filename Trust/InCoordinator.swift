// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import RealmSwift
import Result
import TrustCore
import TrustKeystore
import TrustWalletSDK
import UIKit
import URLNavigator

protocol InCoordinatorDelegate: class {
    func didCancel(in coordinator: InCoordinator)
    func didUpdateAccounts(in coordinator: InCoordinator)
}

enum CoinType {
    case coin(Account, TokenObject)
    case tokenOf(Account, TokenObject)
}

struct CoinTypeViewModel {
    let type: CoinType

    var account: Account {
        switch type {
        case let .coin(account, _):
            return account
        case let .tokenOf(account, _):
            return account
        }
    }

    var address: String {
        switch type {
        case let .coin(account, _):
            return account.address.description
        case let .tokenOf(account, _):
            return account.address.description
        }
    }

    var name: String {
        switch type {
        case let .coin(_, token):
            return token.name
        case let .tokenOf(_, token):
            return token.name
        }
    }

    var server: RPCServer {
        switch account.coin! {
        case .ethereum: return RPCServer.main
        case .ethereumClassic: return RPCServer.classic
        case .gochain: return RPCServer.gochain
        case .poa: return RPCServer.poa
        case .callisto: return RPCServer.callisto
        case .bitcoin: return RPCServer.main
        case .ether1: return RPCServer.ether1
//        case .xerom: return RPCServer.xerom
        }
    }
}

class InCoordinator: Coordinator {
    let navigationController: NavigationController
    var coordinators: [Coordinator] = []
    let initialWallet: WalletInfo
    var keystore: Keystore
    let config: Config
    let appTracker: AppTracker
    let navigator: Navigator
    weak var delegate: InCoordinatorDelegate?
    private var pendingTransactionsObserver: NotificationToken?
    var browserCoordinator: BrowserCoordinator? {
        return coordinators.compactMap { $0 as? BrowserCoordinator }.first
    }

    var settingsCoordinator: SettingsCoordinator? {
        return coordinators.compactMap { $0 as? SettingsCoordinator }.first
    }

    var tokensCoordinator: TokensCoordinator? {
        return coordinators.compactMap { $0 as? TokensCoordinator }.first
    }

    var tabBarController: UITabBarController? {
        return navigationController.viewControllers.first as? UITabBarController
    }

    var localSchemeCoordinator: LocalSchemeCoordinator?
    lazy var helpUsCoordinator: HelpUsCoordinator = {
        HelpUsCoordinator(
            navigationController: navigationController,
            appTracker: appTracker
        )
    }()

    let events: [BranchEvent] = []

    init(
        navigationController: NavigationController = NavigationController(),
        wallet: WalletInfo,
        keystore: Keystore,
        config: Config = .current,
        appTracker: AppTracker = AppTracker(),
        navigator: Navigator = Navigator(),
        events _: [BranchEvent] = []
    ) {
        self.navigationController = navigationController
        initialWallet = wallet
        self.keystore = keystore
        self.config = config
        self.appTracker = appTracker
        self.navigator = navigator
        register(with: navigator)
    }

    func start() {
        showTabBar(for: initialWallet, tab: Tabs.wallet(.none))
        checkDevice()

        helpUsCoordinator.start()
        addCoordinator(helpUsCoordinator)
    }

    func showTabBar(for account: WalletInfo, tab: Tabs) {
        let migration = MigrationInitializer(account: account)
        migration.perform()

        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()

        let realm = self.realm(for: migration.config)
        let sharedRealm = self.realm(for: sharedMigration.config)

        let viewModel = InCoordinatorViewModel(config: config)

        let session = WalletSession(
            account: account,
            realm: realm,
            sharedRealm: sharedRealm,
            config: config
        )
        session.transactionsStorage.removeTransactions(for: [.failed, .unknown])

        // Create coins based on supported networks
        let coins = Config.current.servers
        if let wallet = account.currentWallet, account.accounts.count < coins.count, account.mainWallet {
            let derivationPaths = coins.map { $0.derivationPath(at: 0) }
            _ = keystore.addAccount(to: wallet, derivationPaths: derivationPaths)
        }

        let tabBarController = TabBarController()
        tabBarController.tabBar.isTranslucent = false

        let browserCoordinator = BrowserCoordinator(session: session, keystore: keystore, navigator: navigator, sharedRealm: sharedRealm)
        browserCoordinator.delegate = self
        browserCoordinator.start()
        browserCoordinator.rootViewController.tabBarItem = viewModel.browserBarItem
        addCoordinator(browserCoordinator)

        let walletCoordinator = TokensCoordinator(
            session: session,
            keystore: keystore,
            tokensStorage: session.tokensStorage,
            transactionsStore: session.transactionsStorage
        )
        walletCoordinator.rootViewController.tabBarItem = viewModel.walletBarItem
        walletCoordinator.delegate = self
        walletCoordinator.start()
        addCoordinator(walletCoordinator)

        let settingsCoordinator = SettingsCoordinator(
            keystore: keystore,
            session: session,
            storage: session.transactionsStorage,
            walletStorage: session.walletStorage,
            sharedRealm: sharedRealm
        )
        settingsCoordinator.rootViewController.tabBarItem = viewModel.settingsBarItem
        settingsCoordinator.delegate = self
        settingsCoordinator.start()
        addCoordinator(settingsCoordinator)

        tabBarController.viewControllers = [
            walletCoordinator.navigationController.childNavigationController,
            browserCoordinator.navigationController.childNavigationController,
            settingsCoordinator.navigationController.childNavigationController,
        ]

        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)

        showTab(tab)
        keystore.recentlyUsedWallet = account

        let localSchemeCoordinator = LocalSchemeCoordinator(
            navigationController: navigationController,
            keystore: keystore,
            session: session
        )
        localSchemeCoordinator.delegate = self
        addCoordinator(localSchemeCoordinator)
        self.localSchemeCoordinator = localSchemeCoordinator

        observePendingTransactions(from: session.transactionsStorage)
    }

    func showTab(_ selectTab: Tabs) {
        guard let viewControllers = tabBarController?.viewControllers else { return }
        guard let nav = viewControllers[selectTab.index] as? UINavigationController else { return }

        switch selectTab {
        case let .browser(url):
            if let url = url {
                browserCoordinator?.openURL(url)
            }
        case let .wallet(action):
            switch action {
            case .none: break
            case let .addToken(address):
                tokensCoordinator?.addTokenContract(for: address)
            }
        case .settings:
            break
        }

        tabBarController?.selectedViewController = nav
    }

    func restart(for account: WalletInfo, tab: Tabs) {
        settingsCoordinator?.rootViewController.navigationItem.leftBarButtonItem = nil
        localSchemeCoordinator?.delegate = nil
        localSchemeCoordinator = nil
        navigationController.dismiss(animated: false, completion: nil)
        removeAllCoordinators()
        navigationController.viewControllers.removeAll()
        showTabBar(for: account, tab: tab)
    }

    func checkDevice() {
        let deviceChecker = CheckDeviceCoordinator(
            navigationController: navigationController,
            jailbreakChecker: DeviceChecker()
        )
        deviceChecker.start()
    }

    func sendFlow(for token: TokenObject) {
        guard let tokensCoordinator = tokensCoordinator else { return }
        let nav = tokensCoordinator.navigationController
        let session = tokensCoordinator.session

        let transfer: Transfer = {
            let server = token.coin.server
            switch token.type {
            case .coin:
                return Transfer(server: server, type: .ether(token, destination: .none))
            case .ERC20:
                return Transfer(server: server, type: .token(token))
            }
        }()

        switch session.account.type {
        case .privateKey, .hd:
            let first = session.account.accounts.filter { $0.coin == token.coin }.first
            guard let account = first else { return }

            let coordinator = SendCoordinator(
                transfer: transfer,
                navigationController: nav,
                session: session,
                keystore: keystore,
                account: account
            )
            coordinator.delegate = self
            addCoordinator(coordinator)
            nav.pushCoordinator(coordinator: coordinator, animated: true)
        case .address:
            nav.displayError(error: InCoordinatorError.onlyWatchAccount)
        }
    }

    func requestFlow(for token: TokenObject) {
        guard let tokensCoordinator = tokensCoordinator else { return }
        let nav = tokensCoordinator.navigationController
        let session = tokensCoordinator.session

        let first = session.account.accounts.filter { $0.coin == token.coin }.first
        guard let account = first else { return }

        let viewModel = CoinTypeViewModel(type: .coin(account, token))
        let coordinator = RequestCoordinator(
            session: session,
            coinTypeViewModel: viewModel
        )
        addCoordinator(coordinator)
        nav.pushCoordinator(coordinator: coordinator, animated: true)

        if case .address = session.account.type {
            coordinator.rootViewController.displayError(error: InCoordinatorError.onlyWatchAccount)
        }
    }

    private func handlePendingTransaction(transaction: SentTransaction) {
        let transaction = SentTransaction.from(transaction: transaction)
        tokensCoordinator?.transactionsStore.add([transaction])
    }

    private func realm(for config: Realm.Configuration) -> Realm {
        return try! Realm(configuration: config)
    }

    @discardableResult
    func handleEvent(_ event: BranchEvent) -> Bool {
        switch event {
        case let .openURL(url):
            showTab(.browser(openURL: url))
        case let .newToken(address):
            showTab(.wallet(.addToken(address)))
        }
        return true
    }

    private func observePendingTransactions(from storage: TransactionsStorage) {
        pendingTransactionsObserver = storage.transactions.observe { [weak self] _ in
            let items = storage.pendingObjects
            self?.tabBarController?.tabBar.items?[Tabs.wallet(.none).index].badgeValue = items.isEmpty ? nil : String(items.count)
        }
    }

    deinit {
        pendingTransactionsObserver?.invalidate()
        pendingTransactionsObserver = nil
    }
}

extension InCoordinator: LocalSchemeCoordinatorDelegate {
    func didCancel(in coordinator: LocalSchemeCoordinator) {
        coordinator.navigationController.dismiss(animated: true, completion: nil)
        removeCoordinator(coordinator)
    }
}

extension InCoordinator: SettingsCoordinatorDelegate {
    func didCancel(in coordinator: SettingsCoordinator) {
        removeCoordinator(coordinator)
        coordinator.navigationController.dismiss(animated: true, completion: nil)
        delegate?.didCancel(in: self)
    }

    func didRestart(with account: WalletInfo, tab: Tabs, in _: SettingsCoordinator) {
        restart(for: account, tab: tab)
    }

    func didUpdateAccounts(in _: SettingsCoordinator) {
        delegate?.didUpdateAccounts(in: self)
    }

    func didPressURL(_ url: URL, in _: SettingsCoordinator) {
        showTab(.browser(openURL: url))
    }
}

extension InCoordinator: TokensCoordinatorDelegate {
    func didPressSend(for token: TokenObject, in _: TokensCoordinator) {
        sendFlow(for: token)
    }

    func didPressRequest(for token: TokenObject, in _: TokensCoordinator) {
        requestFlow(for: token)
    }

    func didPressDiscover(in _: TokensCoordinator) {
        guard let url = RPCServer.main.openseaURL else { return }
        showTab(.browser(openURL: url))
    }

    func didPress(url: URL, in _: TokensCoordinator) {
        showTab(.browser(openURL: url))
    }
}

extension InCoordinator: SendCoordinatorDelegate {
    func didFinish(_ result: Result<ConfirmResult, AnyError>, in coordinator: SendCoordinator) {
        switch result {
        case let .success(confirmResult):
            switch confirmResult {
            case let .sentTransaction(transaction):
                handlePendingTransaction(transaction: transaction)
                // TODO. Pop 2 view controllers
                coordinator.navigationController.childNavigationController.popToRootViewController(animated: true)
                removeCoordinator(coordinator)
            case .signedTransaction:
                break
            }
        case let .failure(error):
            coordinator.navigationController.topViewController?.displayError(error: error)
        }
    }
}

extension InCoordinator: BrowserCoordinatorDelegate {
    func didSentTransaction(transaction: SentTransaction, in _: BrowserCoordinator) {
        handlePendingTransaction(transaction: transaction)
    }
}

extension InCoordinator: WalletsCoordinatorDelegate {
    func didUpdateAccounts(in _: WalletsCoordinator) {
        delegate?.didUpdateAccounts(in: self)
    }

    func didSelect(wallet: WalletInfo, in coordinator: WalletsCoordinator) {
        coordinator.navigationController.dismiss(animated: true)
        // removeCoordinator(coordinator)
        restart(for: wallet, tab: Tabs.wallet(WalletAction.none))
    }

    func didCancel(in _: WalletsCoordinator) {
        navigationController.dismiss(animated: true)
        // removeCoordinator(coordinator)
    }
}
