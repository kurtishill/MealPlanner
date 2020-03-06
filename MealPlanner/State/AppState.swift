//
//  RecipeClass.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import Combine
import RxSwift
import RxRelay
import SwiftDI

class AppState: ObservableObject {
    internal let objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    private let bag = DisposeBag()
    
    // key is day of week
    var weekRecipes: [Int:[Recipe.Category:Recipe?]] = [:]
    
    var itemsForWeek: [IngredientType:[Ingredient]] = [:]
    
    var miscItems: [IngredientType:[Ingredient]] = [:]
    
    var calendarLoading: Bool = false
    
    @Inject var calendarState: CalendarState
    @Inject var recipeRepository: RecipeRepository
    @Inject var ingredientRepository: IngredientRepository
    
    var weekKey: String {
        let date = self.calendarState.calendar.value!.currDate!
        return "\(date.month.month)_\(date.week.week.first!.day)-\(date.week.week.last!.day)_\(date.year.year)"
    }
    
    init() {
        self.recipeRepository.recipeObservable
            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { (recipes: [Int:[Recipe.Category:Recipe]]) in
                print("week recipes updated")
                print(recipes)
                self.weekRecipes = recipes
                self.objectWillChange.send()
            }).disposed(by: self.bag)
        
        self.recipeRepository.singleRecipeObservable
            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { recipe in
                self.weekRecipes[recipe.date.day.day]?[recipe.category] = recipe
                self.objectWillChange.send()
            }).disposed(by: self.bag)
        
        self.ingredientRepository.weekIngredientsObservable
            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { (itemsForWeek: [IngredientType : [Ingredient]]) in
                print("items for week updated")
                self.itemsForWeek = itemsForWeek
                self.objectWillChange.send()
            }).disposed(by: self.bag)
        
        self.ingredientRepository.miscItemsObservable
            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { (miscItems: [IngredientType : [Ingredient]]) in
                self.miscItems = miscItems
            }).disposed(by: self.bag)
        
        self.calendarState.calendar
            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { (calendarModel) in
                print("calendar updated")
                self.objectWillChange.send()
                if let currDate = calendarModel?.currDate {
                    self.recipeRepository.getAllRecipesForWeek(with: currDate)
                    
                    self.ingredientRepository.getIngredients(for: nil, week: self.weekKey)
                }
            }).disposed(by: self.bag)
        
        self.calendarState.loading
            .observeOn(MainScheduler())
            .subscribe(onNext: { loading in
                self.calendarLoading = loading
                self.objectWillChange.send()
            }).disposed(by: self.bag)
    }
    
    func getRecipe(for day: Int, with category: Recipe.Category) -> Recipe? {
        return self.weekRecipes[day]?[category] ?? nil
    }
    
    func getIngredientsForWeekDisplay() -> [IngredientType:[Ingredient]] {
        var ingredients: [IngredientType:[Ingredient]] = [:]
        
        ingredients.merge(self.itemsForWeek) { (_, new) in new }
        
//        for (_, value) in self.weekRecipes {
//            for (_, recipe) in value/*.sorted(by: {$0.key.rawValue < $1.key.rawValue}) */{
//                if let r = recipe {
//                    for (type, i) in r.ingredients/*.sorted(by: {$0.key < $1.key}) */{
//                        if ingredients[type] == nil {
//                            ingredients[type] = [Ingredient]()
//                        }
//                        ingredients[type]?.append(contentsOf: i)
//                    }
//                }
//            }
//        }
        
        return ingredients
    }
    
    func fetchRecipe(with id: String) {
        self.recipeRepository.getRecipe(with: id)
    }
    
    func fetchAllRecipesForWeek() {
        if let currDate = self.calendarState.calendar.value?.currDate {
            self.recipeRepository.getAllRecipesForWeek(with: currDate)
        }
    }
    
    func updateRecipe(_ recipe: Recipe) {
        self.recipeRepository.createRecipe(recipe, week: weekKey)
        self.recipeRepository.getRecipe(with: recipe.id.uuidString)
    }
    
    func createIngredientForWeek(_ ingredient: Ingredient) {
        self.ingredientRepository.createIngredient(ingredient, for: nil, week: weekKey)
        self.ingredientRepository.getIngredients(for: nil, week: weekKey)
    }
    
    func updateIngredient(_ ingredient: Ingredient) {
        self.ingredientRepository.updateIngredient(ingredient, week: weekKey)
        self.objectWillChange.send()
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        self.ingredientRepository.deleteIngredient(ingredient, week: weekKey)
        self.getIngredients()
    }
    
    func getIngredients() {
        self.ingredientRepository.getIngredients(for: nil, week: weekKey)
    }
}
