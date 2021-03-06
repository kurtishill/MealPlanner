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
            lhs.type == rhs.type
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Ingredient(id: self.id, name: self.name, notes: self.notes, type: self.type, isSelected: self.isSelected)
        return copy
    }
}
