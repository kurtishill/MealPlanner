//
//  IngredientChecklistRow.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct IngredientChecklistRow: View {
    var ingredient: Ingredient
    var color: String
    @ObservedObject var appState: AppState
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text(ingredient.name)
                    .font(.headline)
                    .foregroundColor(Color("primaryText"))
                HStack {
                    Text(ingredient.quantity == floor(ingredient.quantity) ? String(Int(ingredient.quantity)) : String(format: "%.2f", ingredient.quantity))
                        .font(.subheadline)
                        .foregroundColor(Color("secondaryCardText"))
                    Text(ingredient.measurementType ?? "")
                        .font(.subheadline)
                        .foregroundColor(Color("secondaryCardText"))
                }
            }.padding(.leading, 8)
            
            Spacer()
            
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(Color(self.color), lineWidth: 1))
                    .foregroundColor( Color.white)
                    .padding(.trailing, 8)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaleEffect(x: ingredient.isSelected ? 1 : 0.001, y: ingredient.isSelected ? 1 : 0.001)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(self.color))
                    .padding(.trailing, 8)
            }
            
        }.frame(height: 60)
            .background(ingredient.isSelected ? Color("cardColor") : Color("peachColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading, ingredient.isSelected ? 35 : 20)
            .padding(.trailing, ingredient.isSelected ? 0 : 20)
            .opacity(ingredient.isSelected ? 0.4 : 1)
            .animation(.spring())
    }
}

//struct IngredientChecklistRow_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientChecklistRow()
//    }
//}
