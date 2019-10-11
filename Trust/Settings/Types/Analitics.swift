// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import UIKit

enum Analitics: String {
    case branch
    case answer

    var title: String {
        switch self {
        case .answer: return R.string.localizable.dailyUsage()
        case .branch: return R.string.localizable.deferredDeepLinking()
        }
    }

    var description: String {
        switch self {
        case .branch:
            return R.string.localizable.settingsAnaliticsBranchDescription()
        case .answer:
            return R.string.localizable.settingsAnaliticsAnswerDescription()
        }
    }

    var isEnabled: Bool {
        let preferencesController = PreferencesController()
        guard let object = preferencesController.get(for: self.rawValue), let number = object as? NSNumber else {
            preferencesController.set(value: NSNumber(booleanLiteral: true), for: rawValue)
            return true
        }
        return number.boolValue
    }

    func update(with state: Bool) {
        let preferencesController = PreferencesController()
        preferencesController.set(value: NSNumber(booleanLiteral: state), for: rawValue)
    }
}
