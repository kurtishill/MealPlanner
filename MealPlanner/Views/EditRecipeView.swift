//
//  EditRecipeView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct EditRecipeView: View {
    @ObservedObject var recipe: Recipe
    
    @State var makeNewCategory = false
    
    var body: some View {
        let keys = recipe.ingredients.keys.map {$0.self}.sorted()
        
        return ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(keys, id: \.self) { (key: IngredientType) in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(key.rawValue)
                            .font(.title)
                            .foregroundColor(Color("primaryText"))
                            .padding(.leading, 20)
                        ForEach(self.recipe.ingredients[key]!, id: \.self) { (ingredient: Ingredient) in
                            VStack {
                                EditableIngredientRow(name: ingredient.name,
                                                      notes: self.recipe.ingredients[key]?.first(where: {$0 == ingredient})!.notes ?? "",
                                                      onNamedEdited: { name in
                                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.name = name
                                                        
                                },
                                                      onNotesEdited: { notes in
                                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.notes = notes
                                                        
                                },
                                                      onDelete: {
                                                        self.recipe.removeIngredient(ingredient, with: key)
                                })
                                    .frame(height: 60)
                                    .background(Color("cardColor"))
                                    .mask(RoundedRectangle(cornerRadius: 10.0))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        HStack {
//                            Spacer()
                            AddIngredientButton(add: {
                                self.recipe.addIngredient(Ingredient(name: "", notes: nil, type: key), for: key)
                            })
                            Spacer()
                        }.padding(.leading, 20)
                    }
                }
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    CategorySelectionModal(makeNewCategory: self.$makeNewCategory, ingredients: self.recipe.ingredients, ingredientTypes: IngredientType.ingredientTypes, onCategorySelected: { type in
                        if !self.recipe.ingredients.keys.contains(type) {
                            self.recipe.addIngredientSection(type)
                            self.makeNewCategory = false
                        }
                    })
                    AddCategoryButton(makeNewCategory: self.$makeNewCategory, typesAvailable: recipe.ingredients.count < IngredientType.ingredientTypes.count, add: { self.makeNewCategory.toggle()
                    })
                }.padding(.trailing, 20)
            }.frame(alignment: .bottomTrailing)
                .padding(.bottom, 10)
//                .offset(y: 40)
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
