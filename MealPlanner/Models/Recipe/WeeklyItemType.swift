//
//  WeeklyItemType.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

protocol WeeklyItemType {}

extension WeeklyItemType {
    static var Snacks: IngredientType {
        return IngredientType(rawValue: "Snacks")
    }
    
    static var Hygeine: IngredientType {
        return IngredientType(rawValue: "Hygeine")
    }
}

extension IngredientType : WeeklyItemType {}
