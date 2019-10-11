// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

enum SettingsAction {
    case currency
    case pushNotifications(NotificationChanged)
    case clearBrowserCache
    case clearTransactions
    case clearTokens
    case openURL(URL)
    case wallets
}
