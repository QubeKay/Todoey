//
//  Category.swift
//  Todoey
//
//  Created by Chot on 25/11/2018.
//  Copyright © 2018 Kelvin Chot. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
