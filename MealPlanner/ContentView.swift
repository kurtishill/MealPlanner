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
    @EnvironmentObservedInject var appViewModel: AppViewModel
    
    private let yearFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.groupingSeparator = ""
        return nf
    }()
    
    var body: some View {
        return LoadingView(isShowing: self.appViewModel.calendarLoading) {
            NavigationView {
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Group {
                                if self.appViewModel.calendarState.calendar.value != nil {
                                    PageView(
                                        [CalendarView(index: 0).padding(.horizontal, 20),
                                         CalendarView(index: 1).padding(.horizontal, 20),
                                         CalendarView(index: 2).padding(.horizontal, 20)])
                                        .frame(height: 400)
//                                    CalendarView()
//                                        .padding(.horizontal, 20)
                                }
                            }
                            
                            Spacer(minLength: 30)
                            
                            Group {
                                HStack {
                                    Button(action: {
                                        self.appViewModel.calendarState.lastMonthTapped()
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.left")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color("primaryText"))
                                            Text("Last month")
                                                .font(.system(size: 15))
                                                .foregroundColor(Color("primaryText"))
                                        }
                                    }

                                    Spacer()

                                    Button(action: {
                                        self.appViewModel.calendarState.nextMonthTapped()
                                    }) {
                                        HStack {
                                            Text("Next month")
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
                                
                                if self.appViewModel.calendarState.calendar.value != nil {
                                    DaysLayout(dates: self.appViewModel.lists.keys.map { $0.self })
                                }
                                
                            }.padding(.leading, 20)
                        }
                    }
                }.navigationBarTitle(Text(self.appViewModel.calendarState.calendar.value == nil ? "" : "\(self.appViewModel.calendarState.calendar.value!.currMonthName!) \(self.yearFormatter.string(from:  NSNumber(value: self.appViewModel.calendarState.calendar.value!.currDate!.year.year))!)"))
            }
        }
    }
}

struct DaysLayout: View {
    let dates: [CalendarDate]
    
    @EnvironmentObservedInject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            if !dates.isEmpty {
                NavigationLink(
                    destination: WeekIngredientChecklistView(color: "purpleColor")
                ) {
                    HStack {
                        Text("Days' items")
                            .font(.system(size: 15))
                            .foregroundColor(Color("primaryText"))
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color("primaryText"))
                        ZStack {
                            Circle()
                                .foregroundColor(self.appViewModel.itemsForWeekNumber > 0 ? AppColors.primaryText : AppColors.backButton)
                                .shadow(radius: 2)
                            Text("\(self.appViewModel.itemsForWeekNumber)")
                                .foregroundColor(self.appViewModel.itemsForWeekNumber > 0 ? .white : .white)
                        }.frame(width: 25, height: 45)
                        Spacer()
                    }
                }
            }
            
            CardList(dates: dates)
        }
    }
}

struct CardList: View {
    let dates: [CalendarDate]
    
    var body: some View {
        VStack {
            ForEach(dates.sorted(by: {$0.day.day < $1.day.day}), id: \.id) { (date: CalendarDate) in
                RecipeOverviewCard(day: date.day, date: date)
            }
            
            if dates.isEmpty {
                GeometryReader { geo in
                    VStack {
                        HStack {
                            Spacer()
                            Text("Tap a day to see more")
                                .font(.subheadline)
                                .foregroundColor(AppColors.backButton)
                                .bold()
                                .padding(.top, geo.size.height * 5)
                                .padding(.trailing, 20)
                            Spacer()
                        }
                    }
                }
            }
        }.padding(.bottom, 10)
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
