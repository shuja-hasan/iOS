// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class TokenHeaderView: UIView {
    private struct Layout {
        static let imageSize: CGFloat = 70
    }

    lazy var amountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Colors.black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var marketPriceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var totalAmountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var fiatAmountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Colors.black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var imageView: TokenImageView = {
        let imageView = TokenImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var buttonsView: ButtonsFooterView = {
        let footerView = ButtonsFooterView(
            frame: .zero,
            bottomOffset: 5
        )
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.setBottomBorder()
        return footerView
    }()

    lazy var allButton: Button = {
        let sendButton = Button(size: .large, style: .squared)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.layer.cornerRadius = 6
        sendButton.setTitle("All", for: .normal)
//        sendButton.accessibilityIdentifier = "send-button"
        sendButton.titleLabel?.font = UIFont(name: "Trenda-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        return sendButton
    }()

    lazy var sendButton: Button = {
        let sendButton = Button(size: .large, style: .squared)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.layer.cornerRadius = 6
        sendButton.setTitle(R.string.localizable.send(), for: .normal)
        sendButton.accessibilityIdentifier = "send-button"
        sendButton.titleLabel?.font = UIFont(name: "Trenda-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        return sendButton
    }()

    lazy var recieveButton: Button = {
        let sendButton = Button(size: .large, style: .squared)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.layer.cornerRadius = 6
        sendButton.setTitle(NSLocalizedString("transactions.receive.button.title", value: "Receive", comment: ""), for: .normal)
        sendButton.accessibilityIdentifier = "recieve-button"
        sendButton.titleLabel?.font = UIFont(name: "Trenda-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        return sendButton
    }()

    lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill // .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    let percentChange = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let amountStack = UIStackView(arrangedSubviews: [amountLabel, fiatAmountLabel])
        amountStack.translatesAutoresizingMaskIntoConstraints = false
        amountStack.axis = .horizontal
        amountStack.distribution = .fillEqually

        let marketPriceStack = UIStackView(arrangedSubviews: [
            marketPriceLabel,
            .spacerWidth(5, backgroundColor: UIColor.clear, alpha: 0, priority: UILayoutPriority(rawValue: 999)),
            percentChange,
        ])
        marketPriceStack.translatesAutoresizingMaskIntoConstraints = false
        marketPriceStack.axis = .horizontal
        marketPriceStack.distribution = .equalSpacing
        marketPriceStack.spacing = 0

        let bottomButtonStack = UIStackView(arrangedSubviews: [allButton, sendButton, recieveButton])
        bottomButtonStack.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 0

        let buttonsContainer = UIView()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.addSubview(buttonsView)

        container.addArrangedSubview(.spacer(height: StyleLayout.sideMargin * 2))
        container.addArrangedSubview(imageView)
        container.addArrangedSubview(.spacer(height: 12))
        container.addArrangedSubview(amountStack)
        container.addArrangedSubview(.spacer(height: 12))
        container.addArrangedSubview(marketPriceStack)
        container.addArrangedSubview(.spacer(height: 12))
        addSubview(buttonsContainer)
//        container.addArrangedSubview(buttonsContainer)
        container.addArrangedSubview(.spacer(height: 60))
        container.addArrangedSubview(bottomButtonStack)
        addSubview(container)

        let buttonsViewLeading = buttonsView.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor),

            buttonsContainer.topAnchor.constraint(equalTo: container.bottomAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            buttonsContainer.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),

            buttonsView.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor),

            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: Layout.imageSize),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: Layout.imageSize),
        ])

        buttonsViewLeading.priority = UILayoutPriority(rawValue: 999)
        buttonsViewLeading.isActive = true

        backgroundColor = Colors.veryVeryLightGray
        buttonsView.backgroundColor = Colors.veryVeryLightGray
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoundedButtons: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
