// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

@testable import Trust
import UIKit

class FakeLockProtocol: LockInterface {
    var passcodeSet = true
    var showProtection = true

    func isPasscodeSet() -> Bool {
        return passcodeSet
    }

    func shouldShowProtection() -> Bool {
        return isPasscodeSet() && showProtection
    }
}
