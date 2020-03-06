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
    @EnvironmentObservedInject var appState: AppState
    var color: String
    
    let calendarWidth = UIScreen.main.bounds.width - 60
    
    var body: some View {
        let calendar = appState.calendarState.calendar.value!
        let highlightWidth = (self.calendarWidth + 30.0) / 7.2 * (8.0 - (CGFloat(calendar.currDayOfWeek!)))
//        let hightlightXOffset = (CGFloat(self.calendarState.calendar.value!.currDayOfWeek!) - 1) * UIScreen.main.bounds.width / 15
        
        return VStack(alignment: .center, spacing: 40) {
            Group {
                DaysOfTheWeek(row: daysOfWeek)
                Divider()
            }
            Group {
                ForEach(calendar.weeks, id: \.id) { (week: CalendarWeek) in
                    ZStack {
                        if week.isCurrentWeek {
                            GeometryReader { geometry in
                                WeekHighlight(color: self.color)
                                    .frame(width: highlightWidth, height: 50)
                                    .offset(x: /*54 **/ CGFloat(calendar.currDayOfWeek! - 1) * geometry.size.width / 6.9, y: -geometry.size.height + 5)
                            }
                        }
                        WeekRow(week: week)
                            .frame(width: self.calendarWidth)
                    }
                }
            }
        }.padding(.top, 30)
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
                            .foregroundColor(day.isBeforeCurrentDay ? Color("secondaryText") :
                                (day.isCurrentDay ? Color("primaryText") :
                                    (self.week.isCurrentWeek ? .white :
                                        Color("primaryText")
                                    )
                                )
                            )
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
    var color: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(Color(color))
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
