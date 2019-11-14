// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustWalletSDK
import URLNavigator

struct URLNavigatorCoordinator {
    // let branch = BranchCoordinator()
    let navigator = Navigator()

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // var handled = branch.application(app, open: url, options: options)

        // if !handled {
        //    handled = navigator.open(url)
        // }
        navigator.open(url)
        return true
    }
}
