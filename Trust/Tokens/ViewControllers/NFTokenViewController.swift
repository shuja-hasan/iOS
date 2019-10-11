// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import Kingfisher
import StackViewController
import UIKit

protocol NFTokenViewControllerDelegate: class {
    func didPressLink(url: URL, in viewController: NFTokenViewController)
}

final class NFTokenViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var sendButton: UIButton = {
        let sendButton = Button(size: .normal, style: .border)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle(viewModel.sendButtonTitle, for: .normal)
        sendButton.addTarget(self, action: #selector(sendTap), for: .touchUpInside)
        return sendButton
    }()

    let token: CollectibleTokenObject
    let server: RPCServer

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: viewModel.placeholder
        )
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var viewModel: NFTDetailsViewModel = {
        NFTDetailsViewModel(token: token, server: server)
    }()

    weak var delegate: NFTokenViewControllerDelegate?

    init(token: CollectibleTokenObject, server: RPCServer) {
        self.token = token
        self.server = server
        super.init(nibName: nil, bundle: nil)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.title
        titleLabel.textColor = UIColor.black

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.textColor = UIColor.lightGray

        let internalButton = Button(size: .normal, style: .border)
        internalButton.translatesAutoresizingMaskIntoConstraints = false
        internalButton.setTitle(viewModel.internalButtonTitle, for: .normal)
        internalButton.addTarget(self, action: #selector(internalTap), for: .touchUpInside)

        let externalButton = Button(size: .normal, style: .border)
        externalButton.translatesAutoresizingMaskIntoConstraints = false
        externalButton.setTitle(viewModel.externalButtonTitle, for: .normal)
        externalButton.addTarget(self, action: #selector(externalTap), for: .touchUpInside)

        view.backgroundColor = .white
        title = viewModel.title
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(.spacer(height: 15))
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(.spacer(height: 15))
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(.spacer(height: 15))
        // stackView.addArrangedSubview(sendButton)
        // stackView.addArrangedSubview(.spacer(height: 15))
        stackView.addArrangedSubview(internalButton)
        stackView.addArrangedSubview(.spacer(height: 10))
        stackView.addArrangedSubview(externalButton)
        stackView.addArrangedSubview(.spacer(height: 10))

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 260),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
        ])
    }

    @objc func sendTap() {}

    @objc func internalTap() {
        guard let url = viewModel.internalURL else { return }
        delegate?.didPressLink(url: url, in: self)
    }

    @objc func externalTap() {
        guard let url = viewModel.externalURL else { return }
        delegate?.didPressLink(url: url, in: self)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
