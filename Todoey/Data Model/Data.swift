//
//  Data.swift
//  Todoey
//
//  Created by ravizza on 5/30/18.
//  Copyright © 2018 ravizza. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
