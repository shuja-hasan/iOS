// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class LockCreatePasscodeViewController: LockPasscodeViewController {
    private lazy var lockCreatePasscodeViewModel: LockCreatePasscodeViewModel? = {
        self.model as? LockCreatePasscodeViewModel
    }()

    private var firstPasscode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = lockCreatePasscodeViewModel?.title
        lockView.lockTitle.text = lockCreatePasscodeViewModel?.initialLabelText
    }

    override func enteredPasscode(_ passcode: String) {
        super.enteredPasscode(passcode)
        if let first = firstPasscode {
            if passcode == first {
                lock.setPasscode(passcode: passcode)
                finish(withResult: true, animated: true)
            } else {
                lockView.shake()
                firstPasscode = nil
                showFirstPasscodeView()
            }
        } else {
            firstPasscode = passcode
            showConfirmPasscodeView()
        }
    }

    private func showFirstPasscodeView() {
        lockView.lockTitle.text = lockCreatePasscodeViewModel?.initialLabelText
    }

    private func showConfirmPasscodeView() {
        lockView.lockTitle.text = lockCreatePasscodeViewModel?.confirmLabelText
    }
}
