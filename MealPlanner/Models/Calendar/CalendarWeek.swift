//
//  CalendarWeek.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct CalendarWeek: Identifiable, Equatable, Hashable {
    var id = UUID()
    var week: [CalendarDay]
    var isCurrentWeek: Bool = false
    
    static func == (lhs: CalendarWeek, rhs: CalendarWeek) -> Bool {
        for index in lhs.week.indices {
            if lhs.week[index] != rhs.week[index] {
                return false
            }
        }
        return true
    }
}
