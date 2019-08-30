//
//  CalendarDate.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class CalendarDate {
    var year: CalendarYear
    var month: CalendarMonth
    var week: CalendarWeek
    var day: CalendarDay
    
    init() {
        self.year = CalendarYear(year: 0)
        self.month = CalendarMonth(month: 0)
        self.week = CalendarWeek(week: [], isCurrentWeek: false)
        self.day = CalendarDay(day: 0)
    }
    
    convenience init(year: CalendarYear, month: CalendarMonth, week: CalendarWeek, day: CalendarDay) {
        self.init()
        
        self.year = year
        self.month = month
        self.week = week
        self.day = day
    }
}
