//
//  CalendarStore.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI

class CalendarStore: ObservableObject {
    var calendar: CalendarModel = CalendarModel()
    
    init() {
        self.initCalendar()
    }
    
    func initCalendar() {
        self.calendar.constructCalendar()
    }
}
