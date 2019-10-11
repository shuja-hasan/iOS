// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import LocalAuthentication
import UIKit

final class LockEnterPasscodeViewController: LockPasscodeViewController {
    private lazy var lockEnterPasscodeViewModel: LockEnterPasscodeViewModel = {
        self.model as! LockEnterPasscodeViewModel
    }()

    var unlockWithResult: ((_ success: Bool, _ bioUnlock: Bool) -> Void)?
    private var context: LAContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        lockView.lockTitle.text = lockEnterPasscodeViewModel.initialLabelText
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If max attempt limit is reached we should valdiate if one minute gone.
        if lock.incorrectMaxAttemptTimeIsSet() {
            lockView.lockTitle.text = lockEnterPasscodeViewModel.tryAfterOneMinute
            maxAttemptTimerValidation()
        } else {
            showBiometricAuth()
        }
    }

    func resetBiometricAuth() {
        context = LAContext()
    }

    private func showBiometricAuth() {
        context = LAContext()
        touchValidation()
    }

    func cleanUserInput() {
        clearPasscode()
    }

    override func enteredPasscode(_ passcode: String) {
        super.enteredPasscode(passcode)
        if lock.isPasscodeValid(passcode: passcode) {
            lock.resetPasscodeAttemptHistory()
            lock.removeIncorrectMaxAttemptTime()
            lockView.lockTitle.text = lockEnterPasscodeViewModel.initialLabelText
            unlock(withResult: true, bioUnlock: false)
        } else {
            let numberOfAttempts = lock.numberOfAttempts()
            let passcodeAttemptLimit = model.passcodeAttemptLimit()
            let text = String(format: NSLocalizedString("lock.enter.passcode.view.model.incorrect.passcode", value: "Incorrect passcode. You have %d attempts left.", comment: ""), passcodeAttemptLimit - numberOfAttempts)
            lockView.lockTitle.text = text
            lockView.shake()
            if numberOfAttempts >= passcodeAttemptLimit {
                exceededLimit()
                return
            }
            lock.recordIncorrectPasscodeAttempt()
        }
    }

    private func exceededLimit() {
        lockView.lockTitle.text = lockEnterPasscodeViewModel.tryAfterOneMinute
        lock.recordIncorrectMaxAttemptTime()
        hideKeyboard()
    }

    private func maxAttemptTimerValidation() {
        // if there is no recordedMaxAttemptTime user has logged successfuly previous time
        guard let maxAttemptTimer = lock.recordedMaxAttemptTime() else {
            lockView.lockTitle.text = lockEnterPasscodeViewModel.initialLabelText
            showKeyboard()
            return
        }
        let now = Date()
        let interval = now.timeIntervalSince(maxAttemptTimer)
        // if interval is greater or equal 60 seconds we give 1 attempt.
        if interval >= 60 {
            lockView.lockTitle.text = lockEnterPasscodeViewModel.initialLabelText
            showKeyboard()
        }
    }

    private func unlock(withResult success: Bool, bioUnlock: Bool) {
        hideKeyboard()
        view.endEditing(true)
        if success {
            lock.removeAutoLockTime()
        }
        if let unlock = unlockWithResult {
            unlock(success, bioUnlock)
        }
    }

    private func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    func touchValidation() {
        guard canEvaluatePolicy() else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: lockEnterPasscodeViewModel.loginReason) { [weak self] success, _ in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                if success {
                    self.lock.resetPasscodeAttemptHistory()
                    self.lock.removeIncorrectMaxAttemptTime()
                    self.lockView.lockTitle.text = self.lockEnterPasscodeViewModel.initialLabelText
                    self.unlock(withResult: true, bioUnlock: true)
                } else {
                    self.maxAttemptTimerValidation()
                }
            }
        }
    }
}
