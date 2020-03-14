//
//  IngredientDto.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift

class IngredientDto: Object, BaseDto {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var notes: String?
    @objc dynamic var type: String = ""
    @objc dynamic var isSelected: Int = 0
    var recipe = LinkingObjects(fromType: RecipeDto.self, property: "ingredients")
    
    static func make(from ingredient: Ingredient) -> IngredientDto {
        let ingredientDto = IngredientDto()
        ingredientDto.id = ingredient.id.uuidString
        ingredientDto.name = ingredient.name
        ingredientDto.notes = ingredient.notes
        ingredientDto.type = ingredient.type.rawValue
        ingredientDto.isSelected = ingredient.isSelected ? 1 : 0
        
        return ingredientDto
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func getChildrenObjects<T>() -> List<T>? where T : BaseDto {
        return nil
    }
}
