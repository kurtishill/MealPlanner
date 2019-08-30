//
//  StorageProtocol.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

protocol Storage {
    func recipeDao() -> RecipeDao
    func ingredientDao() -> IngredientDao
    func initStorage() -> Bool
}
