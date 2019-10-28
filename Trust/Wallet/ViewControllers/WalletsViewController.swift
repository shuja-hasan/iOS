// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import TrustKeystore
import UIKit

protocol WalletsViewControllerDelegate: class {
    func didSelect(wallet: WalletInfo, account: Account, in controller: WalletsViewController)
    func didDeleteAccount(account: WalletInfo, in viewController: WalletsViewController)
    func didSelectForInfo(wallet: WalletInfo, account: Account, in controller: WalletsViewController)
}

class WalletsViewController: UITableViewController {
    let keystore: Keystore
    lazy var viewModel: WalletsViewModel = {
        let model = WalletsViewModel(keystore: keystore)
        model.delegate = self
        return model
    }()

    weak var delegate: WalletsViewControllerDelegate?

    init(keystore: Keystore) {
        self.keystore = keystore
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Colors.veryLightGray
        tableView.separatorColor = .clear // StyleLayout.TableView.separatorColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(R.nib.walletViewCell(), forCellReuseIdentifier: R.nib.walletViewCell.name)
        navigationItem.title = viewModel.title
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }

    func fetch() {
        viewModel.fetchBalances()
        viewModel.refresh()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.walletViewCell.name, for: indexPath) as! WalletViewCell
        cell.viewModel = viewModel.cellViewModel(for: indexPath)
        cell.delegate = self
        return cell
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSection
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canEditRowAt(for: indexPath)
    }

    override func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            confirmDelete(wallet: viewModel.cellViewModel(for: indexPath).wallet)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = self.viewModel.cellViewModel(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(wallet: viewModel.wallet, account: viewModel.account, in: self)
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func confirmDelete(wallet: WalletInfo) {
        confirm(
            title: NSLocalizedString("accounts.confirm.delete.title", value: "Are you sure you would like to delete this wallet?", comment: ""),
            message: NSLocalizedString("accounts.confirm.delete.message", value: "Make sure you have backup of your wallet.", comment: ""),
            okTitle: R.string.localizable.delete(),
            okStyle: .destructive
        ) { [weak self] result in
            switch result {
            case .success:
                self?.delete(wallet: wallet)
            case .failure: break
            }
        }
    }

    func delete(wallet: WalletInfo) {
        navigationController?.displayLoading(text: R.string.localizable.deleting())
        keystore.delete(wallet: wallet) { [weak self] result in
            guard let `self` = self else { return }
            self.navigationController?.hideLoading()
            switch result {
            case .success:
                self.delegate?.didDeleteAccount(account: wallet, in: self)
            case let .failure(error):
                self.displayError(error: error)
            }
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletsViewController: WalletViewCellDelegate {
    func didPress(viewModel: WalletAccountViewModel, in _: WalletViewCell) {
        delegate?.didSelectForInfo(wallet: viewModel.wallet, account: viewModel.account, in: self)
    }
}

extension WalletsViewController: WalletsViewModelProtocol {
    func update() {
        viewModel.refresh()
        tableView.reloadData()
    }
}
