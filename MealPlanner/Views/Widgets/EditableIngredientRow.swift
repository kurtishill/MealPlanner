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
    @State var quantity: Double
    @State var measurementType: String
    var onNamedEdited: (String) -> Void
    var onQuantityEdited: (Double) -> Void
    var onMeasurementTypeEdited: (String) -> Void
    var onDelete: () -> Void
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.allowsFloats = true
        return nf
    }()
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                TextField("Name", text: self.$name, onEditingChanged: { _ in
                    self.onNamedEdited(self.name)
                }).autocapitalization(.none)
                    .padding(.all, 1)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .background(Color.white)
                    .mask(RoundedRectangle(cornerRadius: 5))
                HStack {
                    TextField("Amount", value: self.$quantity, formatter: numberFormatter, onEditingChanged: { _ in
                        self.onQuantityEdited(self.quantity)
                    })
                        .keyboardType(.decimalPad)
                        .padding(.all, 1)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .background(Color.white)
                        .mask(RoundedRectangle(cornerRadius: 5))
                    
                    TextField("Measurement", text: self.$measurementType, onEditingChanged: { _ in
                        self.onMeasurementTypeEdited(self.measurementType)
                    })
                        .autocapitalization(.none)
                        .padding(.all, 1)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .background(Color.white)
                        .mask(RoundedRectangle(cornerRadius: 5))
                    Spacer()
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
