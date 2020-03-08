//
//  RxIngredientDao.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift

protocol RxIngredientDao {
    func getAll(for recipe: RecipeDto?, week: String?) -> Observable<[IngredientDto]>
}
