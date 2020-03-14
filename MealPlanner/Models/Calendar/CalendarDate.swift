//
//  CalendarDate.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class CalendarDate: Equatable, Hashable {
    static func == (lhs: CalendarDate, rhs: CalendarDate) -> Bool {
        return lhs.year.year == rhs.year.year &&
            lhs.month.month == rhs.month.month &&
            lhs.day == rhs.day
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }
    
    var id: String {
        String((year.year + month.month + day.day) * 31)
    }
    var year: CalendarYear
    var month: CalendarMonth
    var day: CalendarDay
    
    init() {
        self.year = CalendarYear(year: 0)
        self.month = CalendarMonth(month: 0)
        self.day = CalendarDay(day: 0, dayName: "")
    }
    
    convenience init(year: CalendarYear, month: CalendarMonth, day: CalendarDay) {
        self.init()
        
        self.year = year
        self.month = month
        self.day = day
    }
    
    var description: String {
        return "\(Helper.monthToString(self.month.month)) \(self.day.day), \(self.year.year)"
    }
}
