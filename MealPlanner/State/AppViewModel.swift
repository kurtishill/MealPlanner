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

class AppViewModel: ObservableObject {
    internal let objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    private let bag = DisposeBag()
    
    var lists: [CalendarDate:[Recipe.ShoppingList:Recipe?]] = [:]
    
    var itemsForWeek: [IngredientType:[Ingredient]] = [:]
    
    var itemsForWeekNumber: Int = 0
    
    var calendarLoading: Bool = false
    
    @Inject var calendarState: CalendarState
    @Inject var recipeRepository: RecipeRepository
    @Inject var ingredientRepository: IngredientRepository
    
    init() {
        self.recipeRepository.recipeObservable
            .observeOn(MainScheduler())
            .subscribe(onNext: { (recipes: [CalendarDate:[Recipe.ShoppingList:Recipe]]) in
                print("week recipes updated")
                print(recipes)
                self.lists.merge(recipes) { _, new in new }
                self.objectWillChange.send()
            }).disposed(by: self.bag)
        
        self.recipeRepository.singleRecipeObservable
            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { recipe in
                if self.lists[recipe.date] == nil {
                    self.lists[recipe.date] = [:]
                }
                self.lists[recipe.date]![recipe.shoppingList] = recipe
                
                self.itemsForWeekNumber = self.calcItemNumForDaysSelected()
                
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
        
        self.calendarState.calendar
//            .distinctUntilChanged()
            .observeOn(MainScheduler())
            .subscribe(onNext: { (calendarModel) in
                print("calendar updated")
                self.lists.removeAll()
                self.objectWillChange.send()
                
            }).disposed(by: self.bag)
        
        self.calendarState.loading
            .observeOn(MainScheduler())
            .subscribe(onNext: { loading in
                self.calendarLoading = loading
                self.objectWillChange.send()
            }).disposed(by: self.bag)
        
        self.calendarState.daySelectionRelay
            .observeOn(MainScheduler())
            .subscribe(onNext: { date in
                if self.lists[date] != nil {
                    self.lists[date] = nil
                } else {
                    self.lists[date] = [:]
                    self.recipeRepository.getRecipes(for: date)
                }
                
                self.itemsForWeekNumber = self.calcItemNumForDaysSelected()
                
                self.objectWillChange.send()
            }).disposed(by: self.bag)
    }
    
    func daySelected(_ day: CalendarDay) {
        self.calendarState.daySelected(day)
    }
    
    func calcItemNumForDaysSelected() -> Int {
        var count = 0
        for (_, ingredients) in self.lists {
            for (_, recipe) in ingredients {
                for (_, value) in recipe?.ingredients ?? [:] { count += value.count }
            }
        }
        
        return count
    }
    
    func fetchRecipe(with id: String) {
        self.recipeRepository.getRecipe(with: id)
    }
    
    func fetchAllRecipesForSelectedDays() {
        for (_, ingredients) in self.lists {
            for (_, recipe) in ingredients {
                if recipe != nil {
                    self.fetchRecipe(with: recipe!.id.uuidString)
                }
            }
        }
    }
    
    func createRecipe(name: String, for date: CalendarDate) {
        self.recipeRepository.createRecipe(with: name, for: date)
        self.recipeRepository.getRecipes(for: date)
    }
    
    func updateRecipe(_ recipe: Recipe) {
        self.recipeRepository.createRecipe(recipe)
        self.recipeRepository.getRecipe(with: recipe.id.uuidString)
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        self.recipeRepository.deleteRecipe(recipe)
        self.recipeRepository.getRecipes(for: recipe.date)
    }
    
    func updateIngredient(_ ingredient: Ingredient) {
        self.ingredientRepository.updateIngredient(ingredient)
        self.objectWillChange.send()
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        self.ingredientRepository.deleteIngredient(ingredient)
        self.getIngredients()
    }
    
    func getIngredients() {
//        self.ingredientRepository.getIngredients(for: nil, week: weekKey)
        self.ingredientRepository.getIngredients(for: self.lists.keys.map { $0.self })
    }
}
