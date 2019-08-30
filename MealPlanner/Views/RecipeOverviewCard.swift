//
//  RecipeOverviewCard.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct RecipeOverviewCard: View {
    var dayName: String
    var day: CalendarDay
    var date: CalendarDate
    
    @ObservedObject var appState: AppState
    
    let cardHeight: CGFloat = 250
    
    var body: some View {
        let breakfastCopy: Recipe = appState.getRecipe(for: day.day, with: Recipe.Category.Breakfast)?.copy() as? Recipe ?? Recipe(category: Recipe.Category.Breakfast, title: "", ingredients: [:], date: date)
        let lunchCopy: Recipe = appState.getRecipe(for: day.day, with: Recipe.Category.Lunch)?.copy() as? Recipe ?? Recipe(category: Recipe.Category.Lunch, title: "", ingredients: [:], date: date)
        let dinnerCopy: Recipe = appState.getRecipe(for: day.day, with: Recipe.Category.Dinner)?.copy() as? Recipe ?? Recipe(category: Recipe.Category.Dinner, title: "", ingredients: [:], date: date)
        
        return HStack(alignment: VerticalAlignment.top) {
            DateCard(day: day, dayName: dayName, cardHeight: cardHeight)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width - 100, height: self.cardHeight)
                    .foregroundColor(Color("cardColor"))
                    .padding(.trailing, 20)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    RecipeRow(destination: RecipeView(recipe: breakfastCopy, draftRecipe: breakfastCopy.copy() as! Recipe, color: "greenColor", day: day).environmentObject(appState), color: "greenColor", recipe: breakfastCopy, height: cardHeight / 3)

                    RecipeRow(destination: RecipeView(recipe: lunchCopy, draftRecipe: lunchCopy.copy() as! Recipe, color: "yellowColor", day: day).environmentObject(appState), color: "yellowColor", recipe: lunchCopy, height: cardHeight / 3)

                    RecipeRow(destination: RecipeView(recipe: dinnerCopy, draftRecipe: dinnerCopy.copy() as! Recipe, color: "purpleColor", day: day).environmentObject(appState), color: "purpleColor", recipe: dinnerCopy, height: cardHeight / 3)
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
                .foregroundColor(Color(day.isCurrentDay ? "mainColor" : "cardColor"))
            
            VStack(alignment: .center) {
//                Spacer()
                Text(String(day.day))
                    .font(.system(size: 24))
                    .foregroundColor(day.isCurrentDay ? .white : Color("primaryText"))
                    .bold()
                Text(dayName)
                    .font(.footnote)
                    .foregroundColor(day.isCurrentDay ? .white : Color("primaryText"))
//                Spacer()
//                Text("Plan")
//                    .bold()
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: cardHeight / 3)
//                    .foregroundColor(.white)
//                    .background(Color("primaryText"))
//                    .font(.footnote)
//                    .cornerRadius(10)
            }
        }.frame(height: cardHeight / 3)
    }
}

struct RecipeRow<T: View>: View {
    var destination: T
    var color: String
    var recipe: Recipe?
    var height: CGFloat
    
    var body: some View {
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
                        .foregroundColor(Color("secondaryCardText"))
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

//struct RecipeOverviewCard_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeOverviewCard()
//    }
//}
