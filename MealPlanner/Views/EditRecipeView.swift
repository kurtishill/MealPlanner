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
    
    @State var listOffset: CGFloat = 0
    
    @State var canAnimate: Bool = false
    
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
                                EditableIngredientRow(
                                    id: ingredient.id.uuidString,
                                    name: ingredient.name,
                                    notes: self.recipe.ingredients[key]?.first(where: {$0 == ingredient})!.notes ?? "",
                                    onNameEdited: { name in
                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.name = name
                                },
                                    onNotesEdited: { notes in
                                        self.recipe.ingredients[key]?.first(where: {$0 == ingredient})?.notes = notes              
                                },
                                    onDelete: {
                                        self.recipe.removeIngredient(ingredient, with: key)
                                },
                                    listOffset: self.$listOffset,
                                    canAnimate: self.$canAnimate
                                )
                                    .frame(height: 60)
                                    .background(AppColors.card)
                                    .mask(RoundedRectangle(cornerRadius: 10.0))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        HStack {
                            AddIngredientButton(add: {
                                self.canAnimate = true
                                self.recipe.addIngredient(Ingredient(name: "", notes: nil, type: key), for: key)
                            })
                            Spacer()
                        }.padding(.leading, 20)
                    }.offset(y: -self.listOffset)
                        .animation(self.canAnimate ? .spring() : nil)
                        .padding(.bottom, 20)
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
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
