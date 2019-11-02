// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class LockView: UIView {
    var characterView = UIStackView()
    var lockTitle = UILabel()
    var model: LockViewModel!
    var characters: [PasscodeCharacterView]!
    init(_ model: LockViewModel) {
        super.init(frame: CGRect.zero)
        self.model = model
        characters = passcodeCharacters()
        configCharacterView()
        configLabel()
        addUiElements()
        applyConstraints()
    }

    private func configCharacterView() {
        characterView = UIStackView(arrangedSubviews: characters)
        characterView.axis = .horizontal
        characterView.distribution = .fillEqually
        characterView.alignment = .fill
        characterView.spacing = 20
        characterView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configLabel() {
        lockTitle.font = UIFont(name: "Trenda-Regular", size: 19) ?? UIFont.systemFont(ofSize: 19)
        lockTitle.textAlignment = .center
        lockTitle.translatesAutoresizingMaskIntoConstraints = false
        lockTitle.numberOfLines = 0
    }

    private func applyConstraints() {
        characterView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        characterView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        characterView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        lockTitle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lockTitle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lockTitle.bottomAnchor.constraint(equalTo: characterView.topAnchor, constant: -20).isActive = true
    }

    private func addUiElements() {
        backgroundColor = UIColor.white
        addSubview(lockTitle)
        addSubview(characterView)
    }

    private func passcodeCharacters() -> [PasscodeCharacterView] {
        var characters = [PasscodeCharacterView]()
        for _ in 0 ..< model.charCount() {
            let passcodeCharacterView = PasscodeCharacterView()
            passcodeCharacterView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            passcodeCharacterView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            characters.append(passcodeCharacterView)
        }
        return characters
    }

    func shake() {
        let keypath = "position"
        let animation = CABasicAnimation(keyPath: keypath)
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: characterView.center.x - 10, y: characterView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: characterView.center.x + 10, y: characterView.center.y))
        characterView.layer.add(animation, forKey: keypath)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
