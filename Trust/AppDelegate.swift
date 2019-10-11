// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import Branch
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator!
    //This is separate coordinator for the protection of the sensitive information.
    lazy var protectionCoordinator: ProtectionCoordinator = {
        return ProtectionCoordinator()
    }()
    let urlNavigatorCoordinator = URLNavigatorCoordinator()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _  in }
        UIApplication.shared.registerForRemoteNotifications()

        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)

        coordinator = AppCoordinator(window: window!, keystore: keystore, navigator: urlNavigatorCoordinator)
        coordinator.start()

        if !UIApplication.shared.isProtectedDataAvailable {
            fatalError()
        }

        protectionCoordinator.didFinishLaunchingWithOptions()
        //urlNavigatorCoordinator.branch.didFinishLaunchingWithOptions(launchOptions: launchOptions)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        coordinator.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        protectionCoordinator.applicationWillResignActive()
        Lock().setAutoLockTime()
        CookiesStore.save()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        protectionCoordinator.applicationDidBecomeActive()
        CookiesStore.load()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        protectionCoordinator.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        protectionCoordinator.applicationWillEnterForeground()
    }

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }

//    func application(
//        _ application: UIApplication,
//        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        Branch.getInstance().handlePushNotification(userInfo)
//    }

    // Respond to URI scheme links
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return urlNavigatorCoordinator.application(app, open: url, options: options)
    }

    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        //Branch.getInstance().continue(userActivity)
        return true
    }
}
