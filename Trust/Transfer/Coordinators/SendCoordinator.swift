// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import BigInt
import Foundation
import Result
import TrustCore
import TrustKeystore
import UIKit

protocol SendCoordinatorDelegate: class {
    func didFinish(_ result: Result<ConfirmResult, AnyError>, in coordinator: SendCoordinator)
}

final class SendCoordinator: RootCoordinator {
    let transfer: Transfer
    let session: WalletSession
    let account: Account
    let navigationController: NavigationController
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    weak var delegate: SendCoordinatorDelegate?
    var rootViewController: UIViewController {
        return controller
    }

    private lazy var controller: SendViewController = {
        let controller = SendViewController(
            session: session,
            storage: session.tokensStorage,
            account: account,
            transfer: transfer,
            chainState: chainState
        )
        controller.navigationItem.backBarButtonItem = nil
        controller.hidesBottomBarWhenPushed = true
        switch transfer.type {
        case let .ether(_, destination):
            controller.addressRow?.value = destination?.description
            controller.addressRow?.cell.row.updateCell()
        case .token, .dapp: break
        }
        controller.delegate = self
        return controller
    }()

    lazy var chainState: ChainState = {
        let state = ChainState(server: transfer.server)
        state.fetch()
        return state
    }()

    init(
        transfer: Transfer,
        navigationController: NavigationController = NavigationController(),
        session: WalletSession,
        keystore: Keystore,
        account: Account
    ) {
        self.transfer = transfer
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.session = session
        self.account = account
        self.keystore = keystore
    }
}

extension SendCoordinator: SendViewControllerDelegate {
    func didPressConfirm(transaction: UnconfirmedTransaction, transfer: Transfer, in _: SendViewController) {
        let configurator = TransactionConfigurator(
            session: session,
            account: account,
            transaction: transaction,
            server: transfer.server,
            chainState: ChainState(server: transfer.server)
        )

        let coordinator = ConfirmCoordinator(
            navigationController: navigationController,
            session: session,
            configurator: configurator,
            keystore: keystore,
            account: account,
            type: .signThenSend,
            server: transfer.server
        )
        coordinator.didCompleted = { [weak self] result in
            guard let `self` = self else { return }
            self.delegate?.didFinish(result, in: self)
        }
        addCoordinator(coordinator)
        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
    }
}
