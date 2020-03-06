//
//  RxDateDao.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol RxDateDao {
    func getAllRecipes(for date: DateDto) -> Observable<[RecipeDto]>
    func getAllDateDataForWeek(with date: CalendarDate/*, relay: PublishRelay<[RecipeDto]>*/) -> Observable<[DateDto]>
}
