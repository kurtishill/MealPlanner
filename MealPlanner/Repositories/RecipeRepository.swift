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
    
    private let recipeRelay: PublishRelay<[Int:[Recipe.Category:Recipe]]> = PublishRelay()
    let recipeObservable: Observable<[Int:[Recipe.Category:Recipe]]>
    
    private let singleRecipeRelay: PublishRelay<Recipe> = PublishRelay()
    let singleRecipeObservable: Observable<Recipe>
    
    private let bag = DisposeBag()
    
    init() {
        self.recipeObservable = self.recipeRelay.asObservable()
        self.singleRecipeObservable = self.singleRecipeRelay.asObservable()
    }
    
    func createRecipe(_ recipe: Recipe, week: String) {
        storage.recipeDao().update(item: RecipeDto.make(from: recipe))
        
        let recipeDto = storage.recipeDao().get(for: recipe.id.uuidString)
        if recipe.ingredients.count > 0 && recipeDto == nil { fatalError("Recipe didn't create successfully") }
        
        for (_, value) in recipe.ingredients {
            for ingredient in value {
                self.ingredientRepository.createIngredient(ingredient, for: recipeDto, week: week)
            }
        }
        
        let date = storage.dateDao().get(for: recipe.date.id)
        
        var recipes = [RecipeDto]()
        recipes.append(contentsOf: date?.recipes.toArray() ?? [])
        recipes.append(recipeDto!)
        
        let dateDto = DateDto.make(id: recipe.date.id, month: recipe.date.month.month, day: recipe.date.day.day, year: recipe.date.year.year, recipes: recipes)
        
        storage.dateDao().update(item: dateDto)
    }
    
    func getRecipe(with id: String) {
        guard let dto = storage.recipeDao().get(for: id) else { return }
        
        self.singleRecipeRelay.accept(Recipe.make(from: dto))
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        storage.recipeDao().delete(item: RecipeDto.make(from: recipe))
        getRecipe(with: recipe.id.uuidString)
    }
    
    func getAllRecipesForWeek(with date: CalendarDate) {
        let dateDao = storage.dateDao() as! RxDateDao
        dateDao.getAllDateDataForWeek(with: date)
            .subscribe(onNext: { dtos in
                var dict: [Int:[Recipe.Category:Recipe]] = [:]
                
                for day in date.week.week {
                    dict[day.day] = [:]
                }
                
                for dates in dtos {
                    for recipeDto in dates.recipes {
                        let recipe: Recipe? = Recipe.make(from: recipeDto)
                        if let recipe = recipe {
                            dict[recipe.date.day.day]![recipe.category] = recipe
                        }
                    }
                }
                
                self.recipeRelay.accept(dict)
            }).disposed(by: bag)
    }
}
