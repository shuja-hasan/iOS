// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import TrustCore
import UIKit

protocol WalletViewCellDelegate: class {
    func didPress(viewModel: WalletAccountViewModel, in cell: WalletViewCell)
}

final class WalletViewCell: UITableViewCell {
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var glassesImageView: UIImageView!
    @IBOutlet var walletTypeImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var identiconImageView: TokenImageView!
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var balance: UILabel!

    weak var delegate: WalletViewCellDelegate?

    var viewModel: WalletAccountViewModel? {
        didSet {
            guard let model = viewModel else {
                return
            }
            title.text = model.title
            subtitle.text = model.address
            glassesImageView.isHidden = !model.isWatch
            infoButton.tintColor = Colors.newDesignNavBarBlue // .darkRed
            identiconImageView.image = model.image
            selectedImageView.image = model.selectedImage
            balance.isHidden = model.isBalanceHidden
            balance.text = model.balance
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateSeparatorInset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    @IBAction func infoAction(_: Any) {
        guard let viewModel = viewModel else { return }
        delegate?.didPress(viewModel: viewModel, in: self)
    }

    private func updateSeparatorInset() {
        separatorInset = UIEdgeInsets(
            top: 0,
            left: layoutInsets.left + 80,
            bottom: 0, right: 0
        )
    }
}
