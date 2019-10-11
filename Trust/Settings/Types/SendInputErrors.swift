// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

enum SendInputErrors: LocalizedError {
    case emptyClipBoard
    case wrongInput

    var errorDescription: String? {
        switch self {
        case .emptyClipBoard:
            return NSLocalizedString("send.error.emptyClipBoard", value: "Empty ClipBoard", comment: "")
        case .wrongInput:
            return NSLocalizedString("send.error.wrongInput", value: "Wrong Input", comment: "")
        }
    }
}
