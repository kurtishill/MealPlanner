//
//  RealmDateDao.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift
import RxRelay

class RealmDateDao: RxRealmDao<DateDto>, RxDateDao {
    func getDate(_ date: CalendarDate) -> Observable<DateDto> {
        let filterPredicate = NSPredicate(format: """
            year == %d and
            month == %d and
            day == %d
            """,
            date.year.year,
            date.month.month,
            date.day.day
        )
        
        return Observable.from(optional: realm.objects(DateDto.self).filter(filterPredicate).first)
    }
    
    func getDates(_ dates: [CalendarDate]) -> Observable<[DateDto]> {
        return Observable.from(optional: realm.objects(DateDto.self).filter({ dateDto -> Bool in
            return dates.contains(where: { calendarDate -> Bool in
                return calendarDate.day.day == dateDto.day &&
                    calendarDate.year.year == dateDto.year &&
                    calendarDate.month.month == dateDto.month
            })
        }))
    }
}
