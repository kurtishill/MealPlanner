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
    
    /**
     static let ingredientTypes = [
         IngredientType.Bread,
         IngredientType.Dairy,
         IngredientType.Deli,
         IngredientType.Produce,
         IngredientType.Spices,
         IngredientType.CannedGoods,
         IngredientType.Baking,
         IngredientType.Meat,
         IngredientType.Frozen,
         IngredientType.Miscellaneous
     ]
     
     static var weeklyItemTypes: [IngredientType] {
         return [IngredientType.Snacks, IngredientType.Hygeine] + ingredientTypes
     }
     */
    
    func ingredientTypeStringToEnum(_ type: String) -> IngredientType {
        switch type {
        case "Bread":
            return IngredientType.Bread
        case "Dairy":
            return IngredientType.Dairy
        case "Deli":
            return IngredientType.Deli
        case "Produce":
            return IngredientType.Produce
        case "Spices":
            return IngredientType.Spices
        case "Canned Goods":
            return IngredientType.CannedGoods
        case "Baking":
            return IngredientType.Baking
        case "Meat":
            return IngredientType.Meat
        case "Frozen":
            return IngredientType.Frozen
        case "Snacks":
            return IngredientType.Snacks
        case "Hygeine":
            return IngredientType.Hygeine
        case "Miscellaneous":
            return IngredientType.Miscellaneous
        default:
            // should never get here
            return IngredientType.Bread
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
