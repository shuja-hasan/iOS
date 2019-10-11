// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation

enum PaymentFlow {
    case send(type: Transfer)
    case request(TokenObject)
}
