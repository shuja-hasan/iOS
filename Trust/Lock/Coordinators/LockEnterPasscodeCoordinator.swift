// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import UIKit

final class LockEnterPasscodeCoordinator: Coordinator {
    var coordinators: [Coordinator] = []
    let window: UIWindow = UIWindow()
    private let model: LockEnterPasscodeViewModel
    private let lock: LockInterface
    private lazy var lockEnterPasscodeViewController: LockEnterPasscodeViewController = {
        LockEnterPasscodeViewController(model: model)
    }()

    init(model: LockEnterPasscodeViewModel, lock: LockInterface = Lock()) {
        window.windowLevel = UIWindow.Level.statusBar + 1.0
        self.model = model
        self.lock = lock
        lockEnterPasscodeViewController.unlockWithResult = { [weak self] state, _ in
            if state {
                self?.stop()
            }
        }
    }

    func start() {
        guard lock.shouldShowProtection() else { return }

        window.rootViewController = lockEnterPasscodeViewController
        window.makeKeyAndVisible()
    }

    // This method should be refactored!!!
    func showAuthentication() {
        if window.isKeyWindow {
            if lock.isPasscodeSet() {
                Lock().removeAutoLockTime()
                lockEnterPasscodeViewController.resetBiometricAuth()
                lockEnterPasscodeViewController.touchValidation()
                lockEnterPasscodeViewController.hideKeyboard()
                return
            }
        }

        lockEnterPasscodeViewController.cleanUserInput()
        lockEnterPasscodeViewController.showKeyboard()
    }

    func stop() {
        window.isHidden = true
    }
}
