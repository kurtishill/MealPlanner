//
//  WeekSummaryChecklistView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct WeekIngredientChecklistView: View {
    @ObservedObject var appState: AppState
    var date: CalendarDate
    var color: String
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = ""
        return nf
    }()
    
    var body: some View {
        let ingredients = appState.getIngredientsForWeekDisplay()
        let keys = ingredients.keys.map {$0}.sorted()
        
        return VStack(alignment: .leading) {
            Group {
                Text("\(Helper().monthToString(date.month.month)) \(date.week.week.first!.day) - \(date.week.week.last!.day), \(numberFormatter.string(for: date.year.year)!)")
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
                            IngredientChecklistRow(ingredient: ingredient, color: self.color, appState: self.appState)
                                .onTapGesture {
                                    ingredient.isSelected.toggle()
                                    self.appState.updateIngredient(ingredient)
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
