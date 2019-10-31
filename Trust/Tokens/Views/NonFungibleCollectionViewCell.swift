// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class NonFungibleCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subTitle: UILabel!
    @IBOutlet var imageViewBackground: UIView!
    @IBOutlet private var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        imageViewBackground.backgroundColor = .randomPastelColor()
    }

    func configure(with viewModel: NonFungibleCollectionViewCellModel) {
        title.text = viewModel.name
        subTitle.text = viewModel.annotation
        imageView.kf.setImage(
            with: viewModel.imagePath,
            placeholder: R.image.launch_screen_logo()
        )
    }
}
