//
//  CalendarStore.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import Combine

class CalendarState: ObservableObject {
    var objectWillChange = PassthroughSubject<CalendarState, Never>()
    
    var calendar: CalendarModel = CalendarModel()
    
    init() {
        self.setCalendar()
    }
    
    func setCalendar(for week: Int = 0) {
        self.calendar.clear()
        self.calendar.constructCalendar(for: week)
        objectWillChange.send(self)
    }
}
