//
//  RepositoryAssembly.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/25/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import SwiftDI

class RepositoryAssembly: DIPart {
    var body: some DIPart {
        DIGroup {
            DIRegister(RecipeRepository.init)
                .lifeCycle(.prototype)
            DIRegister(IngredientRepository.init)
                .lifeCycle(.prototype)
        }
    }
}
