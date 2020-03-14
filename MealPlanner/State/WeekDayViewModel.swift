//
//  WeekDayViewModel.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 3/13/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import SwiftDI
import RxSwift

class WeekDayViewModel: ObservableObject {
    private let bag = DisposeBag()
    
    @Inject var ingredientRepository: IngredientRepository
    @EnvironmentInject var appViewModel: AppViewModel
    
    var ingredientCount: Int = 0
    
    init() {
        self.ingredientRepository.dayIngredientCountObservable
            .observeOn(MainScheduler())
            .subscribe(onNext: { count in
                self.ingredientCount = count
        }).disposed(by: self.bag)
    }
    
    func fetchIngredientCount(for day: CalendarDay) {
        let date = appViewModel.calendarState.calendar.value!.currDate!
        self.ingredientRepository.getIngredientCount(for:
            CalendarDate(
                year: date.year,
                month: date.month,
                day: day
            )
        )
    }
}
