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
    
    let calendar: BehaviorRelay<CalendarModel?> = BehaviorRelay(value: nil)
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init() {
        self.controller.calendarObservable
            .subscribe(onNext: { calendarModel in
                print("calendar algo finished")
                self.loading.accept(false)
                self.calendar.accept(calendarModel)
            }).disposed(by: bag)
        
        setCalendar(for: 0)
    }
    
    func setCalendar(for week: Int = 0) {
        self.loading.accept(true)
        DispatchQueue.global(qos: .background).async {
            self.controller.constructCalendar(for: week)
        }
    }
}
