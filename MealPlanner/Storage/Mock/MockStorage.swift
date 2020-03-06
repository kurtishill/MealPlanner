//
//  MockStorage.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class MockStorage: Storage, ObservableObject {
    private var mockRecipeDao: RecipeDao
    private var mockIngredientDao: IngredientDao
    
    init() {
        self.mockRecipeDao = MockRecipeDao()
        self.mockIngredientDao = MockIngredientDao()
    }
    
    func recipeDao() -> RecipeDao {
        return self.mockRecipeDao
    }
    
    func ingredientDao() -> IngredientDao {
        return self.mockIngredientDao
    }
    
    func initStorage() -> Bool {
        return true
    }
}
