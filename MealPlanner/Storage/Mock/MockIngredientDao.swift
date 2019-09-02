//
//  MockIngredientDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class MockIngredientDao: IngredientDao {
    func createIngredient(_ ingredient: IngredientDto) -> Bool {
        return true
    }
    
    func getIngredients(for recipe: String?, week: String?) -> [IngredientDto]? {
        return nil
    }
    
    func updateIngredient(_ ingredient: IngredientDto) -> Bool {
        return true
    }
    
    func deleteIngredient(with id: String) -> Bool {
        return true
    }
}
