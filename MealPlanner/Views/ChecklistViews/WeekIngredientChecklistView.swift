//
//  WeekSummaryChecklistView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/29/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI

struct WeekIngredientChecklistView: View {
    @EnvironmentObservedInject var appState: AppState
    var color: String
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = ""
        return nf
    }()
    
    var body: some View {
        let ingredients = appState.getIngredientsForWeekDisplay()
        let keys = ingredients.keys.map {$0}.sorted()
        let date = appState.calendarState.calendar.value!.currDate!
        
        return VStack(alignment: .leading) {
            Group {
                Text("\(Helper().monthToString(date.month.month)) \(date.week.week.first!.day) - \(date.week.week.last!.day), \(numberFormatter.string(for: date.year.year)!)")
                    .font(.title)
                    .bold()
                Divider()
            }.padding(.leading, 20)
                .padding(.trailing, 20)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(keys, id: \.self) { (type: IngredientType) in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(type.rawValue)
                            .font(.title)
                            .padding(.leading, 20)
                        ForEach(ingredients[type] ?? [], id: \.self) { (ingredient: Ingredient) in
                            IngredientChecklistRow(ingredient: ingredient, color: self.color)
                        }
                    }
                }
            }
        }.navigationBarTitle("Grocery List")
        .onAppear {
            self.appState.getIngredients()
        }.onDisappear {
            self.appState.fetchAllRecipesForWeek()
        }
    }
}

//struct WeekIngredientChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekSummaryChecklistView()
//    }
//}
