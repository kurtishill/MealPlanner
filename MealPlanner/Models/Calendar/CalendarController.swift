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
    
    private func buildFirstWeekOfMonth(startOfMonthWeekday: Int, daysInLastMonth: Range<Int>, weekOffset: Int, currDay: Int) -> [CalendarDay] {
        var firstWeek = [CalendarDay]()
        
        if startOfMonthWeekday > 1 {
            let daysFromLastMonth = [daysInLastMonth.last! - (startOfMonthWeekday - 2)...daysInLastMonth.last!]
            
            // first week
            for i in daysFromLastMonth.first!.lowerBound...daysFromLastMonth.first!.upperBound {
                let calendarDay = CalendarDay(day: i, isBeforeCurrentDay: weekOffset > 0 ? false : true)
                firstWeek.append(calendarDay)
            }
        }
        
        self.counter = 1
        while firstWeek.count < 7 {
            let calendarDay = CalendarDay(day: self.counter, isBeforeCurrentDay: weekOffset < 0 ? true : self.counter < currDay, isCurrentDay: self.counter == currDay)
            firstWeek.append(calendarDay)
            self.counter += 1
        }
        
        return firstWeek
    }
    
    private func buildRestOfMonth(currWeeks: [CalendarWeek], currWeek: Int, weekOffset: Int, daysInCurrMonth: Range<Int>, currDay: Int, calendar: Calendar, currDate: Date) -> [CalendarWeek] {
        var weeks = currWeeks
        
        // row
        for week in 1..<5 {
            // column
            var dayList = [CalendarDay]()
            for _ in 0..<7 {
                if self.counter > daysInCurrMonth.last! { break }
                let calendarDay = CalendarDay(day: self.counter, isBeforeCurrentDay:  calendar.isSelectedMonthSameAsRealCurrentMonth(date1: currDate, date2: Date()) ? self.counter < currDay : weekOffset < 0 ? true : self.counter < currDay, isCurrentDay: self.counter == currDay)
                dayList.append(calendarDay)
                self.counter += 1
            }
            
            // start of next month
            if dayList.count < 7 {
                self.counter = 1
                while dayList.count < 7 {
                    let calendarDay = CalendarDay(day: self.counter, isBeforeCurrentDay: weekOffset < 0 ? true : false)
                    dayList.append(calendarDay)
                    self.counter += 1
                }
            }
            
            let calendarWeek = CalendarWeek(week: dayList, isCurrentWeek: week + 1 == currWeek)
            weeks.append(calendarWeek)
        }
        
        return weeks
    }
    
    private func setDayNames(for weeks: [CalendarWeek]) -> [CalendarWeek] {
        var newWeeks = weeks
        
        for weeksIndices in newWeeks.indices {
            for weekIndices in newWeeks[weeksIndices].week.indices {
                newWeeks[weeksIndices].week[weekIndices].dayName = Helper.dayNames[weekIndices]
            }
        }
        
        return newWeeks
    }
    
    func constructCalendar(for weekOffset: Int = 0) {
        var weeksLocal = [CalendarWeek]()
        var currMonthNameLocal: String?
        var currDayOfWeekLocal: Int?
        var currDateLocal: CalendarDate?
        
        
        let calendar = Calendar.current
        var currDate = Date()
        
        currDate = calendar.getDate(for: weekOffset, with: currDate)
        let lastMonthDate = calendar.getDateOfMonthAgo(for: currDate)
        
        let currMonth = calendar.getMonth(for: currDate)
        currMonthNameLocal = Helper().monthToString(currMonth)
        
        let currWeek = calendar.getWeek(for: currDate)
        
        let startOfMonthDate = calendar.getStartOfMonthDate(for: currDate)
        let startOfMonthWeekday = calendar.getWeekday(for: startOfMonthDate)
        
        let daysInfo = calendar.getCurrentDay(with: weekOffset, selectedDate: currDate)
        let currDay: Int = daysInfo.0
        currDayOfWeekLocal = daysInfo.1
        
        let daysInCurrMonth = calendar.getNumDaysInMonth(with: currDate)
        let daysInLastMonth = calendar.getNumDaysInMonth(with: lastMonthDate)
        
        let firstWeek = buildFirstWeekOfMonth(
            startOfMonthWeekday: startOfMonthWeekday,
            daysInLastMonth: daysInLastMonth,
            weekOffset: weekOffset,
            currDay: currDay
        )
        
        let firstCalendarWeek = CalendarWeek(week: firstWeek, isCurrentWeek: currWeek == 1)
        
        weeksLocal.append(firstCalendarWeek)
        
        // rest of the month
        
        weeksLocal = buildRestOfMonth(
            currWeeks: weeksLocal,
            currWeek: currWeek,
            weekOffset: weekOffset,
            daysInCurrMonth: daysInCurrMonth,
            currDay: currDay,
            calendar: calendar,
            currDate: currDate
        )
        
        // set days of the week for all days in the month
        weeksLocal = setDayNames(for: weeksLocal)
        
        currDateLocal = CalendarDate(
            year: CalendarYear(year: calendar.component(.year, from: currDate)),
            month: CalendarMonth(month: currMonth),
            week: weeksLocal.first(where: {$0.isCurrentWeek})!,
            day: CalendarDay(day: currDay)
        )
        
        let model = CalendarModel()
        model.weeks = weeksLocal
        model.currMonthName = currMonthNameLocal
        model.currDayOfWeek = currDayOfWeekLocal
        model.currDate = currDateLocal
        
        self.calendarRelay.accept(model)
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
