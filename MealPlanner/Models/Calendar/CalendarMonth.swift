//
//  CalendarMonth.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/27/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

struct CalendarMonth: Hashable {
    let month: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(month)
    }
}
