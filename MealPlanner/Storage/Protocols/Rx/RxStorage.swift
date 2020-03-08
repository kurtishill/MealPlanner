//
//  RxStorage.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation

protocol RxStorage {
    func recipeDao() -> RxRealmDao<RecipeDto>
    func ingredientDao() -> RxRealmDao<IngredientDto>
    func dateDao() -> RxRealmDao<DateDto>
    func initStorage()
}
