//
//  CalendarModel.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class CalendarModel {
    var weeks: [CalendarWeek] = []
    
    var currMonthName: String?
    var currDayOfWeek: Int?
    
    var currDate: CalendarDate?
    
    func constructCalendar() {
        let calendar = Calendar.current
        
        let currDate = Date()
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: currDate)!
        
        let currMonth = calendar.component(.month, from: currDate)
        self.currMonthName = Helper().monthToString(currMonth)
        
        let currWeek = calendar.component(.weekOfMonth, from: currDate)
        let currDay = calendar.component(.day, from: currDate)
        let currWeekDay = calendar.component(.weekday, from: currDate)
        self.currDayOfWeek = currWeekDay
        
        let daysInCurrMonth = calendar.range(of: .day, in: .month, for: currDate)!
        let daysInLastMonth = calendar.range(of: .day, in: .month, for: lastMonthDate)!
        
        let daysFromLastMonth = [daysInLastMonth.last! + (currWeekDay - 3) - currWeekDay...daysInLastMonth.last!]
        
        // first week
        
        var firstWeek = [CalendarDay]()
        for i in daysFromLastMonth.first!.lowerBound...daysFromLastMonth.first!.upperBound {
            let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: true)
            firstWeek.append(calendarDay)
        }
        
        var i = 1
        while firstWeek.count < 7 {
            let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: i < currDay, isCurrentDay: i == currDay)
            firstWeek.append(calendarDay)
            i += 1
        }
        
        let firstCalendarWeek = CalendarWeek(week: firstWeek, isCurrentWeek: currWeek == 1)
        
        self.weeks.append(firstCalendarWeek)
        
        // rest of the month
        
        // row
        for week in 1..<5 {
            // column
            var dayList = [CalendarDay]()
            for _ in 0..<7 {
                if i > daysInCurrMonth.last! { break }
                let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: i < currDay, isCurrentDay: i == currDay)
                dayList.append(calendarDay)
                i += 1
            }
            
            if dayList.count < 7 {
                i = 1
                while dayList.count < 7 {
                    let calendarDay = CalendarDay(day: i)
                    dayList.append(calendarDay)
                    i += 1
                }
            }
            
            let calendarWeek = CalendarWeek(week: dayList, isCurrentWeek: week + 1 == currWeek)
            self.weeks.append(calendarWeek)
            
        }
        
        // set days of the week for all days in the month
        for weeksIndices in self.weeks.indices {
            for weekIndices in self.weeks[weeksIndices].week.indices {
                self.weeks[weeksIndices].week[weekIndices].dayName = Helper.dayNames[weekIndices]
            }
        }
        
        self.currDate = CalendarDate(year: CalendarYear(year: calendar.component(.year, from: currDate)), month: CalendarMonth(month: currMonth), week: self.weeks.first(where: {$0.isCurrentWeek})!, day: CalendarDay(day: currDay))
    }
}

/**
 currWeekDay
 1 -> Sun
 2 -> Mon
 3 -> Tues
 4 -> Wed
 5 -> Thurs
 6 -> Fri
 7 -> Sat
 */
