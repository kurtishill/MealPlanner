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
    var day: CalendarDay
    var date: CalendarDate
    
    @EnvironmentObservedInject var appState: AppState
    
    let cardHeight: CGFloat = 250
    
    var body: some View {
        let breakfastCopy: Recipe = appState.getRecipe(for: day.day, with: Recipe.Category.Breakfast)?.copy() as? Recipe ?? Recipe(
            id: nil,
            category: Recipe.Category.Breakfast,
            title: "",
            ingredients: [:],
            date: date
        )
        
        let lunchCopy: Recipe = appState.getRecipe(for: day.day, with: Recipe.Category.Lunch)?.copy() as? Recipe ?? Recipe(
            id: nil,
            category: Recipe.Category.Lunch,
            title: "",
            ingredients: [:],
            date: date
        )
        
        let dinnerCopy: Recipe = appState.getRecipe(for: day.day, with: Recipe.Category.Dinner)?.copy() as? Recipe ?? Recipe(
            id: nil,
            category: Recipe.Category.Dinner,
            title: "",
            ingredients: [:],
            date: date
        )
        
        return HStack(alignment: VerticalAlignment.top) {
            DateCard(day: day, dayName: day.dayName!, cardHeight: cardHeight)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width - 100, height: self.cardHeight)
                    .foregroundColor(AppColors.card)
                    .padding(.trailing, 20)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    RecipeRow(
                        destination: RecipeView(
                            recipe: breakfastCopy,
                            draftRecipe: breakfastCopy.copy() as! Recipe,
                            color: "greenColor",
                            day: day
                        ),
                        color: "greenColor",
                        recipe: breakfastCopy,
                        height: cardHeight / 3
                    )

                    RecipeRow(
                        destination: RecipeView(
                            recipe: lunchCopy,
                            draftRecipe: lunchCopy.copy() as! Recipe,
                            color: "yellowColor",
                            day: day
                        ),
                        color: "yellowColor",
                        recipe: lunchCopy,
                        height: cardHeight / 3
                    )

                    RecipeRow(
                        destination: RecipeView(
                            recipe: dinnerCopy,
                            draftRecipe: dinnerCopy.copy() as! Recipe,
                            color: "purpleColor",
                            day: day
                        ),
                        color: "purpleColor",
                        recipe: dinnerCopy,
                        height: cardHeight / 3
                    )
                }
                
                VStack {
                    Divider()
                        .offset(y: cardHeight / 3)
                        .padding(.trailing, 20)
                    Divider()
                        .offset(y: cardHeight / 3 * 2 - 9)
                        .padding(.trailing, 20)
                }
            }
        }
    }
}

struct DateCard: View {
    var day: CalendarDay
    var dayName: String
    var cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(day.isCurrentDay ? AppColors.main : AppColors.card)
            
            VStack(alignment: .center) {
                Spacer()
                Text(String(day.day))
                    .font(.system(size: 15))
                    .foregroundColor(day.isCurrentDay ? .white : AppColors.primaryText)
                    .bold()
                Text(dayName)
                    .font(.footnote)
                    .foregroundColor(day.isCurrentDay ? .white : AppColors.primaryText)
                Spacer()
                Text("Plan")
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: cardHeight / 3)
                    .foregroundColor(.white)
                    .background(AppColors.primaryText)
                    .font(.footnote)
                    .cornerRadius(10)
            }
        }.frame(height: cardHeight / 3)
            .onTapGesture {
                print("Plan was tapped for \(self.dayName)")
        }
    }
}

struct RecipeRow<T>: View where T : View {
    var destination: T
    var color: String
    var recipe: Recipe?
    var height: CGFloat
    
    var body: some View {
        VStack {
            NavigationLink(destination: destination) {
                HStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 5, height: height)
                        .foregroundColor(Color(color))
                    VStack(alignment: .leading) {
                        Text(recipe?.category.rawValue ?? "")
                            .foregroundColor(Color(color))
                            .bold()
                            .padding(.top, 10)
                        Text(recipe?.title ?? "")
                            .font(.subheadline)
                            .foregroundColor(AppColors.secondaryCardText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .lineLimit(nil)
                        Spacer()
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("primaryText"))
                        .padding(.trailing, 35)
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
