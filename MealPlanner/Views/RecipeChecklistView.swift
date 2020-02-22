//
//  RecipeChecklistView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct RecipeChecklistView: View {
    @Binding var recipe: Recipe
    @ObservedObject var appState: AppState
    
    var color: String
    
    var body: some View {
        let keys = recipe.ingredients.keys.map {$0.self}.sorted()
        
        return ScrollView(.vertical, showsIndicators: false) {
            ForEach(keys, id: \.self) { (key: IngredientType) in
                VStack(alignment: .leading, spacing: 8) {
                    Text(key.rawValue)
                        .font(.title)
                        .padding(.leading, 20)
                    ForEach(self.recipe.ingredients[key]!, id: \.self) { (ingredient: Ingredient) in
                        IngredientChecklistRow(ingredient: ingredient, color: self.color, appState: self.appState)
                            .onTapGesture {
                                self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.isSelected.toggle()
                                self.appState.updateRecipe(self.recipe)
                        }
                    }
                }
            }
        }
    }
}

//struct RecipeChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeChecklistView()
//    }
//}
