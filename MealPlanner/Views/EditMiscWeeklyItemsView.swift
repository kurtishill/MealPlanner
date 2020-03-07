//
//  EditMiscWeeklyItemsView.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 9/1/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct EditMiscWeeklyItemsView: View {
    @Binding var items: [IngredientType:[Ingredient]]
    @State var makeNewCategory = false
    @State var listOffset: CGFloat = 0
    
    var body: some View {
        let keys = items.keys.map {$0.self}.sorted()
        
        return ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(keys, id: \.self) { (key: IngredientType) in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(key.rawValue)
                            .font(.title)
                            .foregroundColor(Color("primaryText"))
                            .padding(.leading, 20)
                        ForEach(self.items[key]!, id: \.self) { (ingredient: Ingredient) in
                            VStack {
                                EditableIngredientRow(
                                    id: ingredient.id.uuidString,
                                    name: ingredient.name,
                                    notes: self.items[key]?.first(where: {$0 == ingredient})!.notes ?? "",
                                    onNameEdited: { name in
                                        self.items[key]?.first(where: {$0 == ingredient})?.name = name
                                },
                                    onNotesEdited: { notes in
                                        self.items[key]?.first(where: {$0 == ingredient})?.notes = notes
                                                        
                                },
                                    onDelete: {
                                        self.items[key]?.remove(at: (self.items[key]?.firstIndex(of: ingredient))!)
                                },
                                    listOffset: self.$listOffset
                                )
                                    .frame(height: 60)
                                    .background(Color("cardColor"))
                                    .mask(RoundedRectangle(cornerRadius: 10.0))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                            }
                        }
                        HStack {
                            AddIngredientButton(add: {
                                if self.items[key] == nil {
                                    self.items[key] = [Ingredient]()
                                }
                                self.items[key]?.append(Ingredient(name: "", notes: nil, type: key))
                            })
                            Spacer()
                        }.padding(.leading, 20)
                    }.offset(y: -self.listOffset)
                        .animation(.spring())
                }
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    CategorySelectionModal(makeNewCategory: self.$makeNewCategory, ingredients: self.items, ingredientTypes: IngredientType.weeklyItemTypes, onCategorySelected: { type in
                        if !self.items.keys.contains(type) {
                            self.items[type] = []
                            self.makeNewCategory = false
                        }
                    })
                    AddCategoryButton(makeNewCategory: self.$makeNewCategory, typesAvailable: self.items.count < IngredientType.weeklyItemTypes.count, add: { self.makeNewCategory.toggle()
                    })
                }.padding(.trailing, 20)
                    .frame(minHeight: 0, maxHeight: ((CGFloat(IngredientType.weeklyItemTypes.count) + 3) * 20))
            }.frame(alignment: .bottomTrailing)
                .padding(.bottom, 10)
        }
    }
}

//struct EditMiscWeeklyItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditMiscWeeklyItemsView()
//    }
//}
