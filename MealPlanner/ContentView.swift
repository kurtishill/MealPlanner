//
//  ContentView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI
import RxSwift

struct ContentView: View {
    private let bag = DisposeBag()
    @EnvironmentObservedInject var appState: AppState
    
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
        
        return LoadingView(isShowing: self.appState.calendarLoading) {
            NavigationView {
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Group {
                                if self.appState.calendarState.calendar.value != nil {
                                    CalendarView(color: highlightColor)
                                        .padding(.horizontal, 20)
                                }
                            }
                            
                            Spacer(minLength: 30)
                            
                            Group {
                                HStack {
                                    Button(action: {
                                        self.selectedWeek -= 1
                                        self.appState.calendarState.setCalendar(for: self.selectedWeek)
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
                                        self.appState.calendarState.setCalendar(for: self.selectedWeek)
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
                                    destination: WeekIngredientChecklistView(color: "purpleColor")
                                ) {
                                    HStack {
                                        Text("Week's items")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("primaryText"))
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color("primaryText"))
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color(self.appState.itemsForWeekNumber > 0 ? "yellowColor" : "greenColor"))
                                            Text("\(self.appState.itemsForWeekNumber)")
                                                .foregroundColor(self.appState.itemsForWeekNumber > 0 ? .black : .white)
                                        }.frame(width: 25, height: 25)
                                        Spacer()
                                    }
                                }
                                
                                
                                NavigationLink(
                                    destination: MiscWeeklyItemsView(
                                        items: self.appState.miscItems,
                                        draftItems: [:].merging(self.appState.miscItems) { _, new in new })
                                ) {
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
                                
                                if self.appState.calendarState.calendar.value != nil {
                                    CardList(calendar: self.appState.calendarState.calendar.value!)
                                }
                                
                            }.padding(.leading, 20)
                        }
                    }
                }.navigationBarTitle(Text(self.appState.calendarState.calendar.value == nil ? "" : self.appState.calendarState.calendar.value!.currMonthName!))
            }
        }
    }
}

struct CardList: View {
    var calendar: CalendarModel
    
    var body: some View {
        return VStack {
            ForEach(calendar.currDate!.week.week, id: \.id) { (day: CalendarDay) in
                RecipeOverviewCard(day: day, date: self.calendar.currDate!)
            }
        }.padding(.bottom, 10)
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
