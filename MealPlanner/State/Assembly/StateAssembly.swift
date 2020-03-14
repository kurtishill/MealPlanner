//
//  State Assembly.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/25/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import SwiftDI

class StateAssembly: DIPart {
    var body: some DIPart {
        DIGroup {
            DIRegister(CalendarController.init)
            DIRegister(DateSelectionCache<CacheKey, CacheValue>.init)
                .lifeCycle(.single)
            DIRegister(AppViewModel.init)
                .lifeCycle(.single)
            DIRegister(CalendarState.init)
            DIRegister(WeekDayViewModel.init)
                .lifeCycle(.prototype)
        }
    }
}
