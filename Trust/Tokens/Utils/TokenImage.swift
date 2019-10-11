// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import TrustCore
import UIKit

class TokenImageGenerator {
    static func drawImagesAndText(title: String) -> UIImage {
        let size: CGFloat = 70
        let labelFont: CGFloat = 18
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let img = renderer.image { _ in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFont, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor(hex: "ABABAB"),
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]
            let y = size / 2 - labelFont - 2
            let string = title
            string.draw(with: CGRect(x: 0, y: y, width: size, height: size), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return img
    }
}

class ImageCaching: NSObject {
    static let shared = ImageCaching()

    var images: [String: UIImage] = [:]

    func getImage(for key: String) -> UIImage? {
        return images[key]
    }

    func setImage(_ image: UIImage, for key: String) -> UIImage {
        images[key] = image
        return image
    }
}

extension Coin {
    var tokenTitle: String {
        switch self {
        case .ethereum: return "ERC\n20"
        case .poa: return "POA\n20"
        case .ethereumClassic: return "ETC\n20"
        case .gochain: return "GO\n20"
        case .callisto: return "CLO\n20"
        case .xerom: return "XERO\n20"
        case .ether1: return "ETHO\n20"
        default: return "ERC\n20"
        }
    }
}

extension Coin {
    var tokenImage: UIImage? {
        switch self {
        case .ethereum: return R.image.ethereum_1()
        case .poa: return R.image.ethereum99()
        case .ethereumClassic: return R.image.ethereum61()
        case .gochain: return R.image.ethereum60()
        case .callisto: return R.image.ethereum820()
        case .xerom: return R.image.ethereum1313500()
        case .ether1: return R.image.ethereum64()
        default: return R.image.ethereum1313500()
        }
    }
}
