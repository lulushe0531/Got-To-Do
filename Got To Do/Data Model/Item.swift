//
//  Item.swift
//  Got To Do
//
//  Created by lu she on 2018-04-20.
//  Copyright © 2018 lu she. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
