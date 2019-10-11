// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import StackViewController
import UIKit

extension UIViewController {
    func displayChildViewController(viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        _ = viewController.view.activateSuperviewHuggingConstraints()
        viewController.didMove(toParent: self)
    }
}
