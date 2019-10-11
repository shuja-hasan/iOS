// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Branch
import Eureka
import KeychainSwift
import TrustCore
import UIKit

struct Node {
    let name: String
    let options: [RPCServer]
    let main: RPCServer
}

struct DeveloperViewModel {}

protocol DeveloperViewControllerDelegate: class {
    func didClearTransactions(in controller: DeveloperViewController)
    func didClearTokens(in controller: DeveloperViewController)
}

final class DeveloperViewController: FormViewController {
    private let viewModel = DeveloperViewModel()
    let preferencesController = PreferencesController()

    weak var delegate: DeveloperViewControllerDelegate?

    private struct Values {
        static let ethereumNet = "ethereumNet"
        static let ethereumTestNet = "ethereumTestNet"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = R.string.localizable.developer()

        AppFormAppearance.button {
            $0.title = "Clear Transactions"
            self.title = nil
        }.onCellSelection { [weak self] _, _ in
            guard let `self` = self else { return }
            self.delegate?.didClearTransactions(in: self)
        }.cellUpdate { cell, _ in
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = .black
        }

            <<< AppFormAppearance.button {
                $0.title = "Clear Tokens"
            }.onCellSelection { [weak self] _, _ in
                guard let `self` = self else { return }
                self.delegate?.didClearTokens(in: self)
            }.cellUpdate { cell, _ in
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.textColor = .black
            }
    }
}
