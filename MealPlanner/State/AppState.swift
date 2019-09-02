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
    @Published var itemsForWeek: [IngredientType:[Ingredient]]
    
    var date: CalendarDate {
        didSet {
            self.weekRecipes = self.recipeService.getAllRecipesForWeek(with: date)
            self.itemsForWeek = self.ingredientService.getIngredients(for: nil, week: "\(self.date.month.month)_\(self.date.week.week.first!.day)-\(self.date.week.week.last!.day)_\(self.date.year.year)")!
        }
    }
    
    let recipeService: RecipeService
    let ingredientService: IngredientService
    
    init(date: CalendarDate, recipeService: RecipeService, ingredientService: IngredientService) {
        self.date = date
        self.recipeService = recipeService
        self.ingredientService = ingredientService
        
        self.weekRecipes = self.recipeService.getAllRecipesForWeek(with: date)
        self.itemsForWeek = self.ingredientService.getIngredients(for: nil, week: "\(self.date.month.month)_\(self.date.week.week.first!.day)-\(self.date.week.week.last!.day)_\(self.date.year.year)")!
    }
    
    func getRecipe(for day: Int, with category: Recipe.Category) -> Recipe? {
        return self.weekRecipes[day]![category] ?? nil
    }
    
    func getIngredientsForWeekDisplay() -> [IngredientType:[Ingredient]] {
        var ingredients: [IngredientType:[Ingredient]] = [:]
        
//        let ingredientsForOnlyWeek = self.ingredientService.getIngredients(for: nil, week: "\(self.date.month.month)_\(self.date.week.id)_\(self.date.year.year)")
        
//        ingredients.merge(ingredientsForOnlyWeek!) { (_, new) in new }
        
        ingredients.merge(self.itemsForWeek) { (_, new) in new }
        
        for (_, value) in self.weekRecipes {
            for (_, recipe) in value/*.sorted(by: {$0.key.rawValue < $1.key.rawValue}) */{
                if let r = recipe {
                    for (type, i) in r.ingredients/*.sorted(by: {$0.key < $1.key}) */{
                        if ingredients[type] == nil {
                            ingredients[type] = [Ingredient]()
                        }
                        ingredients[type]?.append(contentsOf: i)
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
                let _ = self.ingredientService.createIngredient(ingredient, for: recipe, week: nil)
            }
        }
    }
    
    func createIngredientForWeek(_ ingredient: Ingredient) {
        let _ = self.ingredientService.createIngredient(ingredient, for: nil, week: "\(self.date.month.month)_\(self.date.week.week.first!.day)-\(self.date.week.week.last!.day)_\(self.date.year.year)")
        objectWillChange.send(self)
    }
    
    func updateIngredient(_ ingredient: Ingredient) {
        let _ = self.ingredientService.updateIngredient(ingredient)
        objectWillChange.send(self)
    }
    
    func deleteIngredient(with id: String) {
        let _ = self.ingredientService.deleteIngredient(with: id)
    }
}
