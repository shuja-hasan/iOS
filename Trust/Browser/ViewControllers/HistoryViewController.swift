// Copyright DApps Platform Inc. All rights reserved.

import StatefulViewController
import UIKit

protocol HistoryViewControllerDelegate: class {
    func didSelect(history: History, in controller: HistoryViewController)
}

final class HistoryViewController: UIViewController {
    let store: HistoryStore
    let tableView = UITableView(frame: .zero, style: .plain)
    lazy var viewModel: HistoriesViewModel = {
        HistoriesViewModel(store: store)
    }()

    weak var delegate: HistoryViewControllerDelegate?

    init(store: HistoryStore) {
        self.store = store

        super.init(nibName: nil, bundle: nil)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.veryLightGray
        tableView.rowHeight = 60
        tableView.register(R.nib.bookmarkViewCell(), forCellReuseIdentifier: R.nib.bookmarkViewCell.name)
        view.addSubview(tableView)
        emptyView = EmptyView(title: NSLocalizedString("history.noHistory.label.title", value: "No history yet!", comment: ""))

        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialViewState()

        fetch()
    }

    func fetch() {
        tableView.reloadData()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HistoryViewController: StatefulViewController {
    func hasContent() -> Bool {
        return viewModel.hasContent
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.numberOfRows
    }

    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.bookmarkViewCell.name, for: indexPath) as! BookmarkViewCell
        cell.viewModel = HistoryViewModel(history: viewModel.item(for: indexPath))
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let history = viewModel.item(for: indexPath)
        delegate?.didSelect(history: history, in: self)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let history = viewModel.item(for: indexPath)
            confirm(
                title: NSLocalizedString("Are you sure you would like to delete?", value: "Are you sure you would like to delete?", comment: ""),
                okTitle: R.string.localizable.delete(),
                okStyle: .destructive
            ) { [weak self] result in
                switch result {
                case .success:
                    self?.store.delete(histories: [history])
                    self?.tableView.reloadData()
                case .failure: break
                }
            }
        }
    }
}
