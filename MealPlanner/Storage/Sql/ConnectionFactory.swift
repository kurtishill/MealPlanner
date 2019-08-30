//
//  ConnectionFactory.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import SQLite3

class ConnectionFactory {
    static var db: OpaquePointer?
    
    static func open() -> OpaquePointer? {
        let fileUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("MealPlanner.sqlite")
        
        print(fileUrl!.path)
        
        if sqlite3_open(fileUrl?.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        return db
    }
}
