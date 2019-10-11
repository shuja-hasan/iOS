// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    private var previousController: UIViewController?

    override init(nibName _: String?, bundle _: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if previousController == nil {
            previousController = viewController
        }

        if previousController == viewController {
            if let nav = viewController as? UINavigationController,
                nav.viewControllers.count < 2,
                let controller = nav.viewControllers.first as? Scrollable {
                controller.scrollOnTop()
            }
        }
        previousController = viewController
        return true
    }
}
