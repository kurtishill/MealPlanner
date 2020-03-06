//
//  MockRecipeDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

let recipes = [
    Recipe(id: nil, category: Recipe.Category.Breakfast,
           title: "Omelet",
           ingredients: [IngredientType.Dairy : [Ingredient(name: "eggs", notes: "3.0", type: IngredientType.Dairy, isSelected: false)]],
           date: CalendarDate(year: CalendarYear(year: 2019), month: CalendarMonth(month: 8), week:  CalendarWeek(week: [CalendarDay(day: 26, isBeforeCurrentDay: false)], isCurrentWeek: true), day: CalendarDay(day: 26))
    ),
    Recipe(id: nil, category: Recipe.Category.Lunch,
           title: "Sandwich",
           ingredients: [IngredientType.Bread : [Ingredient(name: "bread", notes: "loaf", type: IngredientType.Dairy, isSelected: false)]],
           date: CalendarDate(year: CalendarYear(year: 2019), month: CalendarMonth(month: 8), week:  CalendarWeek(week: [CalendarDay(day: 26, isBeforeCurrentDay: false)], isCurrentWeek: true), day: CalendarDay(day: 26))
    ),
    Recipe(id: nil, category: Recipe.Category.Dinner,
           title: "Hamburgers",
           ingredients: [IngredientType.Meat : [Ingredient(name: "ground beef", notes: "1 lb", type: IngredientType.Dairy, isSelected: false)]],
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
