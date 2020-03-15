//
//  CalendarStore.swift
//  Calendar
//
//  Created by Kurtis Hill on 8/26/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import SwiftUI
import Combine
import RxSwift
import RxRelay
import SwiftDI

class CalendarState {
    private let bag = DisposeBag()
    
    @Inject var controller: CalendarController
    @Inject var dateSelectionCache: DateSelectionCache<CacheKey, CacheValue>
    
    let calendar: BehaviorRelay<CalendarModel?> = BehaviorRelay(value: nil)
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let daySelectionRelay: PublishRelay<CalendarDate> = PublishRelay()
    
    var calendars: [CalendarModel] = []
    
    init() {
        self.controller.calendarObservable
            .subscribe(onNext: { calendarModel in
                print("calendar algo finished")
                self.loading.accept(false)
                self.calendar.accept(calendarModel)
                
                self.calendars.append(calendarModel)
                self.sortCalendars()
                
                let key = CacheKey(
                    month: calendarModel.currDate!.month.month,
                    year: calendarModel.currDate!.year.year
                )
                
                if let dates = self.dateSelectionCache.selection(forKey: key)?.dates {
                    for date in dates {
                        self.daySelected(date.day, updateCache: false)
                    }
                }
            }).disposed(by: bag)
        
        initializeCalendarList()
    }
    
    func initializeCalendarList() {
        setCalendar(month: nil, year: nil)
        lastMonthTapped()
        nextMonthTapped()
    }
    
    func sortCalendars() {
        self.calendars.sort { (m0, m1) -> Bool in
            return m0.currDate!.month.month < m1.currDate!.month.month &&
                m0.currDate!.year.year <= m1.currDate!.year.year
        }
    }
    
    func nextMonthTapped() {
        if let currDate = calendar.value?.currDate {
            var month = currDate.month.month
            var year = currDate.year.year
            
            if month == 12 {
                year += 1
                month = 1
            } else {
                month += 1
            }
            
            setCalendar(month: month, year: year)
        }
    }
    
    func lastMonthTapped() {
        if let currDate = calendar.value?.currDate {
           var month = currDate.month.month
           var year = currDate.year.year
            
            if month == 1 {
                year -= 1
                month = 12
            } else {
                month -= 1
            }
            
            setCalendar(month: month, year: year)
        }
    }
    
    func daySelected(_ day: CalendarDay, updateCache: Bool = true) {
        let c = self.calendar.value
        var newCalendar: CalendarModel
        if let calendarModel = c {
            newCalendar = calendarModel
            for weeksIndex in newCalendar.weeks.indices {
                var found = false
                for index in newCalendar.weeks[weeksIndex].week.indices {
                    if newCalendar.weeks[weeksIndex].week[index].day == day.day &&
                        newCalendar.weeks[weeksIndex].week[index].isPartOfCurrentMonth {
                        
                        newCalendar.weeks[weeksIndex].week[index].isSelected.toggle()
                        
                        let date = CalendarDate(
                            year: newCalendar.currDate!.year,
                            month: newCalendar.currDate!.month,
                            day: newCalendar.weeks[weeksIndex].week[index]
                        )
                        
                        if updateCache {
                            self.updateCache(
                                month: newCalendar.currDate!.month.month,
                                year: newCalendar.currDate!.year.year,
                                date: date
                            )
                        }
                        
                        self.daySelectionRelay.accept(date)
                        
                        found = true
                        break
                    }
                }
                if found { break }
            }
        }
    }
    
    func setCalendar(month: Int?, year: Int?) {
        self.loading.accept(true)
        DispatchQueue.global(qos: .background).async {
            self.controller.constructCalendar(month: month, year: year)
        }
    }
    
    private func updateCache(month: Int, year: Int, date: CalendarDate) {
        let key = CacheKey(month: month, year: year)
        if let value = dateSelectionCache.selection(forKey: key) {
            if value.dates.contains(date) {
                value.dates.remove(date)
            } else {
                value.dates.insert(date)
            }
            dateSelectionCache.setSelections(value, forKey: key)
        } else {
            dateSelectionCache.setSelections(CacheValue(dates: [date]), forKey: key)
        }
    }
}
