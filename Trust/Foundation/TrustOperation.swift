// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class TrustOperation: Operation {
    enum KVOProperties {
        static let isFinished = "isFinished"
        static let isExecuting = "isExecuting"
    }

    private var _finished = false
    private var _isExecuting = false

    public override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: KVOProperties.isFinished)
            _finished = newValue
            didChangeValue(forKey: KVOProperties.isFinished)
        }
    }

    public override var isExecuting: Bool {
        get { return _isExecuting }
        set {
            willChangeValue(forKey: KVOProperties.isExecuting)
            _isExecuting = newValue
            didChangeValue(forKey: KVOProperties.isExecuting)
        }
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }

    override func start() {
        if isCancelled {
            finish()

        } else {
            isExecuting = true
            main()
        }
    }
}
