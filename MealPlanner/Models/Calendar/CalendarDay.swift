//
//  CalendarDay.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct CalendarDay: Identifiable, Equatable {
    var id = UUID()
    let day: Int
    var dayName: String?
    var isBeforeCurrentDay: Bool = false
    var isCurrentDay: Bool = false
}
