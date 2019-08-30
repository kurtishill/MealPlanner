//
//  Helper.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/28/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct Helper {
    func monthToString(_ month: Int) -> String {
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "January"
        }
    }
    
    func categoryStringToEnum(_ category: String) -> Recipe.Category {
        switch category {
        case "Breakfast":
            return Recipe.Category.Breakfast
        case "Lunch":
            return Recipe.Category.Lunch
        case "Dinner":
            return Recipe.Category.Dinner
        default:
            // should never get here
            return Recipe.Category.Breakfast
        }
    }
    
    func ingredientTypeStringToEnum(_ type: String) -> Ingredient.IngredientType {
        switch type {
        case "Bread":
            return Ingredient.IngredientType.Bread
        case "Dairy":
            return Ingredient.IngredientType.Dairy
        case "Produce":
            return Ingredient.IngredientType.Produce
        case "Meat":
            return Ingredient.IngredientType.Meat
        case "Frozen":
            return Ingredient.IngredientType.Frozen
        case "Miscellaneous":
            return Ingredient.IngredientType.Miscellaneous
        default:
            // should never get here
            return Ingredient.IngredientType.Bread
        }
    }
    
    static let dayNames: [Int:String] = [
        0: "Sun",
        1: "Mon",
        2: "Tues",
        3: "Wed",
        4: "Thurs",
        5: "Fri",
        6: "Sat"
    ]
}
