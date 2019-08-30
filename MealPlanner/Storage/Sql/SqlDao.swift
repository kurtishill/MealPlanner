//
//  SqlDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import SQLite3

class SqlDao {
    func handleSqliteError(op: OpaquePointer?, errMsg: String) {
        let err = String(cString: sqlite3_errmsg(op)!)
        print("\(errMsg): \(err)")
    }
}
