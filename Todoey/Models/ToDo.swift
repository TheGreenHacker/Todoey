//
//  ToDo.swift
//  Todoey
//
//  Created by Jack Li on 8/22/19.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import Foundation

class ToDo {
    var text : String
    var done : Bool
    
    init(text : String, done : Bool) {
        self.text = text
        self.done = done
    }
}
