// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

final class BookmarkViewCell: UITableViewCell {
    @IBOutlet var bookmarkTitleLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var faviconImage: UIImageView!
    var viewModel: URLViewModel? {
        didSet {
            guard let model = viewModel else {
                return
            }
            bookmarkTitleLabel.text = model.title
            urlLabel.text = model.urlText
            faviconImage?.kf.setImage(
                with: viewModel?.imageURL,
                placeholder: viewModel?.placeholderImage
            )
        }
    }
}
