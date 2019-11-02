// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class TokensFooterView: UIView {
    lazy var emptyWalletImageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(named: "empty_wallet_icon")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var createButton: Button = {
        let createButton = Button(size: .large, style: .squared)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 6
        createButton.setTitle("Create", for: .normal) // R.string.localizable.send()
        createButton.accessibilityIdentifier = "create-button"
        createButton.titleLabel?.font = UIFont(name: "Trenda-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        return createButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [
            emptyWalletImageView,
            textLabel,
            createButton,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        addSubview(stackView)

        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(equalToConstant: 150),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: StyleLayout.sideMargin),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -StyleLayout.sideMargin),
        ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
