//
//  RxDaoBase.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol RxDaoBase {
    associatedtype T : Object
    
    func create(item: T)
    func get(for key: String) -> T?
    func getAll() -> Observable<[T]>
    func update(item: T)
    func delete(item: T)
}
