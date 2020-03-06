//
//  Extensions.swift
//  MealPlanner
//
//  Created by Kurtis Hill on 2/23/20.
//  Copyright © 2020 Kurtis Hill. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

class RxRealmDao<T> : RxDaoBase where T : Object, T : BaseDto {
    lazy var realm = RealmConnectionFactory.create()
    let bag = DisposeBag()
    
    func create(item: T) {
        transaction(item: item) {
            realm.add(item)
        }
    }
    
    func get(for key: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    func getAll() -> Observable<[T]> {
        return Observable.array(from: realm.objects(T.self))
    }
    
    func update(item: T) {
        transaction(item: item) {
            realm.add(item, update: .modified)
        }
    }
    
    func delete(item: T) {
        transaction(item: item) {
            realm.delete(self.realm.objects(T.self).filter(NSPredicate(format: "id=%@", item.id)))
        }
    }
    
    private func transaction(item: T, _ action: () -> Void) {
        try? realm.safeWrite {
            action()
        }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
