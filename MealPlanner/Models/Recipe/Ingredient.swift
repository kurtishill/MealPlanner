//
//  Ingredient.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import Combine

class Ingredient: NSObject, NSCopying {
    var id: UUID
    var name: String
    var notes: String?
    let type: IngredientType
    var isSelected: Bool
    
    init(id: UUID = UUID(), name: String, notes: String?, type: IngredientType, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.notes = notes
        self.type = type
        self.isSelected = isSelected
    }
    
    func toggleSelected() {
        isSelected.toggle()
    }
    
    func update(_ ingredient: Ingredient) {
        self.isSelected = ingredient.isSelected
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return
            lhs.id.uuidString == rhs.id.uuidString &&
            lhs.name == rhs.name &&
            lhs.notes == rhs.notes &&
            lhs.type == rhs.type &&
            lhs.isSelected == rhs.isSelected
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object == nil { return false }
        if !(object.self is Ingredient) { return false }
        
        let o = object as! Ingredient
        
        return
            o.id.uuidString == self.id.uuidString &&
                o.isSelected == self.isSelected
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Ingredient(id: self.id, name: self.name, notes: self.notes, type: self.type, isSelected: self.isSelected)
        return copy
    }
    
    static func make(from ingredientDto: IngredientDto) -> Ingredient {
        return Ingredient(
            id: UUID.init(uuidString: ingredientDto.id)!,
            name: ingredientDto.name,
            notes: ingredientDto.notes,
            type: Helper.ingredientTypeStringToEnum(ingredientDto.type),
            isSelected: ingredientDto.isSelected == 1
        )
    }
}
