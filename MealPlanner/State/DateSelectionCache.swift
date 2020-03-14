//
//  DateSelectionCache.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/12/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation

class DateSelectionCache<T: Hashable, U: Hashable> {
    var cache = Dictionary<T, U>()
    
    func setSelections(_ selections: U, forKey key: T) {
        cache[key] = selections
    }
    
    func selection(forKey key: T) -> U? {
        if let existingSelection = cache[key] { return existingSelection }
        return nil
    }
}

class CacheKey: Hashable {
    static func == (lhs: CacheKey, rhs: CacheKey) -> Bool {
        return lhs.month == rhs.month && lhs.year == rhs.year
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(month)
        hasher.combine(year)
    }
    
    let month: Int
    let year: Int
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
}

class CacheValue: Hashable {
    static func == (lhs: CacheValue, rhs: CacheValue) -> Bool {
        lhs.dates == rhs.dates
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dates)
    }
    
    var dates: Set<CalendarDate>
    
    init(dates: [CalendarDate]) {
        self.dates = Set(dates)
    }
}
