// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class LockPasscodeViewController: UIViewController {
    var willFinishWithResult: ((_ success: Bool) -> Void)?
    let model: LockViewModel
    var lockView: LockView!
    let lock: Lock
    private var invisiblePasscodeField = UITextField()
    private var shouldIgnoreTextFieldDelegateCalls = false
    init(model: LockViewModel, lock: Lock = Lock()) {
        self.model = model
        self.lock = lock
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        view.backgroundColor = UIColor.white
        configureInvisiblePasscodeField()
        configureLockView()
        if !invisiblePasscodeField.isFirstResponder, !lock.incorrectMaxAttemptTimeIsSet() {
            if !lock.shouldShowProtection() {
                invisiblePasscodeField.becomeFirstResponder()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if invisiblePasscodeField.isFirstResponder {
            invisiblePasscodeField.resignFirstResponder()
        }
    }

    public func configureInvisiblePasscodeField() {
        invisiblePasscodeField = UITextField()
        invisiblePasscodeField.keyboardType = .numberPad
        invisiblePasscodeField.isSecureTextEntry = true
        invisiblePasscodeField.delegate = self
        invisiblePasscodeField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(invisiblePasscodeField)
    }

    public func configureLockView() {
        lockView = LockView(model)
        lockView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lockView)
        lockView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lockView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lockView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        lockView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    @objc func enteredPasscode(_: String) {
        shouldIgnoreTextFieldDelegateCalls = false
        clearPasscode()
    }

    func clearPasscode() {
        invisiblePasscodeField.text = ""
        if lockView != nil {
            for characterView in lockView.characters {
                characterView.setEmpty(true)
            }
        }
    }

    func hideKeyboard() {
        if invisiblePasscodeField.isFirstResponder {
            invisiblePasscodeField.resignFirstResponder()
        }
    }

    func showKeyboard() {
        invisiblePasscodeField.becomeFirstResponder()
    }

    func finish(withResult success: Bool, animated _: Bool) {
        if invisiblePasscodeField.isFirstResponder {
            invisiblePasscodeField.resignFirstResponder()
        }
        if let finish = willFinishWithResult {
            finish(success)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.lockView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardSize.height).isActive = true
                })
            }
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LockPasscodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if shouldIgnoreTextFieldDelegateCalls {
            return false
        }
        let newString: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let newLength: Int = newString?.count ?? 0
        if newLength > model.charCount() {
            lockView.shake()
            textField.text = ""
            return false
        } else {
            for characterView in lockView.characters {
                let index: Int = lockView.characters.firstIndex(of: characterView)!
                characterView.setEmpty(index >= newLength)
            }
            return true
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if shouldIgnoreTextFieldDelegateCalls {
            return
        }
        let newString: String? = textField.text
        let newLength: Int = newString?.count ?? 0
        if newLength == model.charCount() {
            shouldIgnoreTextFieldDelegateCalls = true
            textField.text = ""
            perform(#selector(enteredPasscode), with: newString, afterDelay: 0.3)
        }
    }
}
