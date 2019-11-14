// Copyright DApps Platform Inc. All rights reserved.

import StatefulViewController
import UIKit

protocol TokenViewControllerDelegate: class {
    func didPressRequest(for token: TokenObject, in controller: UIViewController)
    func didPressSend(for token: TokenObject, in controller: UIViewController)
    func didPressInfo(for token: TokenObject, in controller: UIViewController)
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController)
}

enum TokenViewType: Int {
    case All = 0, Send, Recieve
}

final class TokenViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var fiatAmountLabel: UILabel!
    @IBOutlet var marketPriceLabel: UILabel!
    @IBOutlet var percentChange: UILabel!

    @IBOutlet var allView: UIView!
    @IBOutlet var sendView: UIView!
    @IBOutlet var recieveView: UIView!

    @IBOutlet var allButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var recieveButton: UIButton!

    var selectedIndex = TokenViewType.All
    private let refreshControl = UIRefreshControl()

//    private var tableView = TransactionsTableView()

    private lazy var header: TokenHeaderView = {
        let view = TokenHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 242))
        return view
    }()

    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: header.frame.height + 100, left: 0, bottom: 0, right: 0)
    }

    private var viewModel: TokenViewModel

    weak var delegate: TokenViewControllerDelegate?

    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TokenViewController", bundle: nil)

        navigationItem.title = viewModel.title
        view.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.tableHeaderView = header
        tableView.register(TransactionViewCell.self, forCellReuseIdentifier: TransactionViewCell.identifier)
//        view.addSubview(tableView)

        /* NSLayoutConstraint.activate([
             tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         ]) */

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

        /* header.buttonsView.requestButton.addTarget(self, action: #selector(request), for: .touchUpInside)
         header.buttonsView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
         updateHeader() */
        updateHeader()

        // TODO: Enable when finished
        if isDebug {
            // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(infoAction))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observToken()
        observTransactions()
        configTableViewStates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialViewState()
        fetch()
    }

    private func fetch() {
        startLoading()
        viewModel.fetch()
    }

    @objc func infoAction() {
        delegate?.didPressInfo(for: viewModel.token, in: self)
    }

    private func observToken() {
        viewModel.tokenObservation { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.updateHeader()
            self?.endLoading()
        }
    }

    private func observTransactions() {
        viewModel.transactionObservation { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            self?.endLoading()
        }
    }

    private func updateHeader() {
        /* header */ imageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: viewModel.imagePlaceholder
        )
        amountLabel.text = viewModel.amount
        amountLabel.font = viewModel.amountFont
        amountLabel.textColor = viewModel.amountTextColor

        fiatAmountLabel.text = viewModel.totalFiatAmount
        fiatAmountLabel.font = viewModel.fiatAmountFont
        fiatAmountLabel.textColor = viewModel.fiatAmountTextColor

        marketPriceLabel.text = viewModel.marketPrice
        marketPriceLabel.textColor = viewModel.marketPriceTextColor
        marketPriceLabel.font = viewModel.marketPriceFont

        percentChange.text = viewModel.percentChange
        percentChange.textColor = viewModel.percentChangeColor
        percentChange.font = viewModel.percentChangeFont
    }

    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        fetch()
    }

    @objc func send() {
        delegate?.didPressSend(for: viewModel.token, in: self)
    }

    @objc func request() {
        delegate?.didPressRequest(for: viewModel.token, in: self)
    }

    deinit {
        viewModel.invalidateObservers()
    }

    private func configTableViewStates() {
        errorView = ErrorView(insets: insets, onRetry: { [weak self] in
            self?.fetch()
        })
        loadingView = LoadingView(insets: insets)
        emptyView = TransactionsEmptyView(insets: insets)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TokenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.numberOfSections(type: selectedIndex)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.identifier, for: indexPath) as! TransactionViewCell
        cell.configure(viewModel: viewModel.cellViewModel(for: indexPath, type: selectedIndex))
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(for: section, type: selectedIndex)
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionHeader(
            title: viewModel.titleForHeader(in: section, type: selectedIndex)
        )
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return StyleLayout.TableView.heightForHeaderInSection
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didPress(viewModel: viewModel, transaction: viewModel.item(for: indexPath.row, section: indexPath.section, type: selectedIndex), in: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return TransactionsLayout.tableView.height // UITableView.automaticDimension
    }
}

extension TokenViewController: StatefulViewController {
    func hasContent() -> Bool {
        return viewModel.hasContent()
    }
}

extension TokenViewController {
    @IBAction func didTapSend() {
        send()
    }

    @IBAction func didTapRecieve() {
        request()
    }

    @IBAction func didTapAll() {
        selectedIndex = .All
        allView.isHidden = false
        sendView.isHidden = true
        recieveView.isHidden = true

        tableView.reloadData()
    }

    @IBAction func didTapSendItems() {
        selectedIndex = .Send
        allView.isHidden = true
        sendView.isHidden = false
        recieveView.isHidden = true

        tableView.reloadData()
    }

    @IBAction func didTapRecieveItems() {
        selectedIndex = .Recieve
        allView.isHidden = true
        sendView.isHidden = true
        recieveView.isHidden = false

        tableView.reloadData()
    }
}
