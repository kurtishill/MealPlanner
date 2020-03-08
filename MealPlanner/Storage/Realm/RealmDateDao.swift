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
    func getAllRecipes(for date: DateDto) -> Observable<[RecipeDto]> {
        return Observable.from(object: realm.objects(DateDto.self)
            .first { dateDto in
                dateDto == date
            }!).map { dateDto in
                dateDto.recipes.toArray()
        }
    }
    
    func getAllDateDataForWeek(with date: CalendarDate/*, relay: PublishRelay<[RecipeDto]>*/) -> Observable<[DateDto]> {
        let filterPredicate = NSPredicate(format:
            """
            year == %d and
            month == %d and
            day between {%d,%d}
            """,
            date.year.year,
            date.month.month,
            date.week.week.first!.day,
            date.week.week.last!.day
        )
        
        return Observable.from(optional: realm.objects(DateDto.self).filter(filterPredicate).toArray())
        
//        return Observable.from(optional: realm.objects(DateDto.self).filter(filterPredicate).toArray()).flatMap { (dateDtos) in
//            Observable.just(dateDtos.map { $0.recipes.toArray() })
//        }
        
//        realm.objects(DateDto.self).filter(filterPredicate).observe({ change in
//            switch change {
//            case .initial(let dateDtos):
//                relay.accept(dateDtos.first!.recipes.toArray())
//            case .update:
//                break
//            case .error(_):
//                break
//            }
//        })
    
//        let recipes = realm.objects(DateDto.self).filter(filterPredicate)
//        return Observable.from(optional: recipes)
//            .map({ dateDtoResult in
//                dateDtoResult.first?.recipes.toArray() ?? []
//            }).subscribe(onNext: { (recipeDtos) in
//                relay.accept(recipeDtos)
//            }).disposed(by: bag)
    }
}
