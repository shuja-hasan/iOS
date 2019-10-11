// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import UIKit

struct HistoryViewModel: URLViewModel {
    let history: History

    init(
        history: History
    ) {
        self.history = history
    }

    var urlText: String? {
        return history.URL?.absoluteString
    }

    var title: String {
        return history.title
    }

    var imageURL: URL? {
        return Favicon.get(for: history.URL)
    }
}
