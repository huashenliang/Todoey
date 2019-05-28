//
//  Category.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-24.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import Foundation
import RealmSwift

//by subclassing 'Object' class, able to save the data using realm
class Category: Object {
    
    //specify the porperty
    @objc dynamic var name = ""
    
    //colour of the cell
    @objc dynamic var cellColour = ""
    
    //inside each category, 'items' is going to point to a list of item object
    let items = List<Item>()
}
