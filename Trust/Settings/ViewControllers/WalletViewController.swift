// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import UIKit

enum DetailsViewType: Int {
    case tokens
    case nonFungibleTokens
}

class WalletViewController: UIViewController {
    fileprivate lazy var segmentController: UISegmentedControl = {
        let items = [
            R.string.localizable.tokens(),
            R.string.localizable.collectibles(),
        ]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = DetailsViewType.tokens.rawValue
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.newDesignNavBarBlue] // .darkRed]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setDividerImage(UIImage.filled(with: UIColor.white), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        for selectView in segmentedControl.subviews {
            selectView.tintColor = UIColor.white
        }
        return segmentedControl
    }()

    var tokensViewController: TokensViewController
    var nonFungibleTokensViewController: NonFungibleTokensViewController

    init(
        tokensViewController: TokensViewController,
        nonFungibleTokensViewController: NonFungibleTokensViewController
    ) {
        self.tokensViewController = tokensViewController
        self.nonFungibleTokensViewController = nonFungibleTokensViewController
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.titleView = segmentController
        setupView()
    }

    private func setupView() {
        updateView()
    }

    private func updateView() {
        if segmentController.selectedSegmentIndex == DetailsViewType.tokens.rawValue {
            showBarButtonItems()
            remove(asChildViewController: nonFungibleTokensViewController)
            add(asChildViewController: tokensViewController)
        } else {
            hideBarButtonItems()
            remove(asChildViewController: tokensViewController)
            add(asChildViewController: nonFungibleTokensViewController)
        }
    }

    @objc func selectionDidChange(_: UISegmentedControl) {
        updateView()
    }

    private func showBarButtonItems() {
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
    }

    private func hideBarButtonItems() {
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletViewController: Scrollable {
    func scrollOnTop() {
        switch segmentController.selectedSegmentIndex {
        case DetailsViewType.tokens.rawValue:
            tokensViewController.tableView.scrollOnTop()
        case DetailsViewType.nonFungibleTokens.rawValue:
            nonFungibleTokensViewController.tableView.scrollOnTop()
        default:
            break
        }
    }
}
