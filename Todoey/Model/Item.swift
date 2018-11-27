//
//  Item.swift
//  Todoey
//
//  Created by Chot on 25/11/2018.
//  Copyright © 2018 Kelvin Chot. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
