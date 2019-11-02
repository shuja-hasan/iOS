// Copyright DApps Platform Inc. All rights reserved.

import Foundation
@testable import Trust
import UIKit

class FakeNavigationController: NavigationController {
    private var _presentedViewController: UIViewController?

    override var presentedViewController: UIViewController? {
        return _presentedViewController
    }

    override func pushViewController(_ viewController: UIViewController, animated _: Bool) {
        super.pushViewController(viewController, animated: false)
    }

    override func present(_ viewControllerToPresent: UIViewController, animated _: Bool, completion _: (() -> Void)? = nil) {
        _presentedViewController = viewControllerToPresent
    }
}
