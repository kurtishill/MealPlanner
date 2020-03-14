//
//  RecipeDto.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift

class RecipeDto: Object, BaseDto {
    @objc dynamic var id: String = ""
    @objc dynamic var shoppingList: String = ""
    let ingredients = List<IngredientDto>()
    let date = LinkingObjects(fromType: DateDto.self, property: "recipes")
    
    static func make(from recipe: Recipe) -> RecipeDto {
        let recipeDto = RecipeDto()
        recipeDto.id = recipe.id.uuidString
        recipeDto.shoppingList = recipe.shoppingList.type
        
        return recipeDto
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func make(id: String, shoppingList: String, ingredients: [IngredientDto]) -> RecipeDto {
        let dto = RecipeDto()
        dto.id = id
        dto.shoppingList = shoppingList
        dto.ingredients.append(objectsIn: ingredients)
        
        return dto
    }
    
    func getChildrenObjects<T>() -> List<T>? where T : BaseDto {
        ingredients.forEach { (ing) in
            print(ing.name)
        }
        return ingredients as? List<T>
    }
}
