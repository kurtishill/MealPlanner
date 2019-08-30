//
//  CalendarWeek.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct CalendarWeek: Identifiable {
    var id = UUID()
    var week: [CalendarDay]
    let isCurrentWeek: Bool
}
