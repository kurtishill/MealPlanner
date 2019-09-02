//
//  AddIngredientButtonView.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct AddIngredientButton: View {
    var add: () -> Void
    
    var body: some View {
        Button(action: {
            self.add()
        }) {
            Circle()
            .foregroundColor(Color("greenColor"))
            .frame(width: 40, height: 40)
            .overlay(Image(systemName: "plus")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.white))
        }
    }
}

//struct AddIngredientButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddIngredientButtonView()
//    }
//}
