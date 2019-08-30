//
//  SqlIngredientDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import SQLite3

class SqlIngredientDao: SqlDao, IngredientDao {
    func createIngredient(_ ingredient: IngredientDto) -> Bool {
        let conn = ConnectionFactory.open()
        var stmt: OpaquePointer?
        let sql = "insert or replace into ingredients (id, name, quantity, measurementType, type, isSelected, recipe) values (?, ?, ?, ?, ?, ?, ?)"
        
        if sqlite3_prepare(conn, sql, -1, &stmt, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure preparing ingredient creation statement")
            return false
        }
        
        if sqlite3_bind_text(stmt, 1, (ingredient.id as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient id in ingredient creation")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, (ingredient.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient name in ingredient creation")
            return false
        }
        
        if sqlite3_bind_double(stmt, 3, ingredient.quantity) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient quantity in ingredient creation")
            return false
        }
        
        if sqlite3_bind_text(stmt, 4, (ingredient.measurementType as NSString?)?.utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient measurementType in ingredient creation")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, (ingredient.type as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient type in ingredient creation")
            return false
        }
        
        if sqlite3_bind_int(stmt, 6, Int32(ingredient.isSelected)) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient isSelected in ingredient creation")
            return false
        }
        
        if sqlite3_bind_text(stmt, 7, (ingredient.recipeId as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient recipeId in ingredient creation")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            self.handleSqliteError(op: conn, errMsg: "failure creating ingredient")
            return false
        }
        
        return true
    }
    
    func getIngredients(for recipe: String) -> [IngredientDto]? {
        let conn = ConnectionFactory.open()
        var stmt: OpaquePointer?
        let sql = "select * from ingredients where recipe = ?"
        
        var ingredients = [IngredientDto]()
        
        if sqlite3_prepare(conn, sql, -1, &stmt, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "error preparing retrieval")
            return nil
        }
        
        if sqlite3_bind_text(stmt, 1, (recipe as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "error binding recipe id")
            return nil
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = String(cString: sqlite3_column_text(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let quantity = sqlite3_column_double(stmt, 2)
            let mt = sqlite3_column_text(stmt, 3)
            let measurementType = mt != nil ? String(cString: mt!) : ""
            let type = String(cString: sqlite3_column_text(stmt, 4))
            let isSelected = sqlite3_column_int(stmt, 5)
            
            let ingredientDto = IngredientDto(id: String(describing: id), name: String(describing: name), quantity: Double(quantity), measurementType: String(describing: measurementType), type: String(describing: type), isSelected: Int(isSelected), recipeId: recipe)
            
            ingredients.append(ingredientDto)
        }
        
        return ingredients
    }
    
    func updateIngredient(_ ingredient: IngredientDto) -> Bool {
        let conn = ConnectionFactory.open()
        var stmt: OpaquePointer?
        let sql = "update ingredients set isSelected = ? where id = ?"
        
        if sqlite3_prepare(conn, sql, -1, &stmt, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure preparing ingredient update statement")
            return false
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(ingredient.isSelected)) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "failure binding ingredient isSelected in ingredient update")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, (ingredient.id as NSString).utf8String, -1, nil) != SQLITE_OK {
            self.handleSqliteError(op: conn, errMsg: "error binding ingredient id")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            self.handleSqliteError(op: conn, errMsg: "failure updating ingredient")
            return false
        }
        
        return true
    }
}
