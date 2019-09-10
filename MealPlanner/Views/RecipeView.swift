//
//  RecipeView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    @State var recipe: Recipe
    @State var draftRecipe: Recipe
    var color: String
    var day: CalendarDay
    
    @State var recipeTitle: String = ""
    
    @EnvironmentObject var appState: AppState
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.editMode) var editMode
    
    private var leadingButton: some View {
        Button(action: {
            if self.editMode?.wrappedValue == .inactive {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                self.draftRecipe.title = self.recipeTitle
                self.draftRecipe.date.day = self.day
                for (key, _) in self.draftRecipe.ingredients {
                    self.draftRecipe.ingredients[key] = self.draftRecipe.ingredients[key]?.filter({$0.name != ""})
                    if self.draftRecipe.ingredients[key]!.isEmpty {
                        self.draftRecipe.ingredients[key] = nil
                    }
                }
                
                for (key, ingredients) in self.recipe.ingredients {
                    for ingredient in ingredients {
                        if self.draftRecipe.ingredients[key] == nil {
                            for ingredient in self.recipe.ingredients[key]! {
                                self.appState.deleteIngredient(with: ingredient.id.uuidString)
                            }
                        }
                        else if !self.draftRecipe.ingredients[key]!.contains(ingredient) {
                            self.appState.deleteIngredient(with: ingredient.id.uuidString)
                        }
                    }
                }
                
                self.recipe = self.draftRecipe.copy() as! Recipe
                self.appState.updateRecipe(self.recipe)
                self.editMode?.animation().wrappedValue = .inactive
            }
        }) {
            if self.editMode?.wrappedValue == .inactive {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 13, height: 22)
                    .foregroundColor(Color("secondaryText"))
            } else {
                Text("Done")
            }
        }.foregroundColor(Color("mainColor"))
    }
    
    private var editButton: some View {
        Button(action: {
            if self.editMode?.wrappedValue == .inactive {
                self.editMode?.animation().wrappedValue = .active
            } else {
                self.editMode?.animation().wrappedValue = .inactive
                self.draftRecipe = self.recipe.copy() as! Recipe
            }
        }) {
            if self.editMode?.wrappedValue == .inactive {
                Text("Edit")
            } else {
                Text("Cancel")
            }
        }.foregroundColor(Color("mainColor"))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    leadingButton
                    Spacer()
                    editButton
                }.frame(height: 40)
                Text(recipe.category.rawValue)
                    .font(.system(size: 35))
                    .foregroundColor(Color("primaryText"))
                    .bold()
                if self.editMode?.wrappedValue == .inactive {
                    Text(recipe.title)
                        .font(.system(size: 25))
                        .foregroundColor(Color(color))
                        .bold()
                } else {
                    TextField("Title", text: self.$recipeTitle, onEditingChanged: { _ in
                        self.draftRecipe.title = self.recipeTitle
                    }).padding(.all, 5)
                        .background(Color("textFieldColor"))
                        .mask(RoundedRectangle(cornerRadius: 5))
                }
                Divider()
            }.padding(.leading, 20)
                .padding(.trailing, 20)
            
            if self.editMode?.wrappedValue == .inactive {
                RecipeChecklistView(recipe: $recipe, appState: appState, color: self.color)
            } else {
                EditRecipeView(recipe: draftRecipe)
            }
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .onAppear {
                self.recipeTitle = self.draftRecipe.title
        }
    }
}

//struct RecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeView()
//    }
//}
