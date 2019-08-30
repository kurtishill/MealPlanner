//
//  RecipeDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import SQLite3

class SqlRecipeDao: SqlDao, RecipeDao {
    func createRecipe(_ recipe: RecipeDto) -> Bool {
        let conn = ConnectionFactory.open()
        var stmt: OpaquePointer?
        let sql = "insert or replace into recipes (id, category, title, year, month, day) values (?, ?, ?, ?, ?, ?)"
        
        if sqlite3_prepare(conn, sql, -1, &stmt, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure preparing recipe creation statement")
            return false
        }
        
        if sqlite3_bind_text(stmt, 1, (recipe.id as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding recipe id in recipe creation")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, (recipe.category as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding recipe category in recipe creation")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, (recipe.title as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding recipe id in recipe creation")
            return false
        }
        
        if sqlite3_bind_int(stmt, 4, Int32(recipe.year)) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding recipe year in recipe creation")
            return false
        }
        
        if sqlite3_bind_int(stmt, 5, Int32(recipe.month)) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding recipe month in recipe creation")
            return false
        }
        
        if sqlite3_bind_int(stmt, 6, Int32(recipe.day)) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding recipe day in recipe creation")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            self.handleSqliteError(op: conn, errMsg: "failure creating recipe")
            return false
        }
        
        return true
    }
    
    func getAllRecipesForWeek(with date: CalendarDate) -> [RecipeDto]? {
        let conn = ConnectionFactory.open()
        
        // gets all meals for this day
        let sql = "select * from recipes where (year = ? and month = ? and day = ?)"
        
        var recipeDtos = [RecipeDto]()
        for day in date.week.week {
            var stmt: OpaquePointer?
            
            if sqlite3_prepare(conn, sql, -1, &stmt, nil) != SQLITE_OK {
                self.handleSqliteError(op: conn, errMsg: "error preparing retrieval")
                return nil
            }
            
            if sqlite3_bind_int(stmt, 1, Int32(date.year.year)) != SQLITE_OK {
                self.handleSqliteError(op: conn, errMsg: "error binding year")
                return nil
            }
            
            if sqlite3_bind_int(stmt, 2, Int32(date.month.month)) != SQLITE_OK {
                self.handleSqliteError(op: conn, errMsg: "error binding month")
                return nil
            }
            
            if sqlite3_bind_int(stmt, 3, Int32(day.day)) != SQLITE_OK {
                self.handleSqliteError(op: conn, errMsg: "error binding day")
                return nil
            }
            
            
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                let category = String(cString: sqlite3_column_text(stmt, 1))
                let title = String(cString: sqlite3_column_text(stmt, 2))
                let month = sqlite3_column_int(stmt, 3)
                let day = sqlite3_column_int(stmt, 4)
                let year = sqlite3_column_int(stmt, 5)
                
                let recipeDto = RecipeDto(category: String(describing: category), title: String(describing: title), year: Int(year), month: Int(month), day: Int(day))
                
                recipeDtos.append(recipeDto)
            }
        }
        
        return recipeDtos
    }
}
