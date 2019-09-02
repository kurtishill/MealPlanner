//
//  MockRecipeDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

let recipes = [
    Recipe(category: Recipe.Category.Breakfast,
           title: "Omelet",
           ingredients: [IngredientType.Dairy : [Ingredient(name: "eggs", quantity: 3.0, measurementType: nil, type: IngredientType.Dairy, isSelected: false)]],
           date: CalendarDate(year: CalendarYear(year: 2019), month: CalendarMonth(month: 8), week:  CalendarWeek(week: [CalendarDay(day: 26, isBeforeCurrentDay: false)], isCurrentWeek: true), day: CalendarDay(day: 26))
    ),
    Recipe(category: Recipe.Category.Lunch,
           title: "Sandwich",
           ingredients: [IngredientType.Bread : [Ingredient(name: "bread", quantity: 1.0, measurementType: "loaf", type: IngredientType.Dairy, isSelected: false)]],
           date: CalendarDate(year: CalendarYear(year: 2019), month: CalendarMonth(month: 8), week:  CalendarWeek(week: [CalendarDay(day: 26, isBeforeCurrentDay: false)], isCurrentWeek: true), day: CalendarDay(day: 26))
    ),
    Recipe(category: Recipe.Category.Dinner,
           title: "Hamburgers",
           ingredients: [IngredientType.Meat : [Ingredient(name: "ground beef", quantity: 1.0, measurementType: "lb", type: IngredientType.Dairy, isSelected: false)]],
           date: CalendarDate(year: CalendarYear(year: 2019), month: CalendarMonth(month: 8), week:  CalendarWeek(week: [CalendarDay(day: 26, isBeforeCurrentDay: false)], isCurrentWeek: true), day: CalendarDay(day: 26))
    ),
]

class MockRecipeDao: RecipeDao {
    func createRecipe(_ recipe: RecipeDto) -> Bool {
        return true
    }
    
    func getAllRecipesForWeek(with date: CalendarDate) -> [RecipeDto]? {
        return []
    }
}
