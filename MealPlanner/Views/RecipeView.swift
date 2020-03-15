//
//  RecipeView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI
import RxSwift

struct RecipeView: View {
    @State var recipe: Recipe
    @State var draftRecipe: Recipe
    var color: String
    var day: CalendarDay
    
    @State var shouldDelete: Bool = false
    @State var dialogTitleText: String = ""
    @State var dialogSubTitleText: String = ""
    
    @EnvironmentObservedInject var appViewModel: AppViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.editMode) var editMode
    
    private var leadingButton: some View {
        Button(action: {
            if self.editMode?.wrappedValue == .inactive {
                self.appViewModel.fetchRecipe(with: self.recipe.id.uuidString)
                self.presentationMode.wrappedValue.dismiss()
            } else {
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
                                self.appViewModel.deleteIngredient(ingredient)
                            }
                        } else if !self.draftRecipe.ingredients[key]!.contains(ingredient) {
                            self.draftRecipe.ingredients[key]!.forEach { ingredient in
                                print(ingredient.id.uuidString)
                            }
                            print(ingredient.id.uuidString)
                            self.appViewModel.deleteIngredient(ingredient)
                        }
                    }
                }
                
                self.recipe = self.draftRecipe.copy() as! Recipe
                self.appViewModel.updateRecipe(self.recipe)
                self.editMode?.animation().wrappedValue = .inactive
            }
        }) {
            if self.editMode?.wrappedValue == .inactive {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 13, height: 22)
                    .foregroundColor(AppColors.secondaryText)
            } else {
                Text("Done")
            }
        }.foregroundColor(AppColors.main)
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
        }.foregroundColor(AppColors.main)
    }
    
    var body: some View {
        return VStack(alignment: .leading) {
            Group {
                HStack {
                    leadingButton
                    Spacer()
                    editButton
                }.frame(height: 40)
                HStack {
                    Text(recipe.shoppingList.type)
                        .font(.system(size: 35))
                        .foregroundColor(AppColors.primaryText)
                        .bold()
                    
                    Spacer()
                    
                    if self.editMode?.wrappedValue == .active {
                        Button(action: {
                            self.dialogTitleText = "Delete Shopping List"
                            self.dialogSubTitleText = "Are you sure?"
                            self.shouldDelete = true
                        }) {
                            Text("Delete List")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Divider()
            }.padding(.leading, 20)
                .padding(.trailing, 20)
            
            if self.editMode?.wrappedValue == .inactive {
                RecipeChecklistView(recipe: $recipe, color: self.color)
            } else {
                EditRecipeView(recipe: draftRecipe)
            }
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .alert(isPresented: self.$shouldDelete) {
            Alert(
                title: Text(self.dialogTitleText),
                message: Text(self.dialogSubTitleText),
                primaryButton: .destructive(Text("Delete List"), action: {
                    self.appViewModel.deleteRecipe(self.recipe)
                    self.presentationMode.wrappedValue.dismiss()
                    self.shouldDelete = false
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    self.shouldDelete = false
                })
            )
        }
    }
}

//struct RecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeView()
//    }
//}
