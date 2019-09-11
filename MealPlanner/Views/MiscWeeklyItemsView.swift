//
//  MiscWeeklyItemsView.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct MiscWeeklyItemsView: View {
    var date: CalendarDate
    @State var items: [IngredientType:[Ingredient]]
    @State var draftItems: [IngredientType:[Ingredient]]
    
    @EnvironmentObject var appState: AppState
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.editMode) var editMode
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = ""
        return nf
    }()
    
    private var leadingButton: some View {
        Button(action: {
            if self.editMode?.wrappedValue == .inactive {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                
                for (key, _) in self.draftItems {
                    self.draftItems[key] = self.draftItems[key]?.filter({$0.name != ""})
                    if self.draftItems[key]!.isEmpty {
                        self.draftItems[key] = nil
                    }
                }
                
                for (key, ingredients) in self.items {
                    for ingredient in ingredients {
                        if self.draftItems[key] == nil {
                            for ingredient in self.items[key]! {
                                self.appState.deleteIngredient(with: ingredient.id.uuidString)
                            }
                        }
                        else if !self.draftItems[key]!.contains(ingredient) {
                            self.appState.deleteIngredient(with: ingredient.id.uuidString)
                        }
                    }
                }
                
                self.items = self.draftItems
                self.appState.itemsForWeek = self.items
                for (_, ingredients) in self.items {
                    for ingredient in ingredients {
                        self.appState.createIngredientForWeek(ingredient)
                    }
                }
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
                self.draftItems = [:]
                self.draftItems = self.items
                self.editMode?.animation().wrappedValue = .inactive
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
            }.padding(.leading, 20)
                .padding(.trailing, 20)
            Group {
                Text("Miscellaneous Items")
                    .font(.system(size: 35))
                    .foregroundColor(Color("primaryText"))
                    .bold()
                Text("\(Helper().monthToString(date.month.month)) \(date.week.week.first!.day) - \(date.week.week.last!.day), \(numberFormatter.string(for: date.year.year)!)")
                    .font(.system(size: 25))
                    .foregroundColor(Color("secondaryText"))
                Divider()
            }.padding(.leading, 20)
                .padding(.trailing, 20)
            
            if self.editMode?.wrappedValue == .inactive {
                MiscWeeklyItemsChecklistView(appState: self.appState, color: "purpleColor")
            } else {
                EditMiscWeeklyItemsView(items: self.$draftItems)
            }
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
    }
}

//struct MiscWeeklyItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiscWeeklyItemsView()
//    }
//}
