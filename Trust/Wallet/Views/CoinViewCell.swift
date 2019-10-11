// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import UIKit

class CoinViewCell: UITableViewCell {
    @IBOutlet var coinImageView: TokenImageView!
    @IBOutlet var coinLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        updateSeparatorInset()
    }

    func configure(for viewModel: CoinViewModel) {
        coinImageView.image = viewModel.image
        coinLabel.text = viewModel.walletName
    }

    private func updateSeparatorInset() {
        separatorInset = UIEdgeInsets(
            top: 0,
            left: layoutInsets.left + 76,
            bottom: 0, right: 0
        )
    }
}
