//
//  DateDto.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/22/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift

class DateDto: Object, BaseDto {
    @objc dynamic var id: String = ""
    @objc dynamic var month: Int = 0
    @objc dynamic var day: Int = 0
    @objc dynamic var year: Int = 0
    let recipes = List<RecipeDto>()
    
    static func make(id: String, month: Int, day: Int, year: Int, recipes: [RecipeDto]) -> DateDto {
        let dto = DateDto()
        dto.id = id
        dto.month = month
        dto.day = day
        dto.year = year
        dto.recipes.append(objectsIn: recipes)
        
        return dto
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func getChildrenObjects<T>() -> List<T>? where T : BaseDto {
        return recipes as? List<T>
    }
}
