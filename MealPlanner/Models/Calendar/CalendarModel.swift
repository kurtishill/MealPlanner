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
    
    func constructCalendar(for weekOffset: Int = 0) {
        let calendar = Calendar.current
        
        var currDate = Date()
        var currDay = calendar.component(.day, from: currDate)
        currDate = calendar.date(byAdding: .day, value: weekOffset * 7, to: currDate)!
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: currDate)!
        
        let currMonth = calendar.component(.month, from: currDate)
        self.currMonthName = Helper().monthToString(currMonth)
        
        let currWeek = calendar.component(.weekOfMonth, from: currDate)
        var currWeekDay: Int
        
        let comps = calendar.dateComponents([.year, .month], from: currDate)
        let startOfMonthDate = calendar.date(from: comps)!
        let startOfMonthWeekday = calendar.component(.weekday, from: startOfMonthDate)
        if weekOffset != 0 {
            if calendar.component(.month, from: currDate) == calendar.component(.month, from: Date()) {
                currDay = calendar.component(.day, from: Date())
            } else {
                currDay = 0
            }
            currWeekDay = calendar.component(.weekday, from: startOfMonthDate)
            self.currDayOfWeek = 1 // start on Sunday
        } else {
            currDay = calendar.component(.day, from: currDate)
            currWeekDay = calendar.component(.weekday, from: currDate)
            self.currDayOfWeek = currWeekDay
        }
        
        let daysInCurrMonth = calendar.range(of: .day, in: .month, for: currDate)!
        let daysInLastMonth = calendar.range(of: .day, in: .month, for: lastMonthDate)!
        
        var firstWeek = [CalendarDay]()
        
        if startOfMonthWeekday > 1 {
            let daysFromLastMonth = [daysInLastMonth.last! - (startOfMonthWeekday - 2)...daysInLastMonth.last!]
            
            // first week
            for i in daysFromLastMonth.first!.lowerBound...daysFromLastMonth.first!.upperBound {
                let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: weekOffset > 0 ? false : true)
                firstWeek.append(calendarDay)
            }
        }
        
        var i = 1
        while firstWeek.count < 7 {
            let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: weekOffset < 0 ? true : i < currDay, isCurrentDay: i == currDay)
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
                let calendarDay = CalendarDay(day: i, isBeforeCurrentDay:  calendar.component(.month, from: currDate) == calendar.component(.month, from: Date()) ? i < currDay : weekOffset < 0 ? true : i < currDay, isCurrentDay: i == currDay)
                dayList.append(calendarDay)
                i += 1
            }
            
            // start of next month
            if dayList.count < 7 {
                i = 1
                while dayList.count < 7 {
                    let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: weekOffset < 0 ? true : false)
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
    
    func clear() {
        self.weeks = []
        self.currMonthName = nil
        self.currDayOfWeek = nil
        self.currDate = nil
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
