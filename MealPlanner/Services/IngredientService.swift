//
//  IngredientService.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class IngredientService {
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func createIngredient(_ ingredient: Ingredient, for recipe: Recipe?, week: String?) -> Bool {
        var recipeId: String? = nil
        
        if let recipe = recipe {
            recipeId = "\(recipe.category)_\(recipe.date.month.month)_\( recipe.date.day.day)_\(recipe.date.year.year)"
        }
        
        let ingredientDto = IngredientDto(id: ingredient.id.uuidString, name: ingredient.name, notes: ingredient.notes, type: ingredient.type.rawValue, isSelected: ingredient.isSelected ? 1 : 0, recipeId: recipeId, week: week)
        
        return storage.ingredientDao().createIngredient(ingredientDto)
    }
    
    func getIngredients(for recipe: String?, week: String?) -> [IngredientType:[Ingredient]]? {
        let ingredientDtos = storage.ingredientDao().getIngredients(for: recipe, week: week)
        
        var ingredients: [IngredientType:[Ingredient]] = [:]
        
        if let ids = ingredientDtos {
            for id in ids {
                let ingredient = Ingredient(id: UUID.init(uuidString: id.id)!, name: id.name, notes: id.notes, type: Helper().ingredientTypeStringToEnum(id.type), isSelected: id.isSelected == 0 ? false : true)
                
                if ingredients[Helper().ingredientTypeStringToEnum(id.type)] == nil {
                    ingredients[Helper().ingredientTypeStringToEnum(id.type)] = []
                }
                ingredients[Helper().ingredientTypeStringToEnum(id.type)]?.append(ingredient)
            }
        }
        
        return ingredients
    }
    
    func updateIngredient(_ ingredient: Ingredient) -> Bool {
        let ingredientDto = IngredientDto(id: ingredient.id.uuidString, name: ingredient.name, notes: ingredient.notes, type: ingredient.type.rawValue, isSelected: ingredient.isSelected ? 1 : 0, recipeId: "", week: "")
        
        return storage.ingredientDao().updateIngredient(ingredientDto)
    }
    
    func deleteIngredient(with id: String) -> Bool {
        return storage.ingredientDao().deleteIngredient(with: id)
    }
}
