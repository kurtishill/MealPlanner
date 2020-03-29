//
//  IngredientService.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Combine
import SwiftDI

enum MyError: Error {
    case runtimeError(String)
}

class IngredientRepository {
    @Inject private var storage: RxStorage
    
    private let weekIngredientsRelay: PublishRelay<[IngredientType:[Ingredient]]> = PublishRelay()
    let weekIngredientsObservable: Observable<[IngredientType:[Ingredient]]>
    
    private let dayIngredientCountRelay: PublishRelay<Int> = PublishRelay()
    let dayIngredientCountObservable: Observable<Int>
    
    private let bag = DisposeBag()
    
    init() {
        self.weekIngredientsObservable = weekIngredientsRelay.asObservable()
        self.dayIngredientCountObservable = dayIngredientCountRelay.asObservable()
    }
    
    func getIngredientCount(for date: CalendarDate) {
        let dateDao = storage.dateDao() as! RxDateDao
        var count = 0
        
        dateDao.getDate(date)
            .subscribe(onNext: { dateDto in
                dateDto.recipes.forEach { recipeDto in
                    count += recipeDto.ingredients.filter(NSPredicate(format: "isSelected == 0")).count
                }
                
                self.dayIngredientCountRelay.accept(count)
            }).disposed(by: self.bag)
    }
    
    func createIngredient(_ ingredient: Ingredient, for recipeDto: RecipeDto?) {
        let ingredientDto = IngredientDto.make(from: ingredient)
        
        storage.ingredientDao().update(item: ingredientDto)
        
        if let recipeDto = recipeDto {
            let recipeIngredients = recipeDto.ingredients.toArray()
            var newRecipeDtoIngredients = [IngredientDto]()
            newRecipeDtoIngredients.append(contentsOf: recipeIngredients)
            if !newRecipeDtoIngredients.contains(ingredientDto) {
                newRecipeDtoIngredients.append(ingredientDto)
            }

            let newRecipeDto = RecipeDto.make(
                id: recipeDto.id,
                shoppingList: recipeDto.shoppingList,
                ingredients: newRecipeDtoIngredients
            )
            storage.recipeDao().update(item: newRecipeDto)
        } else {
            storage.ingredientDao().create(item: ingredientDto)
        }
    }
    
    func getIngredients(for dates: [CalendarDate]) {
        let dateDao = storage.dateDao() as! RxDateDao
        
        var ingredients: [IngredientType:[Ingredient]] = [:]
        dateDao.getDates(dates)
            .subscribe(onNext: { dateDtos in
                dateDtos.forEach { dateDto in
                    for recipeDto in dateDto.recipes {
                        for ingredientDto in recipeDto.ingredients {
                            let ingredient = Ingredient.make(from: ingredientDto)
                            let key = Helper.ingredientTypeStringToEnum(ingredientDto.type)
                            
                            if ingredients[key] == nil {
                                ingredients[key] = []
                            }
                            
                            ingredients[key]?.append(ingredient)
                        }
                    }
                }
                
                self.weekIngredientsRelay.accept(ingredients)
            }).disposed(by: self.bag)
    }
    
    func getIngredients(for recipe: Recipe?, week: String?) {
        let ingredientDao = storage.ingredientDao() as! RealmIngredientDao
        var recipeDto: RecipeDto?
        
        if let recipe = recipe { recipeDto = RecipeDto.make(from: recipe) }
        
        ingredientDao.getAll(for: recipeDto, week: week)
            .subscribe(onNext: { ingredientDtos in
                var ingredients: [IngredientType:[Ingredient]] = [:]
                
                for ingredientDto in ingredientDtos {
                    let ingredient = Ingredient(
                        id: UUID.init(uuidString: ingredientDto.id)!,
                        name: ingredientDto.name,
                        notes: ingredientDto.notes,
                        type: Helper.ingredientTypeStringToEnum(ingredientDto.type),
                        isSelected: ingredientDto.isSelected == 0 ? false : true
                    )
                    
                    let key = Helper.ingredientTypeStringToEnum(ingredientDto.type)
                    
                    if ingredients[key] == nil {
                        ingredients[key] = []
                    }
                    
                    ingredients[key]?.append(ingredient)
                }
                
                self.weekIngredientsRelay.accept(ingredients)
            }).disposed(by: bag)
    }
    
    func updateIngredient(_ ingredient: Ingredient) {
        storage.ingredientDao().update(item: IngredientDto.make(from: ingredient))
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        storage.ingredientDao().delete(item: IngredientDto.make(from: ingredient))
    }
}
