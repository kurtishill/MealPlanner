//
//  StorageAssembly.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/25/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import SwiftDI

class StorageAssembly: DIPart {
    var body: some DIPart {
        DIGroup {
            DIRegister(RealmStorage.init)
                .as(RxStorage.self)
            DIRegister(RealmRecipeDao.init)
                .as(RxRealmDao<RecipeDto>.self)
            DIRegister(RealmIngredientDao.init)
                .as(RxRealmDao<IngredientDto>.self)
            DIRegister(RealmDateDao.init)
                .as(RxRealmDao<DateDto>.self)
        }
    }
}
