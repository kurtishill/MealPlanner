//
//  RecipeProtocol.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

protocol RecipeDao {
//    func getRecipe(for date: CalendarDate, category: String) -> RecipeDto?
//    func getAllRecipes(for date: CalendarDate) -> [RecipeDto]?
    func createRecipe(_ recipe: RecipeDto) -> Bool
    func getAllRecipesForWeek(with date: CalendarDate) -> [RecipeDto]?
    
}
