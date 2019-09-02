//
//  MiscWeeklyItemsChecklistView.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 9/1/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct MiscWeeklyItemsChecklistView: View {
    @ObservedObject var appState: AppState
    
    var color: String
    
    var body: some View {
        let keys = self.appState.itemsForWeek.keys.map {$0.self}
        
        return ScrollView(.vertical, showsIndicators: false) {
            ForEach(keys, id: \.self) { (key: IngredientType) in
                VStack(alignment: .leading, spacing: 8) {
                    Text(key.rawValue)
                        .font(.title)
                        .padding(.leading, 20)
                    ForEach(self.appState.itemsForWeek[key]!, id: \.self) { (ingredient: Ingredient) in
                        IngredientChecklistRow(ingredient: ingredient, color: self.color, appState: self.appState)
                            .onTapGesture {
                                ingredient.isSelected.toggle()
                                self.appState.updateIngredient(ingredient)
                        }
                    }
                }
            }
        }
    }
}

//struct MiscWeeklyItemsChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiscWeeklyItemsChecklistView()
//    }
//}
