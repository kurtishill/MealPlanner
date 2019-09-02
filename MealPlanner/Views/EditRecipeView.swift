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
        let keys = recipe.ingredients.keys.map {$0.self}
        
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
                                                      quantity: (self.recipe.ingredients[key]?.first(where: {$0 == ingredient})!.quantity)!,
                                                      measurementType: self.recipe.ingredients[key]?.first(where: {$0 == ingredient})!.measurementType ?? "",
                                                      onNamedEdited: { name in
                                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.name = name
                                                        
                                },
                                                      onQuantityEdited: { quantity in
                                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.quantity = quantity
                                },
                                                      onMeasurementTypeEdited: { measurementType in
                                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.measurementType = measurementType
                                                        
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
                            Spacer()
                            AddIngredientButton(add: {
                                self.recipe.addIngredient(Ingredient(name: "", quantity: 0.0, measurementType: nil, type: key), for: key)
                            })
                        }.padding(.trailing, 20)
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
                .offset(y: 40)
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
