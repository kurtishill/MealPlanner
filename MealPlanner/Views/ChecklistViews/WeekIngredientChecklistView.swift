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
    @EnvironmentObservedInject var appViewModel: AppViewModel
    var color: String
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = ""
        return nf
    }()
    
    var body: some View {
        self.appViewModel.getIngredients()
        let ingredients = appViewModel.itemsForWeek
        let keys = ingredients.keys.map {$0}.sorted()
        
        return VStack(alignment: .leading) {
            Group {
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
        }.navigationBarTitle("Days' Items")
        .onDisappear {
            self.appViewModel.fetchAllRecipesForSelectedDays()
        }
    }
}

//struct WeekIngredientChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekSummaryChecklistView()
//    }
//}
