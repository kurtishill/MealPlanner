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
    
    private let miscItemsRelay: PublishRelay<[IngredientType:[Ingredient]]> = PublishRelay()
    let miscItemsObservable: Observable<[IngredientType:[Ingredient]]>
    
    private let weekItemsNumberRelay: PublishRelay<Int> = PublishRelay()
    let weekItemsNumberObservable: Observable<Int>
    
    private let bag = DisposeBag()
    
    init() {
        self.weekIngredientsObservable = weekIngredientsRelay.asObservable()
        self.miscItemsObservable = miscItemsRelay.asObservable()
        self.weekItemsNumberObservable = weekItemsNumberRelay.asObservable()
    }
    
    func createIngredient(_ ingredient: Ingredient, for recipeDto: RecipeDto?, week: String) {
        let ingredientDto = IngredientDto.make(from: ingredient, and: week)
        
        storage.ingredientDao().update(item: ingredientDto)
        
        if let recipeDto = recipeDto {
            let recipeIngredients = recipeDto.ingredients.toArray()
            var newRecipeDtoIngredients = [IngredientDto]()
            newRecipeDtoIngredients.append(contentsOf: recipeIngredients)
            newRecipeDtoIngredients.append(ingredientDto)
            
            let newRecipeDto = RecipeDto.make(
                id: recipeDto.id,
                category: recipeDto.category,
                title: recipeDto.title,
                ingredients: newRecipeDtoIngredients
            )
            storage.recipeDao().update(item: newRecipeDto)
        } else {
            storage.ingredientDao().create(item: ingredientDto)
        }
    }
    
    func getIngredients(for recipe: Recipe?, week: String?) {
        let ingredientDao = storage.ingredientDao() as! RealmIngredientDao
        var recipeDto: RecipeDto?
        
        if let recipe = recipe { recipeDto = RecipeDto.make(from: recipe) }
        
        ingredientDao.getAll(for: recipeDto, week: week)
            .subscribe(onNext: { ingredientDtos in
                var ingredients: [IngredientType:[Ingredient]] = [:]
                var miscItems: [IngredientType:[Ingredient]] = [:]
                
                for ingredientDto in ingredientDtos {
                    let ingredient = Ingredient(
                        id: UUID.init(uuidString: ingredientDto.id)!,
                        name: ingredientDto.name,
                        notes: ingredientDto.notes,
                        type: Helper().ingredientTypeStringToEnum(ingredientDto.type),
                        isSelected: ingredientDto.isSelected == 0 ? false : true
                    )
                    
                    let key = Helper().ingredientTypeStringToEnum(ingredientDto.type)
                    
                    if ingredients[key] == nil {
                        ingredients[key] = []
                    }
                    
                    ingredients[key]?.append(ingredient)
                    
                    if ingredientDto.recipe.isEmpty {
                        if miscItems[key] == nil {
                            miscItems[key] = []
                        }
                        miscItems[key]?.append(ingredient)
                    }
                }
                
                self.weekIngredientsRelay.accept(ingredients)
                self.miscItemsRelay.accept(miscItems)
                
                var numberUnselected = 0
                for (_, ing) in ingredients {
                    numberUnselected += ing.filter { !$0.isSelected }.count
                }
                
                self.weekItemsNumberRelay.accept(numberUnselected)
            }).disposed(by: bag)
    }
    
    func updateIngredient(_ ingredient: Ingredient, week: String) {
        storage.ingredientDao().update(item: IngredientDto.make(from: ingredient, and: week))
    }
    
    func deleteIngredient(_ ingredient: Ingredient, week: String) {
        storage.ingredientDao().delete(item: IngredientDto.make(from: ingredient, and: week))
    }
}
