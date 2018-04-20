//
//  Category.swift
//  Got To Do
//
//  Created by lu she on 2018-04-20.
//  Copyright © 2018 lu she. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
