//
//  ContentView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var calendar: CalendarStore
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Group {
                            CalendarView(calendarStore: self.calendar)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 30)
                        
                        Group {
                            Text("Current week's recipes")
                                .font(.headline)
                                .foregroundColor(Color("primaryText"))
                                .bold()
                            NavigationLink(destination: WeekIngredientChecklistView(recipeStore: self.appState,
                                                                                    date: calendar.calendar.currDate!, color: "purpleColor")) {
                                                                                        HStack {
                                                                                            Text("Week's ingredients")
                                                                                                .font(.system(size: 15))
                                                                                                .foregroundColor(Color("primaryText"))
                                                                                            Image(systemName: "chevron.right")
                                                                                                .resizable()
                                                                                                .scaledToFit()
                                                                                                .frame(width: 10, height: 10)
                                                                                                .foregroundColor(Color("primaryText"))
                                                                                            Spacer()
                                                                                        }
                            }
                            
                            Spacer(minLength: 20)
                            
                            VStack {
                                ForEach(calendar.calendar.currDate!.week.week, id: \.id) { (day: CalendarDay) in
                                    RecipeOverviewCard(dayName: day.dayName!, day: day, date: self.calendar.calendar.currDate!).environmentObject(self.appState)
                                }
                            }
                        }.padding(.leading, 20)
                    }
                }
            }.navigationBarTitle(Text(calendar.calendar.currMonthName!))
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
