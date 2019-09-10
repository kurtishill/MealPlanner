//
//  EditableIngredientRow.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct EditableIngredientRow: View {
    @State var name: String
    @State var notes: String
    var onNamedEdited: (String) -> Void
    var onNotesEdited: (String) -> Void
    var onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                TextField("Name", text: self.$name, onEditingChanged: { _ in
                    self.onNamedEdited(self.name)
                }).autocapitalization(.none)
                    .padding(.all, 1)
                    .frame(width: UIScreen.main.bounds.width - 80)
                    .background(Color.white)
                    .mask(RoundedRectangle(cornerRadius: 5))
                HStack {
                    TextField("Notes", text: self.$notes, onEditingChanged: { _ in
                        self.onNotesEdited(self.notes)
                    })
                        .autocapitalization(.none)
                        .padding(.all, 1)
                        .frame(width: UIScreen.main.bounds.width - 80)
                        .background(Color.white)
                        .mask(RoundedRectangle(cornerRadius: 5))
                }
            }.padding(.leading, 8)
            
            Button(action: {
                self.onDelete()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("mainColor"))
                    .padding(.trailing, 12)
            }
        }
    }
}

//struct EditableIngredientRow_Previews: PreviewProvider {
//    static var previews: some View {
//        EditableIngredientRow()
//    }
//}
