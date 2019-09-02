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
                self.items = self.items.merging(self.draftItems) { _, new in new }
                self.appState.itemsForWeek = self.appState.itemsForWeek.merging(self.items) { _, new in new }
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
                self.draftItems = self.draftItems.merging(self.items) { _, new in new }
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
//            Spacer()
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
