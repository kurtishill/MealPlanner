//
//  RecipeOverviewCard.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI

struct RecipeOverviewCard: View {
    @State var createShoppingList: Bool = false
    
    var day: CalendarDay
    var date: CalendarDate
    
    @EnvironmentObservedInject var appViewModel: AppViewModel
    
    let rowHeight: CGFloat = 250 / 3
    
    func makeRecipeRow(to recipe: Recipe) -> some View {
        let recipeCopy = recipe.copy() as! Recipe
        return RecipeRow(
            destination: RecipeView(
                recipe: recipe,
                draftRecipe: recipeCopy,
                color: "primaryText",
                day: self.day),
            recipe: recipe,
            height: self.rowHeight
        )
    }
    
    var body: some View {
        let lists = self.appViewModel.lists
        
        return HStack(alignment: .top, spacing: 10) {
            DateCard(
                day: day,
                dayName: day.dayName,
                rowHeight: rowHeight,
                createShoppingList: self.$createShoppingList
            )
            
            Group {
                if lists[date] != nil && !(lists[date]?.isEmpty ?? false) {
                    
                    VStack(spacing: 1) {
                    
                        ForEach(lists[date]!.keys.map { $0.self }, id: \.self) { shoppingList in
                        
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(AppColors.card)

                                self.makeRecipeRow(to: lists[self.date]![shoppingList]!!)

                                Divider()
                                    .offset(y: self.rowHeight)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                } else {
                    Spacer()
                }
            }.frame(width: UIScreen.main.bounds.width - 100)
                .padding(.trailing, 20)
        }.sheet(isPresented: self.$createShoppingList) {
            CreateShoppingListDialog(showDialog: self.$createShoppingList, date: self.date)
        }.frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width)
    }
}

struct DateCard: View {
    var day: CalendarDay
    var dayName: String
    var rowHeight: CGFloat
    @Binding var createShoppingList: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(AppColors.card)
            
            VStack(alignment: .center) {
                Spacer()
                Text(String(day.day))
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.primaryText)
                    .bold()
                Text(dayName)
                    .font(.footnote)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
                Text("Plan")
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: rowHeight)
                    .foregroundColor(.white)
                    .background(AppColors.primaryText)
                    .font(.footnote)
                    .cornerRadius(10)
            }
        }.frame(height: rowHeight)
            .onTapGesture {
                print("Plan was tapped for \(self.dayName)")
                self.createShoppingList = true
        }
    }
}

struct RecipeRow<T>: View where T : View {
    var destination: T
    var recipe: Recipe?
    var height: CGFloat
    
    var body: some View {
        var ingredientCount: Int = 0
        for (_, value) in recipe?.ingredients ?? [:] { ingredientCount += value.count }
        
        return VStack {
            NavigationLink(destination: destination) {
                HStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 5, height: height)
                        .foregroundColor(AppColors.primaryText)
                    VStack(alignment: .leading) {
                        Text(recipe?.shoppingList.type ?? "")
                            .foregroundColor(AppColors.primaryText)
                            .bold()
                            .padding(.top, 10)
                        Text("\(ingredientCount) item\(ingredientCount > 1 || ingredientCount == 0 ? "s" : "")")
                            .font(.subheadline)
                            .foregroundColor(AppColors.secondaryCardText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .lineLimit(nil)
                        Spacer()
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("primaryText"))
                        .padding(.trailing, 25)
                }
            }
        }
    }
}

//struct RecipeOverviewCard_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeOverviewCard()
//    }
//}
