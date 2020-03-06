//
//  IngredientChecklistRow.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 8/31/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI
import RxSwift

struct IngredientChecklistRow: View {
    var ingredient: Ingredient
    var color: String
    @EnvironmentObservedInject var appState: AppState
    
    @State var animationHack: Animation?
    
    private let bag = DisposeBag()
    
    var body: some View {
        HStack {
            HStack(alignment: .center) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text(ingredient.name)
                                .font(.headline)
                                .foregroundColor(Color("primaryText"))
                        }
                        
                        if ingredient.notes != nil {
                            HStack {
                                Text(ingredient.notes!)
                                    .frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
                                    .font(.subheadline)
                                    .foregroundColor(Color("secondaryCardText"))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                            }
                        }
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
            }
            
        }.frame(height: 40.0 + (ingredient.notes?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 80, font: UIFont.systemFont(ofSize: 17)) ?? 0.0))
            .background(ingredient.isSelected ? Color("cardColor") : Color("peachColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading, ingredient.isSelected ? 35 : 20)
            .padding(.trailing, ingredient.isSelected ? 0 : 20)
            .opacity(ingredient.isSelected ? 0.4 : 1)
            .animation(animationHack)
            .onTapGesture {
                self.ingredient.isSelected.toggle()
                self.appState.updateIngredient(self.ingredient)
        }.onAppear {
            Observable<NSInteger>.interval(RxTimeInterval.milliseconds(100), scheduler: MainScheduler())
                .take(1)
                .subscribe(onNext: { _ in
                    self.animationHack = .spring()
                }).disposed(by: self.bag)
        }
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

//struct IngredientChecklistRow_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientChecklistRow()
//    }
//}
