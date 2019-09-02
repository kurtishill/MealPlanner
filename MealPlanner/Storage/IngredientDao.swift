//
//  IngredientDao.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

protocol IngredientDao {
    func createIngredient(_ ingredient: IngredientDto) -> Bool
    func getIngredients(for recipe: String?, week: String?) -> [IngredientDto]?
    func updateIngredient(_ ingredient: IngredientDto) -> Bool
    func deleteIngredient(with id: String) -> Bool
}
