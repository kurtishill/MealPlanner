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
    @objc dynamic var category: String = ""
    @objc dynamic var title: String = ""
    let ingredients = List<IngredientDto>()
    let date = LinkingObjects(fromType: DateDto.self, property: "recipes")
    
    static func make(from recipe: Recipe) -> RecipeDto {
        let recipeDto = RecipeDto()
        recipeDto.id = recipe.id.uuidString
        recipeDto.category = recipe.category.rawValue
        recipeDto.title = recipe.title
        
        return recipeDto
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func make(id: String, category: String, title: String, ingredients: [IngredientDto]) -> RecipeDto {
        let dto = RecipeDto()
        dto.id = id
        dto.category = category
        dto.title = title
        dto.ingredients.append(objectsIn: ingredients)
        
        return dto
    }
}
