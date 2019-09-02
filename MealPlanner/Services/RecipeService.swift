//
//  RecipeService.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class RecipeService {
    private let storage: Storage
    private let ingredientService: IngredientService
    
    init(storage: Storage, ingredientService: IngredientService) {
        self.storage = storage
        self.ingredientService = ingredientService
    }
    
    func createRecipe(_ recipe: Recipe) -> Bool {
        let recipeDto = RecipeDto(category: recipe.category.rawValue, title: recipe.title, year: recipe.date.year.year, month: recipe.date.month.month, day: recipe.date.day.day)
        return storage.recipeDao().createRecipe(recipeDto)
    }
    
    func getAllRecipesForWeek(with date: CalendarDate) -> [Int:[Recipe.Category:Recipe]] {
        let recipeDtos = storage.recipeDao().getAllRecipesForWeek(with: date)
        
        var dict: [Int:[Recipe.Category:Recipe]] = [:]
        
        for day in date.week.week {
            dict[day.day] = [:]
        }
        
        if let rcs = recipeDtos {
            for recipeDto in rcs {
                
                let ingredientsForRecipe = self.ingredientService.getIngredients(for: recipeDto.id, week: nil)
                
                let d = date
                d.day = CalendarDay(day: recipeDto.day)
                let recipe = Recipe(category: Helper().categoryStringToEnum(recipeDto.category), title: recipeDto.title, ingredients: ingredientsForRecipe ?? [:], date: d)
                
                dict[recipe.date.day.day]![recipe.category] = recipe
            }
        }
        
        return dict
    }
}
