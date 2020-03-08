//
//  RealmStorage.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDI

class RealmStorage : RxStorage {
    @Inject private var realmRecipeDao: RxRealmDao<RecipeDto>
    @Inject private var realmIngredientDao: RxRealmDao<IngredientDto>
    @Inject private var realmDateDao: RxRealmDao<DateDto>
    
    func recipeDao() -> RxRealmDao<RecipeDto> {
        return realmRecipeDao
    }
    
    func ingredientDao() -> RxRealmDao<IngredientDto> {
        return realmIngredientDao
    }
    
    func dateDao() -> RxRealmDao<DateDto> {
        return realmDateDao
    }
    
    func initStorage() {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL!.deletingLastPathComponent().path)
        } catch {
            print(error)
        }
    }
}
