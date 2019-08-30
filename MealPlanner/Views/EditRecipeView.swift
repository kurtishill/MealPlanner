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
                ForEach(keys, id: \.self) { (key: Ingredient.IngredientType) in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(key.rawValue)
                            .font(.title)
                            .foregroundColor(Color("primaryText"))
                            .padding(.leading, 20)
                        ForEach(self.recipe.ingredients[key]!, id: \.self) { (ingredient: Ingredient) in
                            VStack {
                                IngredientRow(name: ingredient.name,
                                              quantity: (self.recipe.ingredients[key]?.first(where: {$0 == ingredient})!.quantity)!,
                                              measurementType: self.recipe.ingredients[key]?.first(where: {$0 == ingredient})!.measurementType ?? "",
                                              recipe: self.recipe,
                                              key: key,
                                              ingredient: (self.recipe.ingredients[key]?.first(where: {$0 == ingredient}))!
                                ).frame(height: 60)
                                    .background(Color("cardColor"))
                                    .mask(RoundedRectangle(cornerRadius: 10.0))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        HStack {
                            Spacer()
                            AddIngredientButton(recipe: self.recipe, key: key)
                        }.padding(.trailing, 20)
                    }
                }
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    CategorySelectionModal(makeNewCategory: self.$makeNewCategory, recipe: self.recipe)
                    AddCategoryButton(makeNewCategory: self.$makeNewCategory, recipe: self.recipe)
                }.padding(.trailing, 20)
            }.frame(alignment: .bottomTrailing)
                .offset(y: 125)
        }
    }
}

struct CategorySelectionModal: View {
    @Binding var makeNewCategory: Bool
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(Ingredient.ingredientTypes, id: \.self) { type in
                Text(type.rawValue)
                    .foregroundColor(self.recipe.ingredients.keys.contains(type) ? .gray : .white)
                    .onTapGesture {
                        if !self.recipe.ingredients.keys.contains(type) {
                            self.recipe.addIngredientSection(type)
                            self.makeNewCategory = false
                        }
                }
            }
        }.frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 3, minHeight: 0, maxHeight: ((CGFloat(Ingredient.ingredientTypes.count) + 3) * 17))
            .background(Color("primaryText"))
            .cornerRadius(10)
            .shadow(radius: 3)
            .scaleEffect(self.makeNewCategory ? 1 : 0.001)
            .animation(.spring())
    }
}

struct IngredientRow: View {
    @State var name: String
    @State var quantity: Double
    @State var measurementType: String
    @ObservedObject var recipe: Recipe
    var key: Ingredient.IngredientType
    var ingredient: Ingredient
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.allowsFloats = true
        return nf
    }()
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                TextField("Name", text: self.$name, onEditingChanged: { _ in
                    self.recipe.ingredients[self.key]?.first(where: {$0 == self.ingredient})?.name = self.name
                }).autocapitalization(.none)
                    .padding(.all, 1)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .background(Color.white)
                    .mask(RoundedRectangle(cornerRadius: 5))
                HStack {
                    TextField("", value: self.$quantity, formatter: numberFormatter, onEditingChanged: { _ in
                        self.recipe.ingredients[self.key]?.first(where: {$0 == self.ingredient})?.quantity = self.quantity
                    })
                        .keyboardType(.decimalPad)
                        .padding(.all, 1)
                        .frame(width: 50)
                        .background(Color.white)
                        .mask(RoundedRectangle(cornerRadius: 5))
                    
                    TextField("", text: self.$measurementType, onEditingChanged: { _ in
                        self.recipe.ingredients[self.key]?.first(where: {$0 == self.ingredient})?.measurementType = self.measurementType
                    })
                        .autocapitalization(.none)
                        .padding(.all, 1)
                        .frame(width: 60)
                        .background(Color.white)
                        .mask(RoundedRectangle(cornerRadius: 5))
                    Spacer()
                }
            }.padding(.leading, 8)
            
            Button(action: {
                self.recipe.removeIngredient(self.ingredient, with: self.key)
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("mainColor"))
                    .padding(.trailing, 12)
            }
        }
    }
}

struct AddIngredientButton: View {
    @ObservedObject var recipe: Recipe
    var key: Ingredient.IngredientType
    
    var body: some View {
        Button(action: {
            self.recipe.addIngredient(Ingredient(name: "", quantity: 0.0, measurementType: nil, type: self.key), for: self.key)
        }) {
            Circle()
                .foregroundColor(Color("greenColor"))
                .frame(width: 40, height: 40)
                .overlay(Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white))
        }
    }
}

struct AddCategoryButton: View {
    @Binding var makeNewCategory: Bool
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        let typesAvailable = recipe.ingredients.count < Ingredient.ingredientTypes.count
        
        return Button(action: {
            if typesAvailable {
                self.makeNewCategory.toggle()
            }
        }) {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(typesAvailable ? Color("primaryText") : Color("backButton"))
                .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 6, minHeight: 0, maxHeight: 40)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: self.makeNewCategory ? 45 : 0))
                        .animation(.spring())
                )
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
