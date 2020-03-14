//
//  Recipe.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import Combine

class Recipe: NSObject, ObservableObject, NSCopying, Identifiable {
    var objectWillChange = PassthroughSubject<Recipe, Never>()
    
    var id: UUID = UUID()
    var shoppingList: ShoppingList = ShoppingList(type: "")
    var ingredients: [IngredientType:[Ingredient]] = [:]
    var date: CalendarDate
    
    init(id: UUID?, shoppingList: ShoppingList, ingredients: [IngredientType:[Ingredient]], date: CalendarDate) {
        self.id = id ?? UUID()
        self.shoppingList = shoppingList
        self.ingredients = ingredients
        self.date = date
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        var ingredientsCopy: [IngredientType:[Ingredient]] = [:]
        for (key, value) in self.ingredients {
            ingredientsCopy[key] = []
            ingredientsCopy[key]?.append(contentsOf: value.map({$0.copy() as! Ingredient}))
        }
        
        let copy = Recipe(id: self.id, shoppingList: self.shoppingList, ingredients: ingredientsCopy, date: self.date)
        return copy
    }
    
    func removeIngredient(_ ingredient: Ingredient, with key: IngredientType) {
        if let index = self.ingredients[key]?.firstIndex(of: ingredient) {
            self.ingredients[key]?.remove(at: index)
            if (self.ingredients[key]?.isEmpty)! {
                self.ingredients[key] = nil
            }
        }
        objectWillChange.send(self)
    }
    
    func addIngredient(_ ingredient: Ingredient, for key: IngredientType) {
        self.ingredients[key]?.append(ingredient)
        objectWillChange.send(self)
    }
    
    func addIngredientSection(_ section: IngredientType) {
        self.ingredients[section] = []
        objectWillChange.send(self)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.shoppingList == rhs.shoppingList &&
            lhs.ingredients == rhs.ingredients
    }
    
    static func make(from dto: RecipeDto) -> Recipe {
        var ingredients = [IngredientType:[Ingredient]]()
        dto.ingredients.forEach { ingredientDto in
            let ingredient = Ingredient(
                id: UUID.init(uuidString: ingredientDto.id)!,
                name: ingredientDto.name,
                notes: ingredientDto.notes,
                type: Helper.ingredientTypeStringToEnum(ingredientDto.type),
                isSelected: ingredientDto.isSelected == 1
            )
            
            let type = Helper.ingredientTypeStringToEnum(ingredientDto.type)
            
            if ingredients[type] == nil { ingredients[type] = [] }
            
            ingredients[type]?.append(ingredient)
        }
        
        let date = CalendarDate()
        date.year = CalendarYear(year: dto.date.first!.year)
        date.month = CalendarMonth(month: dto.date.first!.month)
        date.day = CalendarDay(day: dto.date.first!.day, dayName: dto.date.first!.dayName)
        
        return Recipe(
            id: UUID.init(uuidString: dto.id),
            shoppingList: ShoppingList(type: dto.shoppingList),
            ingredients: ingredients,
            date: date
        )
    }
    
    struct ShoppingList : Hashable {
        let type: String
        
        static func == (lhs: ShoppingList, rhs: ShoppingList) -> Bool {
            return lhs.type == rhs.type
        }
    }
}
