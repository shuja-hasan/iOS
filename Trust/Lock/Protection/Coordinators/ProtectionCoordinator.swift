// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class ProtectionCoordinator: Coordinator {
    var coordinators: [Coordinator] = []
    lazy var splashCoordinator: SplashCoordinator = {
        SplashCoordinator(window: self.protectionWindow)
    }()

    lazy var lockEnterPasscodeCoordinator: LockEnterPasscodeCoordinator = {
        LockEnterPasscodeCoordinator(model: LockEnterPasscodeViewModel())
    }()

    let protectionWindow = UIWindow()
    init() {
        protectionWindow.windowLevel = UIWindow.Level.statusBar + 2.0
    }

    func didFinishLaunchingWithOptions() {
        splashCoordinator.start()
        lockEnterPasscodeCoordinator.start()
        // lockEnterPasscodeCoordinator.showAuthentication()
    }

    func applicationDidBecomeActive() {
        splashCoordinator.stop()
    }

    func applicationWillResignActive() {
        splashCoordinator.start()
    }

    func applicationDidEnterBackground() {
        splashCoordinator.start()
        lockEnterPasscodeCoordinator.start()
    }

    func applicationWillEnterForeground() {
        splashCoordinator.stop()
        lockEnterPasscodeCoordinator.start()
        lockEnterPasscodeCoordinator.showAuthentication()
    }
}
