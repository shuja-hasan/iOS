// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import MBProgressHUD
import Result
import SafariServices
import UIKit

enum ConfirmationError: LocalizedError {
    case cancel
}

extension UIViewController {
    func displayError(error: Error) {
        let alertController = UIAlertController(title: error.prettyError, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.popoverPresentationController?.sourceView = view
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(), style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func confirm(
        title: String? = .none,
        message: String? = .none,
        okTitle: String = R.string.localizable.oK(),
        okStyle: UIAlertAction.Style = .default,
        completion: @escaping (Result<Void, ConfirmationError>) -> Void
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = view
        alertController.addAction(UIAlertAction(title: okTitle, style: okStyle, handler: { _ in
            completion(.success(()))
        }))
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: { _ in
            completion(.failure(ConfirmationError.cancel))
        }))
        present(alertController, animated: true, completion: nil)
    }

    func displayLoading(
        text: String = String(format: NSLocalizedString("loading.dots", value: "Loading %@", comment: ""), "..."),
        animated: Bool = true
    ) {
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.label.text = text
    }

    func hideLoading(animated: Bool = true) {
        MBProgressHUD.hide(for: view, animated: animated)
    }

    func openURL(_ url: URL) {
        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = Colors.newDesignNavBarBlue // .darkRed
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true, completion: nil)
    }

    func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func showShareActivity(from sender: UIView, with items: [Any], completion: (() -> Swift.Void)? = nil) {
        let activityViewController = UIActivityViewController.make(items: items)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.centerRect
        present(activityViewController, animated: true, completion: completion)
    }
}
