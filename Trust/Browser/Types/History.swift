// Copyright DApps Platform Inc. All rights reserved.
// Copyright Ether-1 Developers. All rights reserved.
// Copyright Xerom Developers. All rights reserved.

import Foundation
import RealmSwift

final class History: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var id: String = ""

    convenience init(url: String, title: String) {
        self.init()
        self.url = url
        self.title = title
        id = "\(url)|\(createdAt.timeIntervalSince1970)"
    }

    var URL: URL? {
        return Foundation.URL(string: url)
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
