// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import TrustWalletSDK
import URLNavigator

extension InCoordinator: URLNavigable {
    func register(with navigator: Navigator) {
        navigator.handle(URLSchemes.browser) { url, _, _ in
            guard let target = url.queryParameters["target"],
                let targetUrl = URL(string: target) else {
                return false
            }
            self.showTab(.browser(openURL: targetUrl))
            return true
        }

        navigator.handle("app://sign-transaction") { url, _, _ in
            self.localSchemeCoordinator?.trustWalletSDK.handleOpen(url: url as! URL) ?? false
        }

        navigator.handle("app://sign-message") { url, _, _ in
            self.localSchemeCoordinator?.trustWalletSDK.handleOpen(url: url as! URL) ?? false
        }

        navigator.handle("app://sign-personal-message") { url, _, _ in
            self.localSchemeCoordinator?.trustWalletSDK.handleOpen(url: url as! URL) ?? false
        }
    }
}
