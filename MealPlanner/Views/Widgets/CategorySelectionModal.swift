//
//  CategorySelectionModal.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct CategorySelectionModal: View {
    @Binding var makeNewCategory: Bool
    var ingredients: [IngredientType:[Ingredient]]
    var ingredientTypes: [IngredientType]
    var onCategorySelected: (IngredientType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(ingredientTypes, id: \.self) { type in
                Text(type.rawValue)
                    .foregroundColor(self.ingredients.keys.contains(type) ? .gray : .white)
                    .onTapGesture {
                        self.onCategorySelected(type)
                }
            }
        }.frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 3, minHeight: 0, maxHeight: ((CGFloat(ingredientTypes.count) + 3) * 20))
            .background(Color("primaryText"))
            .cornerRadius(10)
            .shadow(radius: 3)
            .scaleEffect(self.makeNewCategory ? 1 : 0.001)
            .animation(.spring())
    }
}

//struct CategorySelectionModal_Previews: PreviewProvider {
//    static var previews: some View {
//        CategorySelectionModal()
//    }
//}
