//
//  AddCategoryButtonView.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct AddCategoryButton: View {
    @Binding var makeNewCategory: Bool
    var typesAvailable: Bool
    var add: () -> Void
    
    var body: some View {
        Button(action: {
            if self.typesAvailable {
                self.makeNewCategory.toggle()
            }
        }) {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(typesAvailable ? AppColors.primaryText : AppColors.backButton)
            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 6, minHeight: 0, maxHeight: 40)
            .overlay(
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: self.makeNewCategory ? 45 : 0))
                    .animation(.spring())
            )
        }
    }
}

//struct AddCategoryButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCategoryButtonView()
//    }
//}
