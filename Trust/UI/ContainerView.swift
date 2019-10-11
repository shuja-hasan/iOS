// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import UIKit

final class ContainerView: UIView {
    public init(innerView: UIView, layoutMargins: UIEdgeInsets) {
        super.init(frame: .zero)

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.preservesSuperviewLayoutMargins = true
        containerView.layoutMargins = layoutMargins
        containerView.addSubview(innerView)
        addSubview(containerView)

        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.preservesSuperviewLayoutMargins = true

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),

            innerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            innerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            innerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            innerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
