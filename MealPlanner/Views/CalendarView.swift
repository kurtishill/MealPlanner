//
//  CalendarView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import SwiftDI

let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]

struct CalendarView: View {
    @EnvironmentObservedInject var appViewModel: AppViewModel
    
    let calendarWidth = UIScreen.main.bounds.width - 60
    
    let index: Int
    
    var body: some View {
        let calendar = appViewModel.calendarState.calendars[index]
        
        return VStack(alignment: .center, spacing: 25) {
            Group {
                DaysOfTheWeek(row: daysOfWeek)
                Divider()
            }.frame(width: self.calendarWidth)
            
            VStack(spacing: 45) {
                Group {
                    ForEach(calendar.weeks, id: \.id) { (week: CalendarWeek) in
                        ZStack {
                            WeekRow(week: week) { day in
                                self.appViewModel.daySelected(day)
                            }
                        }
                    }
                }
            }
        }.padding(.top, 30)
            .padding(.bottom, 20)
    }
}

struct DaysOfTheWeek: View {
    var row: [String]
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                HStack {
                    Text(item)
                        .foregroundColor(AppColors.secondaryText)
                        .bold()
                    
                    if item != self.row.last! {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct WeekRow: View {
    var week: CalendarWeek
    var daySelected: (CalendarDay) -> Void
    
    var body: some View {
        return GeometryReader { geo in
            HStack {
                ForEach(self.week.week, id: \.id) { (day: CalendarDay) in
                    WeekDay(week: self.week, day: day, width: geo.size.width / 7, daySelected: self.daySelected)
                }
            }
        }.frame(width: UIScreen.main.bounds.width - 40)
            .fixedSize()
    }
}

struct WeekDay: View {
    let week: CalendarWeek
    let day: CalendarDay
    let width: CGFloat
    var daySelected: (CalendarDay) -> Void
    
    @EnvironmentObservedInject var weekDayViewModel: WeekDayViewModel
    
    var body: some View {
        if day.isPartOfCurrentMonth {
            self.weekDayViewModel.fetchIngredientCount(for: day)
        }
        
        return HStack(alignment: .center) {
            ZStack {
                Circle()
                    .foregroundColor(day.isSelected ? AppColors.primaryText : .clear)
                    .shadow(radius: 3)
                    .animation(.easeInOut(duration: 0.3))
                    .frame(width: width, height: 45)
                
                Text(String(day.day))
                    .foregroundColor(day.isSelected ? .white : day.isPartOfCurrentMonth ? AppColors.primaryText : AppColors.secondaryText)
                    .animation(.easeInOut(duration: 0.3))
                    .onTapGesture {
                        if self.day.isPartOfCurrentMonth {
                            self.daySelected(self.day)
                        }
                    }
                
                if self.weekDayViewModel.ingredientCount > 0 {
                    ZStack {
                        Circle()
                            .foregroundColor(AppColors.green)
                            .frame(width: 13, height: 13)
                        
                        Text("\(self.weekDayViewModel.ingredientCount)")
                            .foregroundColor(.white)
                            .font(.system(size: 9))
                    }.position(x: width / 1.3, y: 2.5)
                    .shadow(radius: 2)
                }
            }
            
            if day != self.week.week.last! {
                Spacer()
            }
        }.frame(width: width)
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
