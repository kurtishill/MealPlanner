//
//  RealmStorage.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import SQLite3

fileprivate let RECIPE_CREATE_STATEMENT = """
create table if not exists recipes (
id text primary key not null,
category text not null,
title text not null,
month integer not null,
day integer not null,
year integer not null
);
"""

fileprivate let INGREDIENT_CREATE_STATEMENT = """
create table if not exists ingredients (
id text primary key not null,
name text not null,
notes text,
type text not null,
isSelected integer not null,
recipeId text,
week text
);
"""

class SqlStorage: Storage {
    private var sqlRecipeDao: RecipeDao
    private var sqlIngredientDao: IngredientDao
    
    init() {
        self.sqlRecipeDao = SqlRecipeDao()
        self.sqlIngredientDao = SqlIngredientDao()
    }
    
    func recipeDao() -> RecipeDao {
        return self.sqlRecipeDao
    }
    
    func ingredientDao() -> IngredientDao {
        return self.sqlIngredientDao
    }
    
    func initStorage() -> Bool {
        let conn = ConnectionFactory.open()
        
        if sqlite3_exec(conn, "\(RECIPE_CREATE_STATEMENT)\(INGREDIENT_CREATE_STATEMENT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(conn)!)
            print("error creating table: \(err)")
            return false
        }
        
        return true
    }
}
