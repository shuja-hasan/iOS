// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import TrustKeystore

final class ExportPhraseCoordinator: RootCoordinator {
    let keystore: Keystore
    let account: Wallet
    let words: [String]
    var coordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return passphraseViewController
    }

    var passphraseViewController: PassphraseViewController {
        let controller = PassphraseViewController(
            account: account,
            words: words
        )
        controller.delegate = self
        controller.title = viewModel.title
        return controller
    }

    private lazy var viewModel: ExportPhraseViewModel = {
        .init(keystore: keystore, account: account)
    }()

    init(
        keystore: Keystore,
        account: Wallet,
        words: [String]
    ) {
        self.keystore = keystore
        self.account = account
        self.words = words
    }
}

extension ExportPhraseCoordinator: PassphraseViewControllerDelegate {
    func didPressVerify(in _: PassphraseViewController, with _: Wallet, words _: [String]) {
        // Missing functionality
    }
}
