//
//  RecipeService.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import Combine
import RxSwift
import RxRelay
import SwiftDI

class RecipeRepository {
    @Inject private var storage: RxStorage
    @Inject private var ingredientRepository: IngredientRepository
    
    private let recipeRelay: PublishRelay<[CalendarDate:[Recipe.ShoppingList:Recipe]]> = PublishRelay()
    let recipeObservable: Observable<[CalendarDate:[Recipe.ShoppingList:Recipe]]>
    
    private let singleRecipeRelay: PublishRelay<Recipe> = PublishRelay()
    let singleRecipeObservable: Observable<Recipe>
    
    private let bag = DisposeBag()
    
    init() {
        self.recipeObservable = self.recipeRelay.asObservable()
        self.singleRecipeObservable = self.singleRecipeRelay.asObservable()
    }
    
    func createRecipe(with name: String, for date: CalendarDate) {
        let recipeDto = RecipeDto.make(id: UUID().uuidString, shoppingList: name, ingredients: [])
        
        storage.recipeDao().update(item: recipeDto)
        
        let dateFromDb = storage.dateDao().get(for: date.id)
        
        var recipes = [RecipeDto]()
        recipes.append(contentsOf: dateFromDb?.recipes.toArray() ?? [])
        recipes.append(recipeDto)
        
        let dateDto = DateDto.make(id: date.id, month: date.month.month, day: date.day.day, dayName: date.day.dayName, year: date.year.year, recipes: recipes)
        
        storage.dateDao().update(item: dateDto)
    }
    
    func createRecipe(_ recipe: Recipe) {
//        storage.recipeDao().update(item: RecipeDto.make(from: recipe))
        
        let recipeDto = storage.recipeDao().get(for: recipe.id.uuidString)
        if recipe.ingredients.count > 0 && recipeDto == nil { fatalError("Recipe didn't create successfully") }
        
        for (_, value) in recipe.ingredients {
            for ingredient in value {
                self.ingredientRepository.createIngredient(ingredient, for: recipeDto)
            }
        }
        
//        let date = storage.dateDao().get(for: recipe.date.id)
//
//        var recipes = [RecipeDto]()
//        recipes.append(contentsOf: date?.recipes.toArray() ?? [])
//        recipes.append(recipeDto!)
//
//        let dateDto = DateDto.make(
//            id: recipe.date.id,
//            month: recipe.date.month.month,
//            day: recipe.date.day.day,
//            dayName: recipe.date.day.dayName,
//            year: recipe.date.year.year,
//            recipes: recipes
//        )
//
//        storage.dateDao().update(item: dateDto)
    }
    
    func getRecipe(with id: String) {
        guard let dto = storage.recipeDao().get(for: id) else { return }
        
        self.singleRecipeRelay.accept(Recipe.make(from: dto))
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        storage.recipeDao().delete(item: RecipeDto.make(from: recipe))
        getRecipe(with: recipe.id.uuidString)
    }
    
    func getRecipes(for date: CalendarDate) {
        let dateDao = storage.dateDao() as! RxDateDao
        dateDao.getDate(date)
            .subscribe(onNext: { dateDto in
                var dict: [CalendarDate:[Recipe.ShoppingList:Recipe]] = [:]
                dict[date] = [:]
                
                for recipeDto in dateDto.recipes {
                    let recipe: Recipe? = Recipe.make(from: recipeDto)
                    if let recipe = recipe {
                        dict[date]![recipe.shoppingList] = recipe
                    }
                }
                
                self.recipeRelay.accept(dict)
            }).disposed(by: self.bag)
    }
    
//    func getAllRecipesForWeek(with date: CalendarDate) {
//        let dateDao = storage.dateDao() as! RxDateDao
//        dateDao.getAllDateDataForWeek(with: date)
//            .subscribe(onNext: { dtos in
//                var dict: [Int:[Recipe.ShoppingList:Recipe]] = [:]
//
//                for day in date.week.week {
//                    dict[day.day] = [:]
//                }
//
//                for dates in dtos {
//                    for recipeDto in dates.recipes {
//                        let recipe: Recipe? = Recipe.make(from: recipeDto)
//                        if let recipe = recipe {
//                            dict[recipe.date.day.day]![recipe.shoppingList] = recipe
//                        }
//                    }
//                }
//
//                self.recipeRelay.accept(dict)
//            }).disposed(by: self.bag)
//    }
}
