//
//  ToDo.swift
//  Todoey
//
//  Created by Jack Li on 8/29/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object {
    @objc dynamic var text = ""
    @objc dynamic var done = false
    @objc dynamic var date = Date()
    let category = LinkingObjects(fromType: Category.self, property: "toDos")
    /*
    override static func primaryKey() -> String? {
        return "text"
    }
    */
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
