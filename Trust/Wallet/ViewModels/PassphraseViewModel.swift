// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import UIKit

struct PassphraseViewModel {
    var title: String {
        return R.string.localizable.backupPhrase()
    }

    var backgroundColor: UIColor {
        return .white
    }

    var phraseFont: UIFont {
        return UIFont(name: "Trenda-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
