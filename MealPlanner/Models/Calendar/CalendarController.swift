//
//  CalendarModel.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

extension Calendar {
    func getDay(from date: Date) -> Int {
        return self.component(.day, from: date)
    }
    
    func getDate(for weekOffset: Int, with currDate: Date) -> Date {
        return self.date(byAdding: .day, value: weekOffset * 7, to: currDate)!
    }
    
    func getDateOfMonthAgo(for date: Date) -> Date {
        return self.date(byAdding: .month, value: -1, to: date)!
    }
    
    func getMonth(for date: Date) -> Int {
        return self.component(.month, from: date)
    }
    
    func getWeek(for date: Date) -> Int {
        return self.component(.weekOfMonth, from: date)
    }
    
    func getStartOfMonthDate(for date: Date) -> Date {
        let comps = self.dateComponents([.year, .month], from: date)
        return self.date(from: comps)!
    }
    
    func getWeekday(for date: Date) -> Int {
        return self.component(.weekday, from: date)
    }
    
    func isSelectedMonthSameAsRealCurrentMonth(date1: Date, date2: Date) -> Bool {
        return self.component(.month, from: date1) == self.component(.month, from: date2)
    }
    
    func getCurrentDay(with weekOffset: Int, selectedDate: Date) -> (Int, Int) {
        var currDay: Int
        var currDayOfWeek: Int
        
        // if the selected week is not the real-world current week
        if weekOffset != 0 {
            if self.isSelectedMonthSameAsRealCurrentMonth(date1: selectedDate, date2: Date()) {
                currDay = self.getDay(from: Date())
            } else {
                currDay = 0
            }
            currDayOfWeek = 1 // start on Sunday
        } else {
            currDay = self.getDay(from: selectedDate)
            currDayOfWeek = self.getWeekday(for: selectedDate)
        }
        
        return (currDay, currDayOfWeek)
    }
    
    func getNumDaysInMonth(with date: Date) -> Range<Int> {
        return self.range(of: .day, in: .month, for: date)!
    }
}

import Foundation
import RxRelay
import RxSwift

class CalendarController {
    
    private let calendarRelay = PublishRelay<CalendarModel>()
    let calendarObservable: Observable<CalendarModel>
    
    init() {
        calendarObservable = calendarRelay.asObservable()
    }
    
    var counter: Int = 1
    
    func constructCalendar(month: Int?, year: Int?) {
        var weeks = [CalendarWeek]()
        var currMonthName: String
        var currDateLocal: CalendarDate
        
        let calendar = Calendar.current
        let currDate = Date()
        
        let actualYear: Int = calendar.component(.year, from: currDate)
        let actualMonth: Int = calendar.component(.month, from: currDate)
        
        let currYear: Int = year ?? actualYear
        let currMonth: Int = month ?? actualMonth
        
        let yearDate: Date = calendar.date(byAdding: .year, value: currYear - actualYear, to: currDate)!
        let monthDate: Date = calendar.date(byAdding: .month, value: currMonth - actualMonth, to: yearDate)!
        
        let lastMonthDate: Date = calendar.getDateOfMonthAgo(for: monthDate)
        
        let currMonthNum: Int = calendar.getMonth(for: monthDate)
        currMonthName = Helper.monthToString(currMonthNum)
        
        let startOfMonthDate: Date = calendar.getStartOfMonthDate(for: monthDate)
        let startOfMonthWeekday: Int = calendar.getWeekday(for: startOfMonthDate)
        
        let currDay: Int = calendar.component(.day, from: monthDate)
        
        let daysInCurrMonth: Range<Int> = calendar.getNumDaysInMonth(with: monthDate)
        let daysInLastMonth: Range<Int> = calendar.getNumDaysInMonth(with: lastMonthDate)
        
        let firstWeek = buildFirstWeekOfMonth(
            startOfMonthWeekday: startOfMonthWeekday,
            daysInLastMonth: daysInLastMonth,
            currDay: currDay
        )
        
        let firstCalendarWeek = CalendarWeek(week: firstWeek)
        
        weeks.append(firstCalendarWeek)
        
        // rest of the month
        
        weeks = buildRestOfMonth(
            currWeeks: weeks,
            daysInCurrMonth: daysInCurrMonth,
            currDay: currDay,
            calendar: calendar,
            currDate: currDate
        )
        
        // set days of the week for all days in the month
        weeks = setDayNames(for: weeks)
        
        currDateLocal = CalendarDate(
            year: CalendarYear(year: year ?? currYear),
            month: CalendarMonth(month: month ?? currMonth),
            day: CalendarDay(day: currDay, dayName: "")
        )
        
        let model = CalendarModel()
        model.weeks = weeks
        model.currMonthName = currMonthName
        model.currDate = currDateLocal
        
        self.calendarRelay.accept(model)
    }
    
    private func buildFirstWeekOfMonth(startOfMonthWeekday: Int, daysInLastMonth: Range<Int>, currDay: Int) -> [CalendarDay] {
        var firstWeek = [CalendarDay]()
        
        if startOfMonthWeekday > 1 {
            let daysFromLastMonth = [daysInLastMonth.last! - (startOfMonthWeekday - 2)...daysInLastMonth.last!]
            
            // first week
            for i in daysFromLastMonth.first!.lowerBound...daysFromLastMonth.first!.upperBound {
                let calendarDay = CalendarDay(day: i, dayName: "", isPartOfCurrentMonth: false)
                firstWeek.append(calendarDay)
            }
        }
        
        self.counter = 1
        while firstWeek.count < 7 {
            let calendarDay = CalendarDay(day: self.counter, dayName: "", isPartOfCurrentMonth: true, isCurrentDay: self.counter == currDay)
            firstWeek.append(calendarDay)
            self.counter += 1
        }
        
        return firstWeek
    }
    
    private func buildRestOfMonth(currWeeks: [CalendarWeek], daysInCurrMonth: Range<Int>, currDay: Int, calendar: Calendar, currDate: Date) -> [CalendarWeek] {
        var weeks = currWeeks
        var currMonthEnded = false
        
        // row
        for _ in 1..<6 {
            // column
            var dayList = [CalendarDay]()
            for _ in 0..<7 {
                if self.counter > daysInCurrMonth.last! { break }
                let calendarDay = CalendarDay(day: self.counter, dayName: "", isPartOfCurrentMonth: true, isCurrentDay: self.counter == currDay)
                dayList.append(calendarDay)
                self.counter += 1
            }
            
            // start of next month
            if dayList.count < 7 {
                self.counter = 1
                while dayList.count < 7 {
                    let calendarDay = CalendarDay(day: self.counter, dayName: "", isPartOfCurrentMonth: false)
                    dayList.append(calendarDay)
                    self.counter += 1
                }
                currMonthEnded = true
            }
            
            let calendarWeek = CalendarWeek(week: dayList)
            weeks.append(calendarWeek)
            
            if self.counter > daysInCurrMonth.last! { currMonthEnded = true }
            if currMonthEnded { break }
        }
        
        return weeks
    }
    
    private func setDayNames(for weeks: [CalendarWeek]) -> [CalendarWeek] {
        var newWeeks = weeks
        
        for weeksIndices in newWeeks.indices {
            for weekIndices in newWeeks[weeksIndices].week.indices {
                newWeeks[weeksIndices].week[weekIndices].dayName = Helper.dayNames[weekIndices]!
            }
        }
        
        return newWeeks
    }
    
    func clear(calendar: CalendarModel) {
        calendar.weeks = []
        calendar.currMonthName = nil
        calendar.currDayOfWeek = nil
        calendar.currDate = nil
        
        self.calendarRelay.accept(calendar)
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
