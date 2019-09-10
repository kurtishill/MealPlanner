//
//  IngredientDto.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct IngredientDto {
    let id: String
    let name: String
    let notes: String?
    let type: String
    let isSelected: Int
    let recipeId: String?
    let week: String?
}
