//
//  RecipeDto.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct RecipeDto {
    var id: String {
        "\(category)_\(month)_\(day)_\(year)"
    }
    let category: String
    let title: String
    let year: Int
    let month: Int
    let day: Int
}
