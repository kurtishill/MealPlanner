//
//  CalendarDay.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct CalendarDay: Identifiable, Equatable, Hashable {
    var id = UUID()
    let day: Int
    var dayName: String
    var isSelected: Bool = false
    var isPartOfCurrentMonth: Bool = false
    var isCurrentDay: Bool = false
    
    static func == (lhs: CalendarDay, rhs: CalendarDay) -> Bool {
        return lhs.day == rhs.day &&
            lhs.dayName == rhs.dayName //&&
//            lhs.isPartOfCurrentMonth == rhs.isPartOfCurrentMonth
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
        hasher.combine(dayName)
//        hasher.combine(isPartOfCurrentMonth)
    }
}
