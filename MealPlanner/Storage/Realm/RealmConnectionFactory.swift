//
//  ConnectionFactory.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConnectionFactory {
//    static var realm: Realm?
    
    static func create() -> Realm {
        return try! Realm()
//        if realm?.isInWriteTransaction ?? false {
//            realm = try! Realm()
//        }
//        return try! realm ?? Realm()
    }
}
