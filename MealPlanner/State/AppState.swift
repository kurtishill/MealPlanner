//
//  RecipeClass.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    var objectWillChange = PassthroughSubject<AppState, Never>()
    
    // key is day of week
    var weekRecipes: [Int:[Recipe.Category:Recipe?]]
    
    var date: CalendarDate {
        didSet {
            self.weekRecipes = self.recipeService.getAllRecipesForWeek(with: date)
        }
    }
    
    let recipeService: RecipeService
    let ingredientService: IngredientService
    
    init(date: CalendarDate, recipeService: RecipeService, ingredientService: IngredientService) {
        self.date = date
        self.recipeService = recipeService
        self.ingredientService = ingredientService
        
        self.weekRecipes = self.recipeService.getAllRecipesForWeek(with: date)
    }
    
    func getRecipe(for day: Int, with category: Recipe.Category) -> Recipe? {
        return self.weekRecipes[day]![category] ?? nil
    }
    
    func getIngredientsForWeekDisplay() -> [Ingredient.IngredientType:[Ingredient]] {
        var ingredients: [Ingredient.IngredientType:[Ingredient]] = [:]
        
        for (_, value) in self.weekRecipes {
            for (_, recipe) in value/*.sorted(by: {$0.key.rawValue < $1.key.rawValue}) */{
                if let r = recipe {
                    for (type, i) in r.ingredients/*.sorted(by: {$0.key < $1.key}) */{
                        if ingredients[type] == nil {
                            ingredients[type] = [Ingredient]()
                        }
                        ingredients[type] = i
                    }
                }
            }
        }
        
        return ingredients
    }
    
    func updateRecipe(_ recipe: Recipe) {
        let day = recipe.date.day.day
        
        self.weekRecipes[day]![recipe.category] = recipe
        
        objectWillChange.send(self)
        
        let _ = self.recipeService.createRecipe(recipe)
        
        for (_, value) in recipe.ingredients {
            for ingredient in value {
                let _ = self.ingredientService.createIngredient(ingredient, for: recipe)
            }
        }
    }
    
    func updateIngredient(_ ingredient: Ingredient) {
        let _ = self.ingredientService.updateIngredient(ingredient)
        objectWillChange.send(self)
    }
}
