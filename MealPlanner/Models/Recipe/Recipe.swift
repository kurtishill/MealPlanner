//
//  Recipe.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import Combine

class Recipe: NSObject, ObservableObject, NSCopying {
    var objectWillChange = PassthroughSubject<Recipe, Never>()
    
    var category: Category = Category.Breakfast
    var title: String = ""
    var ingredients: [IngredientType:[Ingredient]] = [:]
    var date: CalendarDate = CalendarDate()
    
    init(category: Category, title: String, ingredients: [IngredientType:[Ingredient]], date: CalendarDate) {
        self.category = category
        self.title = title
        self.ingredients = ingredients
        self.date = date
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        var ingredientsCopy: [IngredientType:[Ingredient]] = [:]
        for (key, value) in self.ingredients {
            ingredientsCopy[key] = []
            ingredientsCopy[key]?.append(contentsOf: value.map({$0.copy() as! Ingredient}))
        }
        
        let copy = Recipe(category: self.category, title: self.title, ingredients: ingredientsCopy, date: self.date)
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
        return lhs.category == rhs.category &&
            lhs.title == rhs.title &&
            lhs.ingredients == rhs.ingredients
    }
    
    enum Category: String {
        case Breakfast = "Breakfast"
        case Lunch = "Lunch"
        case Dinner = "Dinner"
    }
}
