//
//  DateDao.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/22/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift

protocol DateDao {
    func createDate(_ date: DateDto) -> Single<Bool>
}
