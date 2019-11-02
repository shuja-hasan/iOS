// Copyright DApps Platform Inc. All rights reserved.
import Foundation
import UIKit

struct HelpUsViewModel {
    var title: String {
        return NSLocalizedString("welldone.navigation.title", value: "Thank you!", comment: "")
    }

    private let sharingText: [String] = [
        NSLocalizedString(
            "welldone.viewmodel.sharing.text1",
            value: "Here is the app I use to store my Ether-1 and ERC20 tokens.",
            comment: ""
        ),
        NSLocalizedString(
            "welldone.viewmodel.sharing.text2",
            value: "Check out Ether-1 Wallet - the wallet that lets me securely store my Ether-1 and ERC20 tokens.",
            comment: ""
        ),
        NSLocalizedString(
            "welldone.viewmodel.sharing.text3",
            value: "I securely store Ether-1 and ERC20 tokens in the Ether-1 Wallet",
            comment: ""
        ),
        NSLocalizedString(
            "welldone.viewmodel.sharing.text4",
            value: "I secure my Ether-1 and ERC20 tokens in the Ether-1 Wallet.",
            comment: ""
        ),
    ]

    var activityItems: [Any] {
        return [
            sharingText[Int(arc4random_uniform(UInt32(sharingText.count)))],
            URL(string: Constants.website)!,
        ]
    }
}
