//
//  Item.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-24.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var creadtedDate : Date?
    //colour of the cell
    @objc dynamic var cellColour = ""
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
