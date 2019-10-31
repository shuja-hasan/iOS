// Copyright DApps Platform Inc. All rights reserved.

import UIKit

enum AppStyle {
    case heading
    case headingSemiBold
    case paragraph
    case paragraphLight
    case paragraphSmall
    case largeAmount
    case error
    case formHeader
    case collactablesHeader

    var font: UIFont {
        switch self {
        case .heading:
            return UIFont(name: "Trenda-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)
        case .headingSemiBold:
            return UIFont(name: "Trenda-Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .paragraph:
            return UIFont(name: "Trenda-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
        case .paragraphSmall:
            return UIFont(name: "Trenda-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        case .paragraphLight:
            return UIFont(name: "Trenda-Light", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .light)
        case .largeAmount:
            return UIFont(name: "Trenda-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        case .error:
            return UIFont(name: "Trenda-Light", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .light)
        case .formHeader:
            return UIFont(name: "Trenda-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        case .collactablesHeader:
            return UIFont(name: "Trenda-Regular", size: 21) ?? UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.regular)
        }
    }

    var textColor: UIColor {
        switch self {
        case .heading, .headingSemiBold:
            return Colors.black
        case .paragraph, .paragraphLight, .paragraphSmall:
            return Colors.charcoal
        case .largeAmount:
            return UIColor.black // Usually colors based on the amount
        case .error:
            return Colors.errorRed
        case .formHeader:
            return Colors.doveGray
        case .collactablesHeader:
            return Colors.lightDark
        }
    }
}
