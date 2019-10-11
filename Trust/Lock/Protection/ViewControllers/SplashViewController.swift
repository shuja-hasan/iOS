// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private var splashView = SplashView()
    init() {
        super.init(nibName: nil, bundle: nil)
        splashView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashView)
        NSLayoutConstraint.activate([
            splashView.topAnchor.constraint(equalTo: view.topAnchor),
            splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
