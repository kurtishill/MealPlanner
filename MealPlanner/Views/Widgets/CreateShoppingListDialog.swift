//
//  CreateShoppingListDialog.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/11/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI

struct CreateShoppingListDialog: View {
    @Binding var showDialog: Bool
    var date: CalendarDate
    
    @State var shoppingListName: String = ""
    
    @EnvironmentInject var appViewModel: AppViewModel
    
    var body: some View {
        let nameBinding = Binding<String>(get: {
            self.shoppingListName
        }, set: {
            self.shoppingListName = $0
        })
        
        return VStack(alignment: .leading, spacing: 15) {
            Text("Create Shopping List")
                .font(.title)
                .foregroundColor(AppColors.primaryText)
                .bold()
            
            Text("for \(self.date.description)")
                .font(.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextField("Shopping List", text: nameBinding)
                .padding(.all, 5)
                .background(AppColors.textField)
                .mask(RoundedRectangle(cornerRadius: 5))
            
            Text("For example \"Breakfast\", \"Grocery Store\", \"Costco\"")
                .font(.subheadline)
                .foregroundColor(AppColors.secondaryText)
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.showDialog = false
                }) {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(AppColors.backButton)
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 3, minHeight: 0, maxHeight: 40)
                    .overlay(
                        Text("Cancel")
                            .foregroundColor(.white)
                    )
                }
                
                Spacer()
                
                Button(action: {
                    self.appViewModel.createRecipe(name: self.shoppingListName, for: self.date)
                    self.showDialog = false
                }) {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(self.shoppingListName.isEmpty ? AppColors.peach : AppColors.main)
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 3, minHeight: 0, maxHeight: 40)
                    .overlay(
                        Text("Create")
                            .foregroundColor(.white)
                    )
                }.disabled(self.shoppingListName.isEmpty)
                
                Spacer()
            }.padding(.top, 15)
            
            Spacer()
        }.frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.height / 2)
    }
}

//struct CreateShoppingListDialog_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateShoppingListDialog()
//    }
//}
