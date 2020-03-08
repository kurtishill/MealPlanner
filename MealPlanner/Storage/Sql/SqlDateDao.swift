////
////  SqlDateDao.swift
////  MealPlanner
////
////  Created by Kurtis Hill on 2/22/20.
////  Copyright © 2020 Kurtis Hill. All rights reserved.
////
//
//import Foundation
//import SQLite3
//import RxSwift
//
//class SqlDateDao: SqlDao, DateDao {
//    func createDate(_ date: DateDto) -> Single<Bool> {
//        let conn = ConnectionFactory.open()
//        var stmt: OpaquePointer?
//        let sql = "insert ingore into dates (id, month, day, year) values (?, ?, ?, ?)"
//
//        if sqlite3_prepare(conn, sql, -1, &stmt, nil) != SQLITE_OK {
//            self.handleSqliteError(op: conn, errMsg: "failure preparing date creation statement")
//            return Single.just(false)
//        }
//
//        if sqlite3_bind_text(stmt, 1, (date.id as NSString).utf8String, -1, nil) != SQLITE_OK {
//            self.handleSqliteError(op: conn, errMsg: "failure binding recipe id in recipe creation")
//            return Single.just(false)
//        }
//
//        if sqlite3_bind_int(stmt, 2, Int32(date.month)) != SQLITE_OK {
//            self.handleSqliteError(op: conn, errMsg: "failure binding date month in date creation")
//            return Single.just(false)
//        }
//
//        if sqlite3_bind_int(stmt, 3, Int32(date.day)) != SQLITE_OK {
//            self.handleSqliteError(op: conn, errMsg: "failure binding date day in date creation")
//            return Single.just(false)
//        }
//
//        if sqlite3_bind_int(stmt, 4, Int32(date.year)) != SQLITE_OK {
//            self.handleSqliteError(op: conn, errMsg: "failure binding date year in adte creation")
//            return Single.just(false)
//        }
//
//        if sqlite3_step(stmt) != SQLITE_DONE {
//            self.handleSqliteError(op: conn, errMsg: "failure creating date")
//            return Single.just(false)
//        }
//
//        return Single.just(true)
//    }
//}
