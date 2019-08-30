//
//  CalendarView.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]

struct CalendarView: View {
    var calendarStore: CalendarStore
    
    let calendarWidth = UIScreen.main.bounds.width - 60
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Group {
                DaysOfTheWeek(row: daysOfWeek)
                Divider()
            }
            Group {
                ForEach(calendarStore.calendar.weeks, id: \.id) { (week: CalendarWeek) in
                    ZStack {
                        if week.isCurrentWeek {
                            WeekHighlight()
                                .frame(width: (self.calendarWidth + 30) / 7 * (8 - (CGFloat(self.calendarStore.calendar.currDayOfWeek!))), height: 50)
                                .offset(x: (CGFloat(self.calendarStore.calendar.currDayOfWeek!) - 1) * 28)
                        }
                        WeekRow(week: week)
                            .frame(width: self.calendarWidth)
                    }
                }
            }
        }.frame(width: calendarWidth)
            .padding(.top, 30)
    }
}

struct DaysOfTheWeek: View {
    var row: [String]
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                HStack {
                    Text(item)
                        .foregroundColor(Color("secondaryText"))
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
    var body: some View {
        return HStack {
            ForEach(week.week, id: \.id) { (day: CalendarDay) in
                HStack(alignment: .center) {
                    ZStack {
                        Text(String(day.day))
                            .foregroundColor(day.isBeforeCurrentDay ? Color("secondaryText") : (day.isCurrentDay ? Color("primaryText") : (self.week.isCurrentWeek ? .white : Color("primaryText"))))
                    }
                    
                    if day != self.week.week.last! {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct WeekHighlight: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(Color("mainColor"))
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
