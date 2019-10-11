// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import UIKit

protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

typealias RootCoordinator = Coordinator & RootViewControllerProvider

public class NavigationController: UIViewController {
    private let rootViewController: UIViewController
    private var viewControllersToChildCoordinators: [UIViewController: Coordinator] = [:]

    var viewControllers: [UIViewController] {
        get { return childNavigationController.viewControllers }
        set { childNavigationController.viewControllers = newValue }
    }

    var navigationBar: UINavigationBar {
        return childNavigationController.navigationBar
    }

    var isToolbarHidden: Bool {
        get { return childNavigationController.isToolbarHidden }
        set { childNavigationController.isToolbarHidden = newValue }
    }

    var topViewController: UIViewController? {
        return childNavigationController.topViewController
    }

    let childNavigationController: UINavigationController

    @discardableResult
    static func openFormSheet(
        for controller: UIViewController,
        in navigationController: NavigationController,
        barItem: UIBarButtonItem
    ) -> UIViewController {
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.navigationItem.leftBarButtonItem = barItem
            let nav = NavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .formSheet
            navigationController.present(nav, animated: true, completion: nil)
        } else {
            navigationController.pushViewController(controller, animated: true)
        }
        return controller
    }

    init(rootViewController: UIViewController = UIViewController()) {
        self.rootViewController = rootViewController
        childNavigationController = UINavigationController(rootViewController: rootViewController)
        super.init(nibName: nil, bundle: nil)
    }

    init(
        navigationBarClass: Swift.AnyClass?,
        toolbarClass: Swift.AnyClass?
    ) {
        rootViewController = UIViewController()
        childNavigationController = UINavigationController(
            navigationBarClass: navigationBarClass,
            toolbarClass: toolbarClass
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        childNavigationController.delegate = self
        childNavigationController.interactivePopGestureRecognizer?.delegate = self

        addChild(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.didMove(toParent: self)

        childNavigationController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            childNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childNavigationController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            childNavigationController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            childNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Public

    func pushCoordinator(coordinator: RootCoordinator, animated: Bool) {
        viewControllersToChildCoordinators[coordinator.rootViewController] = coordinator

        pushViewController(coordinator.rootViewController, animated: animated)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        childNavigationController.pushViewController(viewController, animated: animated)
    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        childNavigationController.dismiss(animated: flag, completion: completion)
    }

    public override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        childNavigationController.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func popViewController(animated: Bool) {
        childNavigationController.popViewController(animated: animated)
    }

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        childNavigationController.setViewControllers(viewControllers, animated: animated)
    }

    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        childNavigationController.setNavigationBarHidden(hidden, animated: animated)
    }

    func removeChildCoordinators() {
        viewControllersToChildCoordinators.removeAll()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        var preferredStyle: UIStatusBarStyle

        let rootTabBarController: UIViewController? = {
            guard let nav = ((childNavigationController.topViewController as? TabBarController)?.selectedViewController) as? UINavigationController else { return .none }
            return nav.viewControllers.isEmpty ? .none : nav.viewControllers[0]
        }()

        if
            rootTabBarController is MasterBrowserViewController ||
            childNavigationController.topViewController is MasterBrowserViewController ||
            childNavigationController.topViewController is DarkPassphraseViewController ||
            childNavigationController.topViewController is DarkVerifyPassphraseViewController ||
            childNavigationController.topViewController is WalletCreatedController {
            preferredStyle = .default
        } else {
            preferredStyle = .lightContent
        }
        return preferredStyle
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationController: Scrollable {
    func scrollOnTop() {
        if let controller = childNavigationController.viewControllers[0] as? Scrollable {
            controller.scrollOnTop()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension NavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        // Necessary to get the child navigation controller’s interactive pop gesture recognizer to work.
        return true
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    public func navigationController(_: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        cleanUpChildCoordinators()
    }

    private func cleanUpChildCoordinators() {
        for viewController in viewControllersToChildCoordinators.keys {
            if !childNavigationController.viewControllers.contains(viewController) {
                viewControllersToChildCoordinators.removeValue(forKey: viewController)
            }
        }
    }
}
