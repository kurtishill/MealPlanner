//
//  WeekSummaryChecklistView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct WeekIngredientChecklistView: View {
    @ObservedObject var recipeStore: AppState
    var date: CalendarDate
    var color: String
    
    var body: some View {
        let ingredients = recipeStore.getIngredientsForWeekDisplay()
        let keys = ingredients.keys.map {$0}.sorted()
        
        return VStack(alignment: .leading) {
            Group {
                Text("Week \(date.week.week.first!.day) - \(date.week.week.last!.day)")
                    .font(.title)
                    .bold()
                Divider()
            }.padding(.leading, 20)
                .padding(.trailing, 20)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(keys, id: \.self) { (type: Ingredient.IngredientType) in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(type.rawValue)
                            .font(.title)
                            .padding(.leading, 20)
                        ForEach(ingredients[type] ?? [], id: \.self) { (ingredient: Ingredient) in
                            IngredientChecklistRow(ingredient: ingredient, color: self.color, appState: self.recipeStore)
                                .onTapGesture {
                                    ingredient.isSelected.toggle()
                                    self.recipeStore.updateIngredient(ingredient)
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle("Grocery List")
    }
}

//struct WeekIngredientChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekSummaryChecklistView()
//    }
//}
