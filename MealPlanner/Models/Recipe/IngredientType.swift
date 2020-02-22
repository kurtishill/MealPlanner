//
//  IngredientType.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct IngredientType: RawRepresentable, Equatable, Hashable, Comparable {
    typealias RawValue = String
    
    var rawValue: String
    
    static let Bread = IngredientType(rawValue: "Bread")
    static let Dairy = IngredientType(rawValue: "Dairy")
    static let Deli = IngredientType(rawValue: "Deli")
    static let Produce = IngredientType(rawValue: "Produce")
    static let Spices = IngredientType(rawValue: "Spices")
    static let CannedGoods = IngredientType(rawValue: "Canned Goods")
    static let Baking = IngredientType(rawValue: "Baking")
    static let Meat = IngredientType(rawValue: "Meat")
    static let Frozen = IngredientType(rawValue: "Frozen")
    static let Miscellaneous = IngredientType(rawValue: "Miscellaneous")
    
    var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func <(lhs: IngredientType, rhs: IngredientType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static let ingredientTypes = [
        IngredientType.Baking,
        IngredientType.Bread,
        IngredientType.CannedGoods,
        IngredientType.Dairy,
        IngredientType.Deli,
        IngredientType.Frozen,
        IngredientType.Meat,
        IngredientType.Miscellaneous,
        IngredientType.Produce,
        IngredientType.Spices
    ]
    
    static var weeklyItemTypes: [IngredientType] {
        return ([IngredientType.Snacks, IngredientType.Hygeine] + ingredientTypes).sorted()
    }
}
