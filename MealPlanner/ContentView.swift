//
//  ContentView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var calendar: CalendarState
    @EnvironmentObject var appState: AppState
    
    @State var selectedWeek: Int = 0
    
    var body: some View {
        var highlightColor: String
        if self.selectedWeek < 0 {
            highlightColor = "greenColor"
        } else if self.selectedWeek == 0 {
            highlightColor = "mainColor"
        } else {
            highlightColor = "purpleColor"
        }
        
        return NavigationView {
            ZStack(alignment: .topLeading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Group {
                            CalendarView(color: highlightColor)
                                .environmentObject(self.calendar)
                                .padding(.horizontal, 20)
                                .animation(.spring())
                        }
                        
                        Spacer(minLength: 30)
                        
                        Group {
                            HStack {
                                Button(action: {
                                    self.selectedWeek -= 1
                                    self.calendar.setCalendar(for: self.selectedWeek)
                                    self.appState.date = self.calendar.calendar.currDate!
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.left")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color("primaryText"))
                                        Text("Previous week")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("primaryText"))
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    self.selectedWeek += 1
                                    self.calendar.setCalendar(for: self.selectedWeek)
                                    self.appState.date = self.calendar.calendar.currDate!
                                }) {
                                    HStack {
                                        Text("Next week")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("primaryText"))
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color("primaryText"))
                                    }
                                }
                            }.padding(.trailing, 20)
                            
                            NavigationLink(
                                destination: WeekIngredientChecklistView(appState: self.appState,
                                                                         date: calendar.calendar.currDate!,
                                                                         color: "purpleColor"
                                )
                            ) {
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
                            
                            NavigationLink(destination: MiscWeeklyItemsView(date: calendar.calendar.currDate!, items: self.appState.itemsForWeek, draftItems: [:].merging(self.appState.itemsForWeek) { _, new in new }).environmentObject(self.appState)) {
                                HStack {
                                    Text("Miscellaneous items for the week")
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
                            
                            Text("Current week's recipes")
                                .font(.headline)
                                .foregroundColor(Color("primaryText"))
                                .bold()
                            
                            Spacer(minLength: 20)
                            
                            CardList(calendar: self.calendar, appState: self.appState)
                            
                        }.padding(.leading, 20)
                    }
                }
            }.navigationBarTitle(Text(calendar.calendar.currMonthName!))
        }
    }
}

struct CardList: View {
    @ObservedObject var calendar: CalendarState
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack {
            ForEach(calendar.calendar.currDate!.week.week, id: \.id) { (day: CalendarDay) in
                RecipeOverviewCard(dayName: day.dayName!, day: day, date: self.calendar.calendar.currDate!, appState: self.appState)
            }
        }.padding(.bottom, 10)
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
