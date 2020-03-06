//
//  CalendarModel.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/29/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation

class CalendarModel: Equatable {
    static func == (lhs: CalendarModel, rhs: CalendarModel) -> Bool {
        return lhs.currDayOfWeek == rhs.currDayOfWeek &&
            lhs.currMonthName == rhs.currMonthName &&
            lhs.currDate == rhs.currDate
    }
    
    var weeks: [CalendarWeek] = []
    var currMonthName: String?
    var currDayOfWeek: Int?
    var currDate: CalendarDate?
}
