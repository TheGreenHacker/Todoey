//
//  Category.swift
//  Todoey
//
//  Created by Jack Li on 8/29/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var text = ""
    @objc dynamic var hexString: String? // for persisting color property
    let toDos = List<ToDo>()
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
