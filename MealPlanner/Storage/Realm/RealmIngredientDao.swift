//
//  RealmIngredientDao.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm

class RealmIngredientDao: RxRealmDao<IngredientDto>, RxIngredientDao {
    func getAll(for recipe: RecipeDto?, week: String?) -> Observable<[IngredientDto]> {
        if let recipe = recipe {
            return Observable.array(from: realm.objects(IngredientDto.self).filter(NSPredicate(format: "recipe == %@", recipe)))
        } else {
            return Observable.array(from: realm.objects(IngredientDto.self).filter(NSPredicate(format: "week == %@", week!)))
        }
    }
}
